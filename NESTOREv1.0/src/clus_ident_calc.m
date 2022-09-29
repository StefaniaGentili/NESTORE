function [mCatDecluster, mCatAfter, vCluster, vCl, vMainCluster] = clus_ident_calc(mCatalog,form_space,form_time, ThM, Thwt,form_time2)
% ----------------------------------------------------------------------------------------------------------
% 
% Function for cluster identification using the Windowing technique in
% space and time extracted and modified from Zmap code 
% 
% INPUT
% mCatalog   : Input earthquake catalog (ZMAP format)
% form_space : equation of the space window
% form_time  : equation of the time window
% ThM        : threshold for minimum mainshock to be considered
% Thwt       : threshold for different time window to be considered 
%              depending on magnitude; if the equation is magnitude
%              independent set this threshold to a very small value (e.g.
%              -20) and set form_time2=form_time
% form_time2  : equation of the time window for M>=Thwt
%
% 
% OUTPUT
% mCatDecluster : Declustered earthquake catalog
% mCatAfter     : Catalog of aftershocks (and foreshocks)
% vCluster      : Vector indicating only aftershocks/foreshocls in cluster using a cluster number
% vCl           : Vector indicating all events in clusters using a cluster number
% vMainCluster  : Vector indicating mainshocks of clusters using a cluster number
%
% Modified from calc_decluster.m by J. Woessner, 
% woessner@seismo.ifg.ethz.ch (last update: 29.08.02)
%
% S. Gentili sgentili@ogs.it modified
% last update: 08.06.2022 

% Changes by S. Gentili 
% 28.3.11 eliminated input variable nMethod of Zmap - pre defined methods - 
%         substituted by and form_space,form_time (user windows)
% 28.3.11 corrected an error in distance determination: old version distance(lon,lat,lon1,lat1)
%         new version distance(lat,lon,lat1,lon1) 
% 26.03.20 added as input ThM (minimum magnitude for mainshocks)
% 26.03.20 added as input Thwt and form_time2 for multiple choices of time windows
%          dependent on mainshock magnitude
% 22.10.21 moved vectors inizialize and changed length(mCatalog) into
%          nXSize (fixes bugs for very small catalogues and avoid multiple
%          unuseful calculations)
% 08.06.22 Minor changes to eliminate unused variables

% call to clus_ident_calc_wind


% Initialize Vectors and Matrices
mCatDecluster = [];
mCatAfter = [];


[nXSize, ~] = size(mCatalog);
if nXSize == 0
    disp('Load new catalog');
    return
end

vCluster = zeros(nXSize,1); % Initialize all events as mainshock
vCl = zeros(nXSize,1); % Initialize all events as mainshock
vSel = zeros(nXSize,1); % Initialize all events as mainshock
vMainCluster = zeros(nXSize,1); % Initialize

vDecDate = mCatalog(:,3);
nCount = 0;    % Variable of cluster number

fMagThreshold = min(mCatalog(:,6)); % Set Threshold to minimum magnitude of catalog
hWaitbar1 = waitbar(0,'Identifying clusters...');

