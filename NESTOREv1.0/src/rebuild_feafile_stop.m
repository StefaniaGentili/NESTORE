function rebuild_feafile_stop(T,td, res_file, res_file2)
% Rebuilds the feature file (res_no_stop) 
% writes the output file (res_stop) which uses the "good interval" 
% defined in showperf_th05_nostop 

% Input:
% T         = time intervals (letters)
% td        = time intervals (number [days])
% res_file  = first part of the name of the feature file res_no_stop 
% res_file2 = first part of the name of the feature file res_stop

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.


% Last change 24 September 2021
% Written by S. Gentili, sgentili@inogs.it 
% Debugging and comments by P. Brondi pbrondi@inogs.it
% License: GNUGPLv3
% Generates range_file name and loads it

range_file=fullfile('../data/Training_Output/',sprintf('range_M2_%s.dat', res_file));
range=load(range_file);

% w = number of analyzed features
[w,~]=size(range);

% vector of start and end of the good interval
v=[range(:,1),range(:,2)];


% cicle on the periods T(i)
for(i=1:length(T))
    % generates input and output file names
    filein=fullfile('../data/Training_Output/',sprintf('%s_%s.dat',res_file,T{i}));
    fileout=fullfile('../data/Training_Output/',sprintf('%s_%s.dat',res_file2,T{i}));
    
    fid=fopen(fileout,'w');
    
    % reads input file and loads features in feat vector
    [Date,Time,ML,Lat,Lon,Depth,Naft,Maft,Dateaft,Timeaft,Lataft,Lonaft,Depthaft,Dt,ty,Mc,dMc,N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor] = textread(filein,'%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d');
    feat=[S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,N2];
    
    % cicle on the clusters
    for(j=1:length(Date))
        date=Date{j};
        slash = strfind(date,'/');

        % converts mainshock time in seconds from 1970 
        day=str2double(date(1:slash(1)-1));
        month=str2double(date(slash(1)+1:slash(2)-1));
        year=str2double(date(slash(2)+1:end));
        
        time=Time{j};
        dp = strfind(time,':');

        hour=str2double(time(1:dp(1)-1));
        minute=str2double(time(dp(1)+1:dp(2)-1));
        second=str2double(time(dp(2)+1:end));
        
        mt(j)=date2unixsecs(year, month, day, hour, minute, second);
        
        % cicle on the features
        for(k=1: w)
            % features are fixed to NaN before the beginning of the good
            % interval
            if(td(i)<v(k,1) | isnan(v(k,1)))
                feat(j,k)=NaN;
            end
            
            %if it is not the first time period Ti
            if(i>1)
                % if Ti > the end of the good time interval
                if(td(i)>v(k,2))
                    % searches the index of last interval Ti in which 
                    % features has a good performance
                    u=find(td==v(k,2));
                    % all features for the selected interval
                    % are stored in OLD vector
                    OLD=FEAT{u};
                    
                    % searches the current cluster index
                    uu=find(OLD(:,1)==mt(j));
                    % copies in feat the correct feature value
                    % Please note: OLD has an additional column respect 
                    % to feat which corresponds to mainshock time
                    feat(j,k)=OLD(uu,k+1);
                end
            end
        end
        fprintf(fid, '%s %s %.1f %.2f %.2f %d %d %.1f %s %s %.2f %.2f %d %.2f %s %.1f %.1f NaN %.3f %.3f %.3f %.3f %f %.3f %.3f %.3f NaN NaN %d %d\n', Date{j} ,Time{j} ,ML(j) ,Lat(j) ,Lon(j) ,Depth(j) ,Naft(j) ,Maft(j) ,Dateaft{j} ,Timeaft{j} ,Lataft(j) ,Lonaft(j) ,Depthaft(j) ,Dt(j) ,ty{j} ,Mc(j) ,dMc(j) ,feat(j,1) ,feat(j,2) ,feat(j,3) ,feat(j,4) ,feat(j,5) ,feat(j,6) ,feat(j,7) ,feat(j,8),feat(j,9) ,Nfor(j) );

    end   
        
        % Correct features are stored in FEAT vector
        FEAT{i}=[mt',feat];
        mt=[];
        fclose(fid);
    
end

