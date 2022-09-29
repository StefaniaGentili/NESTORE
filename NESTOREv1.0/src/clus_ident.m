function [mCatalog2, mCatDecluster, mCatAfter, mCatMain, vCluster, vCl, vMainCluster]= clus_ident(filein, fileout, form_space,form_time, ThM, Thwt,form_time2,coeff_space_fore,coeff_time_fore,module_type)

% Detects the clusters in a catalogue by a window-based method. 
% Calls clus_ident_calc.m extracted and adapted
% from Zmap function by J. Woessner calc_decluster.m but with several
% changes/improvements for NESTORE software:

% - Bug fixing (lat and lon inverted in the original function)
% - Added form_space,form_time, ThM, Thwt,form_time2 in input for
%   aftershock window determination
%
% Once the clusters have been identified by clus_ident_calc: 
%   - selects as maishock the first shock with magnitude > ThM if there is 
%     no other shock with M>ThM in thefollowing 6 hours. Otherwise, the 
%     following strong earthquake is selected as mainshock. 
%   - The following earthquakes are considered "aftershocks". 
%   - All the earthquakes within a circular time window,estimated from 
%     coeff_space_fore,coeff_time_fore are considered foreshocks

%
% INPUT:
% filein      = Input file in Zmap format
% fileout     = output file containing information on mainshock, 
%               aftershocks, foreshocks and clusters
% form_space  = equation for space window [km]
% form_time   = equation for time window [days]
% ThM         = minimum magnitude for considered mainshocks
% Thwt        = threshold on mainshock magnitude for possible different
%               time window
% form_time2  = equation for time window for Mm>=Thwt
% module_type = specifies the calling module type


% e.g. Gardnaer & Knopoff low:
%      form_space = 10^(0.1238*fMagnitude+0.983)
%      form_time  = 10^(0.5409*fMagnitude-0.547)
%      Thwt       = 6.5
%      form_time2 = 10^(0.032*fMagnitude+2.7389)
%      

% OUTPUT
% mCatalog2     : Original catalogue
% mCatDecluster : Declustered earthquake catalog
% mCatAfter     : Catalog of aftershocks (and foreshocks)
% mCatMain      : Parameters of the last analyzed mainshock
% vCluster      : Vector indicating only aftershocks/foreshocls in cluster using a cluster number
% vCl           : Vector indicating all events in clusters using a cluster number
% vMainCluster  : Vector indicating mainshocks of clusters using a cluster number
%

% fileout FORMAT:
% mainshock                        = 0 day, month, day, hour, minute, round(second), M, lat, lon, round(depth)
% aftershock                       = 1 day, month, day, hour, minute, round(second), M, lat, lon, round(depth)
% info on the stronger aftershock  = 2 day, month, day, hour, minute, round(second), M, lat, lon, round(depth)
% info on cluster                  = 3 Naft,  dt,   type, Mc,  dMc, NaN, NaN, NaN, NaN, NaN
% foreshock                        = 4 day, month, day, hour, minute, round(second), M, lat, lon, round(depth)
%
% type = 1 for A cluster (DM<=1) = 0 for B cluster (DM>1)
% Mc e dMc evaluated using Zmap functions (maximum curvature+bootstrap)
% soonly if at least 80 events are available in the cluste; otherwise NaN
%
%
% calls leapyear.m, calc_decluster_ste2.m 
% clus_ident_calc.m

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.

% Authors:
% S. Gentili, sgentili@ogs.it
% P. Brondi,  pbrondi@ogs.it
% License: GNUGPLv3
% Last update: September 21, 2022
fprintf('\n\nThis is clus_ident.m\n\n');


% set paths depending on the function which calls clus_ident2
if strcmp(module_type,'nrt')==1
    filein=fullfile('../data/Catalogs/',filein);
    fileout=fullfile('../data/Nrt_Output/',fileout);
else
    filein=fullfile('../data/Catalogs/',filein);
    fileout=fullfile('../data/Clusters/',fileout);
end



% Default values for Mc estimation
nBstSample = 100;
fBinning = 0.1;
fMccorr = 0.2;
Nmin=80;
nMethod=1;

%read catalogue file in  Zmap format
[lon, lat, year, month, day, ml,depth, hour, minute, second] = textread(filein,'%f %f %d %d %d %f %f %d %d %f');


le=length(year);

%generates the DecDate vector with decimal year
DecDate=year*0;

for(i=1:le)
    datesec=date2unixsecs(year(i), month(i), day(i), hour(i), minute(i), second(i));
    ddatesec=datesec-date2unixsecs(year(i),1,1);
    ddatesecy=ddatesec/((365+leapyear(year(i)))*24*3600);
    DecDate(i)=year(i)+ddatesecy;

    second(i)=round(second(i));
    if(second(i)==60)   
        second(i)=0;       
        minute(i)=minute(i)+1;
    end   
end


% Ordering the time axis and the catalogue; if repeated earthquakes takes
% the last
[C,u,ic] = unique(DecDate,'last','legacy');


