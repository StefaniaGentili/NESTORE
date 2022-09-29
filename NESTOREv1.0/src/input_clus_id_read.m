function [filein,fileout,ThM,Thwt,form_s,form_t,form_t2,coeff_space_fore,coeff_time_fore]=input_clus_id_read(fileinname)
% INPUT:
% fileinname = input file listing cluster name, parameters etc

% OUTPUT:

% filein     = Input file in Zmap format
% fileout    = output file containing information on  mainshock, 
%              aftershocks, foreshocks and clusters
% ThM              = Lower limit on Mainshock Magnitude (Mm) for clusters
% Thwt             = Threshold on Mainshock Magnitude (Mm) for time duration 
%                   equation change
% form_s           = Equation for spatial selection of aftershocks
% form_t           = Equation for temporal selection of aftershocks
% form_t2          = Equation for temporal selection of aftershocks for 
%                   Mm>=Thwt
% coeff_space_fore = Coefficient for spatial selection of foreshocks
% coeff_time_fore  = Coefficient for temporal selection of foreshocks
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

CLUS_ID=[];

% Charging Info from Input file
i=1;
tline = fgetl(fileID);
while ischar(tline)
    
    disp(tline)
    if(strcmp(tline(1),'%')==0);
        CLUS_ID{i}=tline;       
        i=i+1;    
    end
    tline = fgetl(fileID);
end



fclose(fileID);


% Setting Catalog name 
filein=CLUS_ID{1};
% Setting Clusters file name 
fileout=CLUS_ID{2};
% Setting Lower limit on Mainshock Magnitude (Mm) for clusters
ThM=str2double(CLUS_ID{3});
% Setting Threshold on Mainshock Magnitude (Mm) for time duration form change 
Thwt=str2double(CLUS_ID{4});
% Setting Form. for spatial selection of aftershocks
form_s=CLUS_ID{5};
% Setting Form. for temporal selection of aftershocks for Mm<Thwt
form_t=CLUS_ID{6};
% Setting Form. for temporal selection of aftershocks for Mm>=Thwt
form_t2=CLUS_ID{7};
% Setting coefficient for spatial selection of foreshocks
coeff_space_fore=str2double(CLUS_ID{8});
% Setting coefficient for temporal selection of foreshocks
coeff_time_fore=str2double(CLUS_ID{9});
