function [clus_file,res_fil,area_file,Zth,start_time,end_time,yearchMc,Mc1,Mc2,label,td]=input_train_read(fileinname)
%reads the input file

% INPUT:
% fileinname = input file listing cluster name, parameters etc

% OUTPUT:
% clus_file  = name of the clusters' file
% res_fil    = first part of the name of the feature files
% area_file  = File containing the polygon in which the analysis is performed
% Zth        = maximum depth
% start_time = starting year to consider the mainshock 
% end_time   = ending year to consider the mainshock 
% yearchMc   = year of Mc change 
% Mc1        = default completeness magnitude for year < yearchMc
% Mc2        = default completeness magnitude for year >= yearchMc
% label      = selection on the clusters characteristics (current version
%              label=2
%    label      = 0, all clusters
%    label      = 1, clusters of Mm-Mc>=3. They can be class type B or 
%                 class type A with dt>time 
%    label      = 2, clusters of Mm-Mc>=2. They can be class type B or 
%                 class type A with dt>time (used for the last version of 
%                 NESTORE)
% td         = time interval (number [days])

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
% S. Gentili, sgentili@inogs.it
% P. Brondi,  pbrondi@inogs.it
% License: GNUGPLv3

% last change June 13, 2022

fileID = fopen(fileinname,'r');



%Checking the existence of the Input file
if fileID<0
    errordlg('Error! Input file does not exist!');
    return;
end

TRAIN=[];

% Charging Info from Input file
i=1;
tline = fgetl(fileID);
while ischar(tline)
    
    disp(tline)
    if(strcmp(tline(1),'%')==0)
        TRAIN{i}=tline;       
        i=i+1;    
    end
    tline = fgetl(fileID);
end



fclose(fileID);


% Setting Cluster file name
clus_file=TRAIN{1};
% Setting res file name
res_fil=TRAIN{2};
% Setting Area file name
area_file=TRAIN{3};
% Setting Maximum depth
Zth=str2double(TRAIN{4});
% Setting start time of the analysis
start_time=str2double(TRAIN{5});
% Setting end time of the analysis
end_time=str2double(TRAIN{6});
% Setting year of the Completeness Magnitude Change
yearchMc=str2double(TRAIN{7});
% Setting Completeness Magnitude before yearchMc
Mc1=str2double(TRAIN{8});
% Setting Completeness Magnitude for yearchMc and following years
Mc2=str2double(TRAIN{9});
% Setting Label for NESTORE
label=str2double(TRAIN{10});
% Setting periods vector
td=str2num(TRAIN{11});