set(hWaitbar1,'Numbertitle','off','Name','Clusters Identification percentage');
for nEvent=1:length(mCatalog(:,6))  
    %nEvent
    %nCount
    if vCluster(nEvent) == 0
        fMagnitude(nEvent) = mCatalog(nEvent, 6);
        if fMagnitude(nEvent) >= fMagThreshold
            % Define first aftershock zone and determine magnitude of strongest aftershock
            fMag = fMagnitude(nEvent);
            [fSpace, fTime] = clus_ident_calc_wind(fMagnitude(nEvent),form_space,form_time,ThM, Thwt,form_time2);
            fSpaceDeg = km2deg(fSpace);
            % This first if is for events with no location given
            if isnan(mCatalog(nEvent,1))
                %vSel = (vDecDate(:,1)-vDecDate(nEvent,1) >= 0) & (vDecDate(:,1)-vDecDate(nEvent,1) <= fTime  & vCluster(nEvent) == 0);
                vSel = (mCatalog(:,3) == mCatalog(nEvent,3));
            else              
                mPos = [mCatalog(nEvent, 1) mCatalog(nEvent,2)];
                mPos = repmat(mPos,length(mCatalog(:,1)), 1);
                %corrected an error in distance determination: old version distance(lon,lat,lon1,lat1)
                %new version distance(lat,lon,lat1,lon1) 
                %mDist = abs(distance(mCatalog(:,1), mCatalog(:,2), mPos(:,1), mPos(:,2)));
                mDist = abs(distance( mCatalog(:,2),mCatalog(:,1), mPos(:,2), mPos(:,1)));
                vSel = ((mDist <= fSpaceDeg) & (vDecDate(:,1)-vDecDate(nEvent,1) >= 0) &...
                    (vDecDate(:,1)-vDecDate(nEvent,1) <= fTime) & vCluster(nEvent) == 0);          
            end % End of isnan(mCatalog)
            mTmp = mCatalog(vSel,:);
            if length(mTmp(:,1)) > 1  % Only one event thus no cluster; 
                fMaxClusterMag = max(mTmp(:,6));
                [nIndiceMaxMag] = find(mTmp(:,6) == fMaxClusterMag);
                % Search for event with bigger magnitude in cluster and add to cluster
                while fMaxClusterMag-fMag > 0
                    [fSpace, fTime] = clus_ident_calc_wind(fMaxClusterMag,form_space,form_time,ThM,Thwt,form_time2);
                    fSpaceDeg = km2deg(fSpace);
                    % Adding aftershocks from bigger aftershock
                    mPos = [mTmp(min(nIndiceMaxMag),1) mTmp(min(nIndiceMaxMag),2)];
                    mPos = repmat(mPos,length(mCatalog(:,1)), 1);
                    %corrected an error in distance determination: old version distance(lon,lat,lon1,lat1)
                    %new version distance(lat,lon,lat1,lon1)  
                    %mDist = abs(distance(mCatalog(:,1), mCatalog(:,2), mPos(:,1), mPos(:,2)));
                    mDist = abs(distance( mCatalog(:,2),mCatalog(:,1), mPos(:,2), mPos(:,1)));
                    vSel2 = ((mDist <= fSpaceDeg) & (vDecDate(:,1)-mTmp(min(nIndiceMaxMag),3) >= 0) &...
                        (vDecDate(:,1)-mTmp(min(nIndiceMaxMag),3) <= fTime) & vCluster == 0);
                    mTmp = mCatalog(vSel2,:);
                    vSel = (vSel > 0 | vSel2 > 0); % Actual addition
                    if isempty(mTmp) % no events in aftershock zone 
                        break;
                    end
                    fMag = fMaxClusterMag;
                    fMaxClusterMag = max(mTmp(:,6));
                    [nIndiceMaxMag] = find(mTmp(:,6) == fMaxClusterMag);
                    if fMaxClusterMag - fMag == 0 % no bigger event in aftershock zone
                        break;
                    end
                end % End of while
                nCount = nCount + 1; % Set cluster number
            end % End of if length(mTmp)

            [vIndice]=find(vSel); % Vector of indices with Clusters
            vTmpCluster(vIndice,:) = nCount;
            %length(vTmpCluster(vIndice,:));
            nI=1; % Variable counting the length of the cluster
            % Select the right numbers for the cluster using the indice vector vIndice
            % First: Insert cluster number after check for length
            % Second: Check if it's a mainshock
            % Third: Keep the former cluster indice;
            while nI <= length(vIndice)
                if (~isempty(vTmpCluster(vIndice(nI))) & length(vTmpCluster(vIndice,:)) > 1 & vCluster(vIndice(nI)) == 0)
                    vCluster(vIndice(nI)) = vTmpCluster(vIndice(nI));
                    %vEventnr(vIndice,:) = nEvent;
                elseif  (~isempty(vTmpCluster(vIndice(nI))) & length(vTmpCluster(vIndice,:)) == 1 & vCluster(vIndice(nI)) == 0)
                    vCluster(vIndice(nI)) = 0;
                else
                    vCluster(vIndice(nI)) = vCluster(vIndice(nI));
                end
                nI=nI+1;
            end %End of while nI
            %                 nCount = nCount + 1; % Set cluster number %% Watch
            %             end; % End of if to determine cluster or not %% Watch
            %%% Check if the Cluster is not just one event which can happen in case of keeping the former 
            %%% cluster number in preceeding while-Loop
            vSelSingle = (vCluster == nCount);
            [vIndiceSingle] = find(vSelSingle);
            %vTmpSingle(vIndiceSingle,:);
            if length(vIndiceSingle) == 1
                %nCount
                %vIndiceSingle
                vCluster(vIndiceSingle)=0; % Set the event as mainsock
                nCount = nCount-1; % Correct the cluster number down by one
            end
        end % End of if checking magnitude threshold fMagThreshold
    end % End of if checking if vCluster == 0 
    if rem(nEvent,100) == 0
        waitbar(nEvent/length(mCatalog(:,6)))
    end % End updating waitbar
end % End of FOR over mCatalog 
close(hWaitbar1);
%nCount
% vCL Cluster vector with mainshocks in it; vCluster is now modified to get rid of mainshocks
vCl = vCluster; 

% Matrix with cluster indice, magnitude and time 
mTmpCat = [vCluster mCatalog(:,6) mCatalog(:,3)];
% Delete largest event from cluster series and add to mainshock catalog
hWaitbar2 = waitbar(0,'Identifying mainshocks in clusters...');
set(hWaitbar2,'Numbertitle','off','Name','Mainshock identification ');
for nCevent = 1:nCount
    %nCevent
    vSel4 = (mTmpCat(:,1) == nCevent); % Select cluster 
    mTmpCat2 = mCatalog(vSel4,:); 
    fTmpMaxMag = max(mTmpCat2(:,6)); % Select max magnitude of cluster
    vSelMag = (mTmpCat2(:,6) == fTmpMaxMag);
    [nMag] = find(vSelMag);
    if length(nMag) == 1
        vSel5 = (mTmpCat(:,1) == nCevent & mTmpCat(:,2) == fTmpMaxMag); % Select the event
        [vIndiceMag] = find(vSel5); % Find indice 
        vCluster(vIndiceMag) = 0;  % Set cluster value to zero, so it is a mainshock
        vMainCluster(vIndiceMag) = nCevent; % Set mainshock vector to cluster number
    elseif isempty(nMag)
        disp('Nothing in ')
        nCevent
    else
        vSel = (mTmpCat(:,1) == nCevent & mTmpCat(:,2) == fTmpMaxMag);
        [vIndiceMag] = min(find(vSel)); % Find minimum indice of event with max magnitude in cluster
        vCluster(vIndiceMag) = 0;  % Set cluster value to zero, so it is a mainshock
        vMainCluster(vIndiceMag) = nCevent;  % Set mainshock vector to cluster number
    end
    if rem(nCevent,20) == 0
        waitbar(nCevent/nCount);
    end % End updating waitbar
end % End of For nCevent
close(hWaitbar2);
% Create a catalog of aftershocks (mCatAfter) and of declustered catalog (mCatDecluster)
vSel = (vCluster(:,1) > 0);
mCatDecluster=mCatalog(~vSel,:);
mCatAfter = mCatalog(vSel,:);



