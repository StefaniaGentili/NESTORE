function [res_train_file, res_train_file2,res_file3,T,PL,FEA2,COL,MK,MS]=input_test_build(res_train_fil,res_fil3,area_file,td)
% Generates names and vectors to be used; adds default values

% INPUT:
% res_train_fil = first part of the name of the training feature file
% res_fil3   = first part of the name of the test feature file 
% area_file  = File containing the polygon in which the analysis is performed
% td         = time interval (number [days])


% OUTPUT:
% res_train_file   = first part of the name of the feature file calculated 
%                    in all the time periods during the training
% res_trein_file2  = first part of the name of the feature file calculated 
%                    in the good interval during the training
% res_file3        = first part of the name of the feature file calculated 
%                    in the good interval during the testing
% T          = time interval (letters)
% PL         = polygon in which the analysis is performed
% FEA2       = considered features names
% COL        = color of the lines
% MK         = symbols of the markers
% MS         = markers' size


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

FEA2 = {'random','S','Z','SLcum','QLcum','SLcum2','QLcum2','Q','Vm','N2','Simp','Bayes'};

%color of the lines
COL=[255/255,177/255,100/255
255/255, 16/255,100/255
255/255,100/255,177/255
177/255,255/255,100/255
255/255,100/255, 77/255
177/255, 10/255, 10/255
206/255, 60/255,162/255
122/255, 16/255,228/255
  0/255,  0/255,255/255
0/255,255/255,0/255
255/255,0/255,255/255];

%symbols of the markers
MK=['o';'v';'^';'<';'o';'o';'>';'^';'*';'^';'p'];

%markers' size
MS=[12,8,8,8,5,12,5,10,5,10,24];




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
% periods during training containing '_no_stop' string
res_train_file=sprintf('%s_no_stop',res_train_fil);



% First part of the feature file name in the second run containing '_stop' 
% string during the training. It corresponds to features calculated for 
% time periods of good performances "good interval"
res_train_file2=sprintf('%s_stop',res_train_fil);

% First part of the feature file name containing '_stop' string during 
% testing. It corresponds to features calculated for time periods of good 
% performances "good interval"
res_file3=sprintf('%s_stop',res_fil3);


% Polygon Area vector
PL_area=fullfile('../data/Clusters/',sprintf(area_file));
PL=load(PL_area);




