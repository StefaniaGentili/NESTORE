function [nclus,nclusA,nclusB]=feacalc_stop_ti(filein, fileout,interv, label, vb, PL,Zth, start_time,end_time,yearchMc,Mc1,Mc2,module_type)
% Calculates the features for the input time interval.
% It selects only the clusters inside the input polygon PL, above the input
% depth Zth and within the given interval start_time-end_time.
% The cluster events having DM value between 0.8 and 1.2 are removed.
%
% filein  = Clusters File
% fileout = feature file name for a given T(i)
% interv  = Time Inteval after the available mainshock (in seconds)
% label   = Selection on clusters characteristics as follows:
%         = 0, all clusters
%         = 1, clusters of Mm-Mc>=3. They can be class type B or class type
%           A with dt>time
%         = 2, clusters of Mm-Mc>=2. They can be class type B or class type
%           A with dt>time (corresponding to current NESTORE version)
% vb      = vector with the start time of good interval and time
%           corrisponding to the maximum of informedness.
% PL      = polygon in which the analysis is performed
% Zth     = maximum depth
% start_time  = starting year to consider the mainshock
% end_time    = ending year to consider the mainshock
% yearchMc    = year of Mc change
% Mc1         = default completeness magnitude for year < yearchMc
% Mc2         = default completeness magnitude for year >= yearchMc
% module_type = specifies the calling module type

% OUTPUT:
% nclus      = vector containing the number of clusters available for the current Ti
% nclusA      = vector containing the number of A clusters available for the current Ti
% nclusB      = vector containing the number of B clusters available for the current Ti

% In this version, features are calculated starting 1 minute after the mainshock.
% PLEASE NOTE: For each A-type cluster features are calculated until the
% occurrence of the first aftershock having Magnitude >Mm-1;
% This event can occur before the strongest aftershock.

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.

% S. Gentili, sgentili@ogs.it
% pbrondi@ogs.it
% License: GNUGPLv3
% last change September 22, 2022


% PLEASE NOTE: in the lines starting with 3, corresponding to cluster
% information, Naft, dt, type(0->B, 1->A), Mc and dMc are
% listed in correspondence of day, month, year, hour, minute fields


[type, day, month, year, hour, minute, second, ml, lat, lon,depth] = textread(filein,'%d %f %f %f %f %f %d %f %f %f %d');

% Search for the indexes of mainshocks
main=find(type==0);

%Search for the indexes of aftershocks
aft=find(type==1);

%Search for the indexes of foreshocks
fore=find(type==4);

%Search for the indexes of the stronger aftershocks
aftM=find(type==2);

%Search for the indexes of the cluster information
info=find(type==3);

le=length(year);
jd=year*0;
for(i=1:le)
    jd(i)=date2unixsecs(year(i), month(i), day(i), hour(i), minute(i), second(i));
end

%fileout=fullfile('../data/Output/',fileout);
fid=fopen(fileout,'w');



nclus=0;
nclusA=0;
nclusB=0;

