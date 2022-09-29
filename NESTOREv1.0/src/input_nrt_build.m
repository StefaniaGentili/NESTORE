function [res_train_file, res_train_file2,res_nrt_file,clus_file,form_space, form_time, form_time2,T,PL]=input_nrt_build(res_nrt_fil,res_train_fil,filein,area_file,td,form_s,form_t,form_t2)
% Generates names and vectors to be used; adds default values

% INPUT:
% res_train_fil = first part of the name of the training feature file
% res_nrt_fil   = first part of the name of the nrt feature file 
% form_s        = Equation for spatial selection of aftershocks (M)
% form_t        = Equation for temporal selection of aftershocks (M)
% form_t2       = Equation for temporal selection of aftershocks for 
%                   Mm>=Thwt (M)
% area_file     = file containing the polygon in which the analysis is performed
% td            = time interval (number [days])
%
% OUTPUT:
% res_train_file   = first part of the name of the feature file calculated 
%                    in all the time periods during the training
% res_trein_file2  = first part of the name of the feature file calculated 
%                    in the good interval during the training
% res_nrt_file     = first part of the name of the feature file calculated 
%                    in the good interval during the nrt
% clus_file        = cluster file from the input data
% form_space       = Equation for spatial selection of aftershocks (fMagnitude)
% form_time        = Equation for temporal selection of aftershocks (fMagnitude)
% form_time2       = Equation for temporal selection of aftershocks for 
%                   Mm>=Thwt (fMagnitude)
% T                = time interval (letters)
% PL               = polygon in which the analysis is performed
%
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
% Last change: August 12, 2022

% Change of Variables for space and time cluster id. relationships
string='fMagnitude';
MM=strfind(form_s,'M');
form_space=strcat(form_s(1:MM-1),string,form_s(1,MM+1:end));
clear MM
MM=strfind(form_t,'M');
form_time=strcat(form_t(1:MM-1),string,form_t(1,MM+1:end));
clear MM
MM=strfind(form_t2,'M');
form_time2=strcat(form_t2(1:MM-1),string,form_t2(1,MM+1:end));
clear MM


% Generating Time Intervals (characters [days])
T=cell(1,length(td));
    
for(i=1:length(td))
    if(td(i)<1)
        T{1,i}=sprintf('%dh',round(td(i)*24));
    else
        T{1,i}=sprintf('%dd',td(i));
    end
end


% Generating Stop file names
res_train_file=sprintf('%s_no_stop',res_train_fil);

res_train_file2=sprintf('%s_stop',res_train_fil);

res_nrt_file=sprintf('%s_stop',res_nrt_fil);




% Generating Polygon Area
PL_area=fullfile('../data/Clusters/',sprintf(area_file));
PL=load(PL_area);


% Generating Cluster File 
clus_file=sprintf('cluster_%s',filein);

