function [res_file,res_file2,T,PL,FEA,k,COL,MK,MS]=input_train_build(res_fil,area_file,td)
% Generates names and vectors to be used; adds default values

% INPUT:
% res_file   = first part of the name of the feature files
% area_fil   = File containing the polygon in which the analysis is performed
% td         = time interval (number [days])


% OUTPUT:
% res_file   = first part of the name of the feature file calculated in all 
%              the time periods
% res_file2  = first part of the name of the new feature file calculated in 
%              the good interval
% T          = time interval (letters)
% PL         = polygon in which the analysis is performed
% FEA       = considered features names
% k         = position of the features in the estimator's files
% COL       = color of the lines
% MK        = symbols of the markers
% MS        = markers' size


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
% Last change: June 17, 2022


% features names for legend 
FEA={'S', 'Z', 'SLcum', 'QLcum','SLcum2','QLcum2', 'Q', 'Vm','N2'};

%position of the features in the estimator's files
k=[5,7,9,11,13,15,17,19,25];

%color of the lines
COL=[255/255,177/255,100/255
255/255, 16/255,100/255
255/255,100/255,177/255
177/255,255/255,100/255
255/255,100/255, 77/255
177/255, 10/255, 10/255
206/255, 60/255,162/255
122/255, 16/255,228/255
  0/255,  0/255,255/255];

%symbols of the markers
MK=['o';'v';'^';'<';'o';'o';'>';'^';'*'];

%markers size
MS=[12,8,8,8,5,12,5,10,5];


% Generating Time Intervals string
% Time intervals (characters [days])
T=cell(1,length(td));
    
for(i=1:length(td))
    if(td(i)<1)
        T{1,i}=sprintf('%dh',round(td(i)*24));
    else
        T{1,i}=sprintf('%dd',td(i));
    end
end


% First part of the name of the feature file calculated in all the time 
% periods containing '_no_stop' string

res_file=sprintf('%s_no_stop%s',res_fil);

% Feature file name in the second run containing '_stop' string. It 
% corresponds to features calculated for time periods of good performances
% "good interval"
res_file2=sprintf('%s_stop%s',res_fil);



% Polygon Area vector
PL_area=fullfile('../data/Clusters/',sprintf(area_file));
PL=load(PL_area);




