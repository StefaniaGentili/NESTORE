function [filein,res_train_fil,res_nrt_fil,ThM,Thwt,form_s,form_t,form_t2,coeff_space_fore,coeff_time_fore,area_file,Zth,start_time,end_time,yearchMc,Mc1,Mc2,label,td,dt]=input_nrt_read(fileinname)

% INPUT:
% fileinname = input file listing cluster name, parameters etc

% OUTPUT:
% filein           = Catalogue name
% res_train_fil    = first part of the name of the training feature file
% res_nrt_fil      = Features res file name for the cluster to be analyzed
% ThM              = Lower limit on Mainshock Magnitude (Mm) for clusters
% Thwt             = Threshold on Mainshock Magnitude (Mm) for time duration 
%                   equation change
% form_s           = Equation for spatial selection of aftershocks
% form_t           = Equation for temporal selection of aftershocks
% form_t2          = Equation for temporal selection of aftershocks for 
%                   Mm>=Thwt
% coeff_space_fore = Coefficient for spatial selection of foreshocks
% coeff_time_fore  = Coefficient for temporal selection of foreshocks
% area_file        = Area file name
% Zth              = Maximum depth
% start_time       = Start time of the analysis
% end_time         = End time of the analysis
% yearchMc         = Completeness Magnitude Change
% Mc1              = Completeness Magnitude before yearchMc
% Mc2              = Completeness Magnitude for yearchMc and following years
% label            = selection on the clusters characteristics (current version
%                    label=2
%    label         = 0, all clusters
%    label         = 1, clusters of Mm-Mc>=3. They can be class type B or 
%                    class type A with dt>time 
%    label         = 2, clusters of Mm-Mc>=2. They can be class type B or 
%                    class type A with dt>time (used for the last version of 
%                    NESTORE)
% td               = Periods vector [days]
% dt               = Upperbound limit for periods
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


fileID = fopen(fileinname,'r');



%Checking the existence of the Input file
if fileID<0
    errordlg('Error! Input file does not exist!');
    return;
end

NRT=[];

% Charging Info from Input file
i=1;
tline = fgetl(fileID);
while ischar(tline)
    
    disp(tline)
    if(strcmp(tline(1),'%')==0)
        NRT{i}=tline;       
        i=i+1;    
    end
    tline = fgetl(fileID);
end



fclose(fileID);


% Setting Catalog name 
filein=NRT{1};
% Setting res training file name
res_train_fil=NRT{2};
% Setting features res file name for the cluster to be analyzed
res_nrt_fil=NRT{3};
% Setting Lower limit on Mainshock Magnitude (Mm) for clusters
ThM=str2double(NRT{4});
% Setting Threshold on Mainshock Magnitude (Mm) for time duration form change 
Thwt=str2double(NRT{5});
% Setting equation for spatial selection of aftershocks
form_s=NRT{6};
% Setting equation for temporal selection of aftershocks for Mm<Thwt
form_t=NRT{7};
% Setting equation for temporal selection of aftershocks for Mm>=Thwt
form_t2=NRT{8};
% Setting coefficient for spatial selection of foreshocks
coeff_space_fore=str2double(NRT{9});
% Setting coefficient for temporal selection of foreshocks
coeff_time_fore=str2double(NRT{10});
% Setting Area file name
area_file=NRT{11};
% Setting Maximum depth
Zth=str2double(NRT{12});
% Setting start time of thE analysis
start_time=str2double(NRT{13});
% Setting end time of the analysis
end_time=str2double(NRT{14});
% Setting year of the Completeness Magnitude Change
yearchMc=str2double(NRT{15});
% Setting Completeness Magnitude before yearchMc
Mc1=str2double(NRT{16});
% Setting Completeness Magnitude for yearchMc and following years
Mc2=str2double(NRT{17});
% Setting Label for NESTORE
label=str2double(NRT{18});
% Setting periods vector
td=str2num(NRT{19});
% Setting Upperbound limit for periods
dt=str2num(NRT{20});