for(k=1:length(main))
    
    %  Origin Time, Magnitude and Location of the main event
    maintime=jd(main(k));
    mainmag=ml(main(k));
    LatNs=lat(main(k));
    LonEs=lon(main(k));
    
    
    % mmin value is set to mainmag-3 and only events after the mainshock are considered
    mmin=mainmag-3;
    
    
    % Aftershocks, the strongest aftershock and their correspondent info are selected
    if(k<length(main))
        u=find(aft>main(k) & aft<main(k+1));
        v=find(aftM>main(k) & aftM<main(k+1));
        w=find(info>main(k) & info<main(k+1));
        y=find(fore>main(k) & fore<main(k+1));
    else
        u=find(aft>main(k));
        v=find(aftM>main(k));
        w=find(info>main(k));
        y=find(fore>main(k));
    end
    
    % Aftershocks selection
    JD_ld=jd(aft(u));
    LATN_ld=lat(aft(u));
    LONE_ld=lon(aft(u));
    MD_ld=ml(aft(u));
    DEPTH_ld=depth(aft(u));
    
    % Indexes of aftershocks having magnitude>mmin
    a=find(MD_ld>=mmin);
    
    
    
    %if the type is 3, Naft, dt, type(0->B, 1->A), Mc and dMc are
    % listed in correspondence of day, month, year, hour, minute fields the
    % following fields are set to NaN.
    
    % If the error on Magnitude of Completeness result to be 0, it is then
    % set to 0.1
    if(minute(info(w))==0)
        minute(info(w))=0.1;
    end
    
    % If the Magnitude of Completeness Mc has been not calculated
    % due to the small number of available events, the default Mc value is
    % set
    if(isnan(hour(info(w))))
        
        
        fprintf('Number of sequence events smaller than 80!\n');
        fprintf('Mc is not calculated and then default value is used\n');
        
        
        
        if(year(main(k))<yearchMc)
            hour(info(w))=Mc1;
            fprintf('Year %d is before %d, then default Mc is: %f\n\n',year(main(k)), yearchMc, Mc1);
        else
            hour(info(w))=Mc2;
            fprintf('Year %d is after or equal to %d, then default Mc is: %f\n\n',year(main(k)), yearchMc,Mc2);
        end
        minute(info(w))=0.1;
    end
    
    
    % WARNING: month(info(w)) refers to the time interval between the
    % mainshock and the strongest aftershock.
    % In order to interrupt the evaluation, the occurrence time of the
    % first aftershock having M>=Mm-1 is necessary;
    
    %Tmax = the time of the first aftershock with M>=Mm-1
    ma=find(MD_ld>=mainmag-1);
    if(~isempty(ma))
        Tmax=(JD_ld(ma(1))-maintime)/(24*3600);
    else
        Tmax=month(info(w));
    end
    
    
    
    
    % lab = 0 ---> all ;
    % lab = 1 ---> B class (year(info(w))==0) or (A with dt>time) and Mm-Mc>=3 NESTORE 3
    % lab = 2 ---> B class (year(info(w))==0) or (A with dt>time) and Mm-Mc>=2 NESTORE 2
    
    if label==0 ...
            | (label==1 & (length(a)>=1 & (year(info(w))==0 | (year(info(w))==1 & Tmax>interv/86400))) & floor( ml(main(k))-hour(info(w)))>2.9) ...
            | (label==2 & (length(a)>=1 & (year(info(w))==0 | (year(info(w))==1 & Tmax>interv/86400))) & floor( ml(main(k))-hour(info(w)))>1.9)
        
        
        % Only Mainshocks inside the polygon and with depth <Zth are selected
        [~,ind_s ]=points_inside_ind_depth([ lon(main(k)),lat(main(k)), depth(main(k))],PL(:,1),PL(:,2),Zth);
        
        if(~isempty(ind_s))
            % It deletes events having magnitude difference between the mainshock
            % and the largest aftershock in the range 0.8-1.2
            dm=ml(main(k))-ml(aftM(v));
            % if dm value is within the range, vector ind_s is cleaned
            if(round(dm*10)>=8 & round(dm*10)<=12 & strcmp(module_type,'nrt')==0)
                ind_s=[];
            end
            
            % If the Year of the Mainshock is within the range, events are selected.
            % Otherwise they are not considered.
            if(year(main(k))<start_time | year(main(k))>end_time)
                ind_s=[];
            end
        end
        
        if(~isempty(ind_s))
            nclus=nclus+1;
            fprintf('##############################\n');
            fprintf('Total number of aftershocks =%d\n',length(JD_ld))
            
            fprintf('%d/%d/%d\n', day(main(k)),month(main(k)), year(main(k)));
            
            fprintf(fid,'%d/%d/%d %d:%d:%d ', day(main(k)),month(main(k)), year(main(k)), hour(main(k)), minute(main(k)), round(second(main(k))));
            
            fprintf('Mainshock magnitude= %.1f\n', ml(main(k)));
            
            fprintf(fid, '%.1f %.2f %.2f %d ', ml(main(k)), lat(main(k)), lon(main(k)), round(depth(main(k))));
            
            % Aftershocks with M>=mmin are selected
            JD_ld=JD_ld(a);
            LATN_ld=LATN_ld(a);
            LONE_ld=LONE_ld(a);
            MD_ld=MD_ld(a);
            DEPTH_ld=DEPTH_ld(a);
            
            fprintf(fid,'%d ',length(a));
            
            if(~isempty(a))
                
                % CHARACTERISTICS OF THE STRONGEST AFTERSHOCK
                fprintf('Strongest aftershock: M=%.1f \n',ml(aftM(v)));
                fprintf(fid, '%.1f ',ml(aftM(v)));
                
                fprintf('on %d/%d/%d\n', day(aftM(v)),month(aftM(v)), year(aftM(v)));
                fprintf(fid, '%d/%d/%d %d:%d:%d ', day(aftM(v)),month(aftM(v)), year(aftM(v)), hour(aftM(v)), minute(aftM(v)),round(second(aftM(v))));
                
                fprintf('Lat aft =%.2f Lon aft=%.2f Depth aft= %d\n', lat(aftM(v)),lon(aftM(v)), round(depth(aftM(v))) );
                fprintf(fid, '%.2f %.2f %d ', lat(aftM(v)),lon(aftM(v)), round(depth(aftM(v))) );
                
                
                % CHARACTERISTICS OF THE SEISMIC SEQUENCE
                
                % Parameters dt,type, Mc
                fprintf('Time interval between the strongest earthquake and mainshock is: %.2f gg\n',month(info(w)));
                fprintf(fid,'%.2f ',month(info(w)));
                if(year(info(w))==1)
                    fprintf('Cluster type is A\n\n');
                    fprintf(fid,'A ');
                    nclusA=nclusA+1;
                else
                    fprintf('Cluster type is B\n\n');
                    fprintf(fid,'B ');
                    nclusB=nclusB+1;
                end
                
                % Mc and dMc are obtained from cluster identification code
                % This process analyzes all the available events
                fprintf('Mc=%.1f +/- %.1f\n',hour(info(w)), minute(info(w)));
                fprintf(fid, '%.1f %.1f ', hour(info(w)), minute(info(w)));
            else
                %  fprintf('There are not aftershocks\n');
                fprintf(fid,'NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ');
            end
            
            
            % Sets the analysis start 1 minute after the mainshock in order
            % to avoid problems of incompleteness of the catalog according
            % to Helstetter (2006) and Gentili and Di Giovambattista (2021)
            s1=maintime+60;
            
            %Sets the current end time
            s2=maintime+interv;
            
            %Calculates the features only if Ti>=start_time of the good interval; otherwise writes NaN.
            %For Ti>time_end of the good interval the feature is unchanged
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  Number of earthquakes with magnitude >=mainmag-3 (N)                      %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            if(s2>=maintime+3600*24*vb(1))
                s2b=min(s2,maintime+3600*24*vb(2));
                %s2b=s2;
                timeN=find(JD_ld<=s2b & JD_ld>=s1);
                
                N=length(timeN);
                
                fprintf('N=%d\n',N);
                fprintf(fid, '%d ',N);
            else
                fprintf('N=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Equivalent source area of the aftershocks normalized to the mainshock one (S)%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            if(s2>=maintime+3600*24*vb(3))
                s2b=min(s2,maintime+3600*24*vb(4));
                %s2b=s2;
                timeN=find(JD_ld<=s2b & JD_ld>=s1);
                magS=MD_ld(timeN);
                
                a=find(magS>=mainmag-2);
                magS=magS(a);
                
                S=sum(10.^magS)/10^mainmag;
                fprintf('S=%.3f\n',S);
                fprintf(fid, '%.3f ',S);
            else
                fprintf('S=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  Linear concentration of events (Z)                                      %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if(s2>=maintime+3600*24*vb(5))
                s2b=min(s2,maintime+3600*24*vb(6));
                %s2b=s2;
                timeN=find(JD_ld<=s2b & JD_ld>=s1);
                magS=MD_ld(timeN);
                LATN_ldZ=LATN_ld(timeN);
                LONE_ldZ=LONE_ld(timeN);
                
                a=find(magS>=mainmag-2);
                magS=magS(a);
                LATN_ldZ=LATN_ldZ(a);
                LONE_ldZ=LONE_ldZ(a);
                
                Length = 10.^(-3.22+0.69*magS); %(all rupture types)
                Lm=mean(Length);
                
                R=[];
                for(i=1:length(a))
                    for(j=i+1:length(a))
                        R=[R;deg2km(distance(LATN_ldZ(i),LONE_ldZ(i),LATN_ldZ(j),LONE_ldZ(j)))];
                    end
                end
                
                
                % if no data are available, Z is set to 0
                % if the average distance Rm=0, it is set to 0.1. Indeed,
                % the location accuracy hardly is below 1 km
                
                if(isempty(R))
                    Z=0;
                else
                    Rm=mean(R);
                    if(Rm==0)
                        Rm=0.1;
                    end
                    
                    Z=Lm/Rm;
                end
                
                
                
                fprintf('Z=%.3f\n',Z);
                fprintf(fid, '%.3f ',Z);
                
                
            else
                fprintf('Z=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Cumulative deviation from long period trend of S (SLCum)     %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            % SLCum is calculated only while sc3<=s2b or in
            % other words, if Ti>the end of the last considered 6-hours interval
            % (Ti=6 hours excluded).
            if(s2>=maintime+3600*24*vb(7))
                s2b=min(s2,maintime+3600*24*vb(8));
                
                
                i=1;
                SL=[];
                
                % Current Interval of comparison: 6 hours
                sc1=s1;
                sc3=sc1+3600*6;
                
                
                % SLCum is calculated only while sc3<=s2b or in
                % other words, if Ti>the end of the last considered 6-hours interval
                
                while(sc3<=s2b)
                    timeNt=find(JD_ld<=sc3 & JD_ld>s1 & MD_ld>=mainmag-2);
                    timeNtms=find(JD_ld<=sc1 & JD_ld>s1 & MD_ld>=mainmag-2);
                    
                    SNt=sum(10.^MD_ld(timeNt));
                    SNtms=sum(10.^MD_ld(timeNtms));
                    
                    tmt0=sc3-s1;
                    tmt0ms=tmt0-3600*6;
                    if(tmt0ms>0)
                        SL(i)=SNt-SNtms*tmt0/tmt0ms;
                    else
                        SL(i)=SNt;
                    end
                    
                    i=i+1;
                    sc1=s1+(i)*3600*6;
                    sc3=sc1+3600*6;
                end
                
                
                
                if(isempty(SL))
                    fprintf('SLcum=NaN\n');
                    fprintf(fid, 'NaN ');
                else
                    SLcum=sum(abs(SL))/10^mainmag;
                    fprintf('SLcum=%f\n',SLcum);
                    fprintf(fid, '%f ',SLcum);
                end
            else
                fprintf('SLcum=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  Cumulative deviation from long period trend of Q (QLCum)    %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if(s2>=maintime+3600*24*vb(9))
                s2b=min(s2,maintime+3600*24*vb(10));
                % SLCum is calculated only while sc3<=s2b or in
                % other words, if Ti>the end of the last considered 6-hours interval
                % (Ti=6 hours excluded).
                
                
                i=1;
                
                QL=[];
                sc1=s1;
                sc3=sc1+3600*6;
                
                % SLCum is calculated only while sc3<=s2b or in
                % other words, if Ti>the end of the last considered 6-hours interval
                while(sc3<=s2b)
                    
                    
                    timeNt=find(JD_ld<=sc3 & JD_ld>s1 & MD_ld>=mainmag-2);
                    timeNtms=find(JD_ld<=sc1 & JD_ld>s1 & MD_ld>=mainmag-2);
                    
                    
                    QNt=sum(10.^(3/2*MD_ld(timeNt)));
                    QNtms=sum(10.^(3/2*MD_ld(timeNtms)));
                    
                    tmt0=sc3-s1;
                    tmt0ms=tmt0-3600*6;
                    
                    if(tmt0ms>0)
                        QL(i)=QNt-QNtms*tmt0/tmt0ms;
                    else
                        QL(i)=QNt;
                    end
                    
                    
                    i=i+1;
                    sc1=s1+(i)*3600*6;
                    sc3=sc1+3600*6;
                end
                
                if(isempty(QL))
                    fprintf('QLcum=NaN\n');
                    fprintf(fid, 'NaN ');
                else
                    QLcum=sum(abs(QL))/10^mainmag;
                    fprintf('QLcum=%f\n',QLcum);
                    fprintf(fid, '%f ',QLcum);
                end
            else
                fprintf('QLcum=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Cumulative deviation from long period                       %
            % trend of S by using a not maintime-bound sliding            %
            % temporal window (SLCum2)                                    %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if(s2>=maintime+3600*24*vb(11))
                s2b=min(s2,maintime+3600*24*vb(12));
                
                i=1;
                SL=[];
                
                sc1=s1;
                
                % First interval starts from maintime
                sc2=s1;
                % Interval of comparison: 6 hours
                sc3=sc1+3600*6;
                
                % SLCum2 is calculated only if sc3>s2b or in other words, if
                % the time interval is long enough to have a
                % starting time smaller than the ending time (No 6 hours).
                while(sc3<=s2b)
                    
                    timeNt=find(JD_ld<=sc3 & JD_ld>sc2 & MD_ld>=mainmag-2);
                    timeNtms=find(JD_ld<=sc1 & JD_ld>sc2 & MD_ld>=mainmag-2);
                    
                    
                    SNt=sum(10.^MD_ld(timeNt));
                    SNtms=sum(10.^MD_ld(timeNtms));
                    
                    
                    %long interval dt
                    tmt0=sc3-sc2;
                    %short interva dtau
                    tmt0ms=sc1-sc2;
                    
                    if(tmt0ms>0)
                        SL(i)=SNt-SNtms*tmt0/tmt0ms;
                    else
                        SL(i)=SNt;
                    end
                    
                    
                    
                    i=i+1;
                    sc1=s1+3600+(i-1)*3600*6;
                    sc2=s1+(i-1)*3600*6;
                    sc3=sc2+3600*6;
                end
                
                % Before the first 12 hours SLCum2 is fixed to NaN
                % because it is coincident with SLCum and then features would be
                % not independent
                if(isempty(SL) | interv<=12*3600)
                    fprintf('SLcum2=NaN\n');
                    fprintf(fid, 'NaN ');
                else
                    SLcum2=sum(abs(SL))/10^mainmag;
                    fprintf('SLcum2=%f\n',SLcum2);
                    fprintf(fid, '%f ',SLcum2);
                end
            else
                fprintf('SLcum2=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Cumulative deviation from long period                       %
            % trend of Q by using a not maintime-bound sliding            %
            % temporal window (QLCum2)                                    %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            if(s2>=maintime+3600*24*vb(13))
                s2b=min(s2,maintime+3600*24*vb(14));
                
                i=1;
                
                QL=[];
                sc1=s1;
                sc2=s1;
                sc3=sc1+3600*6;
                % SLCum2 is calculated only if sc3>s2b or in other words, if
                % the time interval is long enough to have a
                % starting time smaller than the ending time (No 6 hours).
                while(sc3<=s2b)
                    
                    timeNt=find(JD_ld<=sc3 & JD_ld>sc2 & MD_ld>=mainmag-2);
                    timeNtms=find(JD_ld<=sc1 & JD_ld>sc2 & MD_ld>=mainmag-2);
                    
                    
                    QNt=sum(10.^(3/2*MD_ld(timeNt)));
                    QNtms=sum(10.^(3/2*MD_ld(timeNtms)));
                    
                    %long interval dt
                    tmt0=sc3-sc2;
                    %short interva dtau
                    tmt0ms=sc1-sc2;
                    
                    if(tmt0ms>0)
                        QL(i)=QNt-QNtms*tmt0/tmt0ms;
                    else
                        QL(i)=QNt;
                    end
                    
                    
                    i=i+1;
                    sc1=maintime+3600+(i-1)*3600*6;
                    sc2=s1+(i-1)*3600*6;
                    sc3=sc2+3600*6;
                end
                
                
                % Before the first 12 hours QLCum2 is fixed to NaN
                % because it is coincident with SLCum and the features would be
                % not independent
                
                if(isempty(QL)| interv<=12*3600)
                    fprintf('QLcum2=NaN\n');
                    fprintf(fid, 'NaN ');
                else
                    QLcum2=sum(abs(QL))/10^mainmag;
                    fprintf('QLcum2=%f\n',QLcum2);
                    fprintf(fid, '%f ',QLcum2);
                end
                
            else
                fprintf('QLcum2=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Normalized radiated energy (Q)                              %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            if(s2>=maintime+3600*24*vb(15))
                s2b=min(s2,maintime+3600*24*vb(16));
                timeN=find(JD_ld<=s2b & JD_ld>=s1);
                magS=MD_ld(timeN);
                
                a=find(magS>=mainmag-2);
                magS=magS(a);
                if(length(magS)>0)
                    Q=sum(10.^(3/2*magS))/10^(mainmag*3/2);
                else
                    Q=0;
                end
                
                fprintf('Q=%.3f\n',Q);
                fprintf(fid, '%.3f ',Q);
            else
                fprintf('Q=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Magnitude variation between events (Vm).                    %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if(s2>=maintime+3600*24*vb(17))
                s2b=min(s2,maintime+3600*24*vb(18));
                timeN=find(JD_ld<=s2b & JD_ld>=s1);
                
                
                
                
                magS=MD_ld(timeN);
                a=find(magS>=mainmag-2);
                magS=magS(a);
                buf=[];
                for(i=1:length(magS)-1)
                    buf(i)=abs(magS(i+1)-magS(i));
                end
                
                Vm=sum(buf);
                
                fprintf('Vm=%.1f\n',Vm);
                fprintf(fid,'%.1f ',Vm);
                
            else
                fprintf('Vm=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Daily magnitude variation (Vmed)                            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if(s2>=maintime+3600*24*vb(19))
                s2b=min(s2,maintime+3600*24*vb(20));
                timeN=find(JD_ld<=s2b & JD_ld>=s1);
                
                
                s2v=s2b;
                i=1;
                buf=[];
                s3=s1+3600*24;
                s1c=s1;
                while(s3<=s2v)
                    
                    timeN=find(JD_ld<=s3 & JD_ld>=s1c);
                    magS=MD_ld(timeN);
                    if(~isempty(magS))
                        buf(i)=sum(magS)/length(magS);
                    else
                        buf(i)=0;
                    end
                    
                    s1c=maintime+3600+i*3600*24;
                    s3=s1c+3600*24;
                    i=i+1;
                end
                buf2=[];
                for(i=1:length(buf)-1)
                    buf2(i)=abs(buf(i+1)-buf(i));
                end
                
                if(~isempty(buf2))
                    Vmed=sum(buf2);
                    fprintf('Vmed=%f\n',Vmed);
                    fprintf(fid,'%f ',Vmed);
                else
                    Vmed=NaN;
                    fprintf('Vmed=NaN\n');
                    fprintf(fid,'NaN ');
                end
                
                
            else
                fprintf('Vmed=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Daily aftershocks number variation (Vn)                    %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if(s2>=maintime+3600*24*vb(21))
                s2b=min(s2,maintime+3600*24*vb(22));
                
                timeN=find(JD_ld<=s2b & JD_ld>=s1);
                
                s1c=s1;
                s2v=s2b;
                i=1;
                buf=[];
                s3=s1+3600*24;
                n=[];
                while(s3<=s2v)
                    
                    timeN=find(JD_ld<=s3 & JD_ld>=s1c);
                    
                    n(i)=length(timeN);
                    
                    
                    s1c=maintime+3600+i*3600*24;
                    s3=s1c+3600*24;
                    i=i+1;
                end
                buf2=[];
                for(i=1:length(n)-1)
                    buf2(i)=abs(n(i+1)-n(i));
                end
                
                if(~isempty(buf2))
                    Vn=sum(buf2);
                    fprintf('Vn=%d\n',Vn);
                    fprintf(fid,'%d ',Vn);
                else
                    fprintf('Vn=NaN\n');
                    fprintf(fid, 'NaN ');
                end
                
                
            else
                fprintf('Vn=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Number of earthquakes having magnitude >= mainmag-2         %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            s1N2=s1;
            if(s2>=maintime+3600*24*vb(23))
                s2b=min(s2,maintime+3600*24*vb(24));
                
                
                timeN=find(JD_ld<=s2b & JD_ld>=s1N2 & round(MD_ld*10)>=round((mainmag-2)*10));
                
                N2=length(timeN);
                
                fprintf('N2=%d\n',N2);
                fprintf(fid, '%d ',N2);
                
            else
                fprintf('N2=NaN\n');
                fprintf(fid, 'NaN ');
            end
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %   Foreshock activity before the mainshock (Nfor)            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            JD=jd(fore(y));
            Nfor=length(JD);
            
            fprintf('Nfor=%d\n',Nfor);
            fprintf(fid,'%d\n',Nfor);
        end
    end
end
fclose(fid);