DecDate=DecDate(u);
lat=lat(u);
lon=lon(u);
ml=ml(u);
depth=depth(u);
year=year(u);
month=month(u);
day=day(u);
hour=hour(u);
minute=minute(u);
second=second(u);

mCatalog=[lon,lat,DecDate,month,day,ml,depth,hour,minute,second];

% Stores mCatalog into mCatalog2
mCatalog2=mCatalog;

[mCatDecluster, mCatAfter, vCluster, vCl, vMainCluster] = clus_ident_calc(mCatalog,form_space,form_time, ThM, Thwt,form_time2);

fid=fopen(fileout,'w');

%if the nrt module is applied, only the first cluster is analyzed;
%otherwise, all the clusters are analyzed
if strcmp(module_type,'nrt')==1
    k_end=1;
else
    k_end=max(vCl);
end


for(k=1:k_end)
    
    % k-th cluster analysis
    u=find(vCl==k);
    if(~isempty(u))
        if(length(u)>1)
            
            % Selects the k-th cluster's events
            latk=lat(u);
            lonk=lon(u);
            mlk=ml(u);
            depthk=depth(u);
 
            yeark=year(u);
            monthk=month(u);
            dayk=day(u);
            hourk=hour(u);
            minutek=minute(u);
            secondk=second(u);
            DecDatek=DecDate(u);
            
            
            %selects mainshock's parameters
            v=find(mlk>=ThM);
            if(isempty(v))
                fprintf('ERROR: Repeated event %d/%d/%d %d:%d:%d\n', dayk(1),monthk(1), yeark(1), hourk(1), minutek(1),round(secondk(1)));
                fprintf('Check Input Catalog!\n')
            end
            
            % if a stonger event is within the first 6 hours after the
            % first event with M>=ThM, this event is set as mainshock
            if(length(v)>1)
                strong=mlk(v);
                uu=find(strong==max(strong));
                if length(uu)>1
                    uu=uu(1);
                end
                if(uu~=1)
                    
                    yearp=floor(DecDatek(v(uu)));
                    leapy = rem(fix(yearp),4) == 0 & rem(fix(yearp),100) ~= 0 | rem(fix(yearp),400) == 0;
                    if(leapy)
                        days=366;
                    else
                        days=365;
                    end
                    diti=(DecDatek(v(uu))-DecDatek(v(1)))*days*24;
                    if(diti<6)
                        fprintf('Mainshock within 6 hours after M>%.1f\n',ThM)
                        v=v(uu);
                    else
                        v=v(1);
                    end
                else
                    v=v(1);
                end
            end
            
            
            %mainshock's parameters
            latkm=latk(v);
            lonkm=lonk(v);
            mlkm=mlk(v);
            depthkm=depthk(v);
            yearkm=yeark(v);
            monthkm=monthk(v);
            daykm=dayk(v);
            hourkm=hourk(v);
            minutekm=minutek(v);
            secondkm=secondk(v);
            DecDatekm=DecDatek(v);
            
            mCatMain=[lonkm,latkm,DecDatekm,monthkm,daykm,mlkm,depthkm,hourkm,minutekm,secondkm];
            
            fprintf('\n##############################\n');
            
            % Prints mainshock informations on the screen
            fprintf('%d/%d/%d %d:%d:%d\n', daykm,monthkm, yearkm, hourkm, minutekm, round(secondkm));
            fprintf('Mainshock magnitude %.1f\n', mlkm);
            
            
            % Prints a 0-digit before writing mainshock info on the output file
            fprintf(fid,'0 %d %d %d %d %d %d ', daykm,monthkm, yearkm, hourkm, minutekm, round(secondkm) );
            fprintf(fid, '%.1f %.2f %.2f %d\n', mlkm, latkm, lonkm, round(depthkm));
            
            
            
            % Initializes the catalog to calculate the completeness magnitude
            mCatalog=[];
            
            
            for(i=v+1:length(u))
                % Prints aftershocks information on the screen
                %fprintf('%d/%d/%d %d:%d:%d\n', dayk(i),monthk(i), yeark(i), hourk(i),minutek(i),round(secondk(i)));
                
                % Prints a 1-digit before writing aftershocks info on the 
                % output file
                fprintf(fid,'1 %d %d %d %d %d %d ', dayk(i),monthk(i), yeark(i), hourk(i),minutek(i),round(secondk(i)));
                fprintf(fid, '%.1f %.2f %.2f %d\n', mlk(i), latk(i), lonk(i), round(depthk(i)));
                
                % Writes informations in mCatalog
                mCatalog=[mCatalog; [NaN,NaN,yeark(i),monthk(i),dayk(i),mlk(i), NaN, hourk(i),minutek(i),secondk(i)]];       
            end
            
            
            
            
            
            if(~isempty(mlk(v+1:end)))
                ma=max(mlk(v+1:end));
                
                y=find(mlk==ma);
                
                    % If the mainshock or a foreshock
                    % has the same magnitude of the strongest
                    % aftershock,takes the strongest aftershock
                    w=find(y>v);
                    y=y(w:end);

                
                % Prints strongest aftershocks information on the screen
                fprintf('%d/%d/%d\n', dayk(y(1)),monthk(y(1)), yeark(y(1)));
                fprintf('strongest aftershock: M=%.1f \n',ma);
                
                % Prints a 2-digit before writing the strongest aftershock
                % info on the output file
                fprintf(fid, '2 %d %d %d %d %d %d ', dayk(y(1)),monthk(y(1)), yeark(y(1)), hourk(y(1)), minutek(y(1)),round(secondk(y(1))));
                fprintf(fid, '%.1f ',ma);
                
                
                
                la=latk(y(1));
                lo=lonk(y(1));
                de=depthk(y(1));
                fprintf('Lat aft =%.2f Lon aft=%.2f Depth aft= %d\n', la,lo, round(de));
                fprintf(fid, '%.2f %.2f %d\n', la,lo, round(de));
                
                
                % In the last raw Naft,dt, type, Mc, dMc are reported
                % jointly with NaN to complete the entire raw length.
                
                
                % Number of aftershocks in the spatio-temporal window with
                % magnitude >=0.1 
                Naft=length(u)-v;
                
                % Prints a 3-digit before writing the strongest aftershock
                % info on the output file
                fprintf(fid,'3 %d ',Naft);
                
                DecDateka=DecDatek(y(1));
                
                % time difference between the mainshock and the stringest 
                % aftershock (check for leap year included)
                dt=(DecDateka-DecDatekm)*(365+leapyear(floor(DecDatekm)));
                fprintf('distance in time from mainshock: %.2f days\n',dt);
                
                fprintf(fid,'%.2f ',dt);
                
                %Type
                if(ma>=mlkm-1)
                    fprintf('A-type cluster\n\n');
                    fprintf(fid,'1 ');
                else
                    fprintf('B-type cluster\n\n');
                    fprintf(fid,'0 ');
                end
                
                % The completeness magnitude is evaluated only if the 
                % number of earthquakes in the cluster is greather than 
                % Nmin,  otherwise set to NaN
                if(Naft>=Nmin)
                    
                    % Maximum Curvature Method with 0.2 Magnitude correction
                    Mc=calc_Mc(mCatalog, nMethod,0.1,0.2);
                    
                    
                    [fMc, fStd_Mc, fBValue, fStd_B, fAValue, fStd_A, vMc, mBvalue] = calc_McBboot(mCatalog, fBinning, nBstSample, nMethod, Nmin, fMccorr);
                    
                    fprintf('Mc=%.1f +/- %.1f\n',Mc, fStd_Mc);
                    fprintf(fid, '%.1f %.1f ', Mc, fStd_Mc);
                else
                    fprintf('Number of events is below %d: \n', Nmin);
                    fprintf('Mc is not calculated\n');
                    fprintf(fid, 'NaN NaN ');
                end
                fprintf(fid, 'NaN NaN NaN NaN NaN\n');
            else
                fprintf('Strongest event within 6 hours not followed by events\n');
            end
        else
            fprintf('No aftershocks in the cluster\n');      
        end
        
        
        
        
        %foreshock radius
        fMagnitude=mlkm;
        maxrad=coeff_space_fore*eval(form_space);

        
        
        %foreshock time window
        s1=DecDatekm-coeff_time_fore;
        
        
        % Selects the time window 
        timeN=find(DecDate>=s1 & DecDate<DecDatekm);
       
        
        DecDatef=DecDate(timeN);
        latf=lat(timeN);
        lonf=lon(timeN);
        mlf=ml(timeN);
        depthf=depth(timeN);
        yearf=year(timeN);
        monthf=month(timeN);
        dayf=day(timeN);
        hourf=hour(timeN);
        minutef=minute(timeN);
        secondf=second(timeN);
        
        
        
        
        
        
        % Selects the events within the time window
        distok=[];
        for(j=1:length(latf))
            a=latf(j);
            b=lonf(j);
            rd1(j) = distance(latkm,lonkm,a,b);
            rkm1(j)=deg2km(rd1(j));
            
            if(rkm1(j)<=maxrad)
                distok=[distok,j];
            end
            
        end
        
        
        DecDatef=DecDatef(distok);
        latf=latf(distok);
        lonf=lonf(distok);
        mlf=mlf(distok);
        depthf=depthf(distok);
        yearf=yearf(distok);
        monthf=monthf(distok);
        dayf=dayf(distok);
        hourf=hourf(distok);
        minutef=minutef(distok);
        secondf=secondf(distok);
        
        
        
        for(i=1:length(DecDatef))
            % Prints foreshocks information on the screen
            %fprintf('%d/%d/%d %d:%d:%d\n', dayf(i),monthf(i), yearf(i), hourf(i),minutef(i),round(secondf(i)));
            % Prints a 4-digit before writing foreshocks info on the output file
            fprintf(fid,'4 %d %d %d %d %d %d ', dayf(i),monthf(i), yearf(i), hourf(i),minutef(i),round(secondf(i)));
            fprintf(fid, '%.1f %.2f %.2f %d\n', mlf(i), latf(i), lonf(i), round(depthf(i)));
            
        end
    end
    
end
fclose(fid);
