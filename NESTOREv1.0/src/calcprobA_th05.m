function calcprobA_th05(T,res_file2)
%estimates the probabilities to be an A cluster under and over threshold
%for each feature. If the probability to be A over the threshold is <=0.5,
%the threshold is set to NaN

% Input:
% T          = time intervals (letters)
% res_file2  = first part of the name of the feature file calculated in the 
%              good interval

% Writes: 
% file of thresholds and probabilities to be A
% file with the number or A and B in each training set (numAB_file)

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.


% S. Gentili, sgentili@inogs.it 
% P. Brondi pbrondi@inogs.it
% License: GNUGPLv3
% last change March 10, 2022


fprintf('\n\nThis is calcprobA_th05\n\n');

%opens the thresholds file
thresholds_file=fullfile('../data/Training_Output/',sprintf('Thresholds_M2_%s.txt',res_file2));
Th=load(thresholds_file);


% file of thresholds and probabilities to be A
th_prob_file=fullfile('../data/Training_Output/',sprintf('Th_prob_M2_%s.txt',res_file2));
fid=fopen(th_prob_file,'w');

% file with the number or A and B in each training set
numAB_file=fullfile('../data/Training_Output/',sprintf('NumAB_%s.txt',res_file2));
fid2=fopen(numAB_file,'w');

M=[];
for(i=1:length(T))
    %generates the name of the feature file to be read
    filein=fullfile('../data/Training_Output/',sprintf('%s_%s.dat',res_file2,T{i}));
    
    [Date,Time,ML,Lat,Lon,Depth,Naft,Maft,Dateaft,Timeaft,Lataft,Lonaft,Depthaft,Dt,ty,Mc,dMc,N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor,mf] = textread(filein,'%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d %f');
    %[Date,Time,ML,Lat,Lon,Depth,Naft,Maft,Dateaft,Timeaft,Lataft,Lonaft,Depthaft,Dt,ty,Mc,dMc,Mth,N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor,mf] = textread('res_sud_no_stop_all_fin_5d.dat','%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d %f');
    
    %evaluates the number of A and B for each time interval and writes in numAB_file 
    na=0; 
    nb=0; 
    for(k=1:length(ty))
        na=na+strcmp(ty(k),'A');
        nb=nb+strcmp(ty(k),'B');
        
    end
    fprintf(fid2,'%d %d ',na,nb);
   
    
    % Putting the features in vector fea
    fea=[S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm, N2];
    [~,v]=size(fea);
    
    
    for(j=1:v)
        th=Th(j,i);
        I=(i-1)*3+1;
        if(~isnan(th))
            % percentage of A-type below the threshold 
            NlessT=length(find(fea(:,j)<th));
            NlessA=length(find(fea(:,j)<th & strcmp(ty,'A')));
            percless=NlessA/NlessT;
            
            %  percentage of A-type above the threshold 
            NmoreT=length(find(fea(:,j)>=th));
            NmoreA=length(find(fea(:,j)>=th & strcmp(ty,'A')));
            percmore=NmoreA/NmoreT;
            
            % if the percentage of A-type above the threshold is less than 
            % 50% threshold and probability are fixed to NaN 
            if(percmore<=0.50)   
                percmore=NaN;
                percless=NaN;
                th=NaN;
            end
            
            % Matrix of thresholds and probabilities
            M(j,I)=th;
            M(j,I+1)=percless;
            M(j,I+2)=percmore;
        else
            % Matrix of thresholds and probabilities 
            M(j,I)=NaN;
            M(j,I+1)=NaN;
            M(j,I+2)=NaN;
        end
        
    end
end

[u,v]=size(M);

%writes thresholds and probabilities on their corresponding file
for(i=1:u)
    for(j=1:v)
        fprintf(fid,'%f ',M(i,j));
    end
    fprintf(fid,'\n');
end

fclose(fid);
fclose(fid2);
        