% Run of the cluster identification module

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
% Last change: June 7, 2022


addpath('../src/');
addpath('../src/external/');
addpath('../src/external/Bookmaker/');
addpath('../src/external/filetime/');


% Input file name by the user
fileinname='fileinput_clus_identification.txt';


%Do not modify: specifies which function calls clus_ident2
module_type='clus_id';

% Reads the input file and generates output file name
[filein,fileout,form_space,form_time,form_time2,ThM,Thwt,coeff_space_fore,coeff_time_fore]=input_clus_id(fileinname);

% filein     = Input file in Zmap format
% fileout    = output file containing information on  mainshock, 
%              aftershocks, foreshocks and clusters
% form_space = equation of the space window for aftershock - R(M)
% form_time  = equation of the time window for aftershock - T(M)
% ThM        = minimum magnitude for considered mainshocks
% Thwt       = threshold on mainshock magnitude for possible different 
%              time window 
% form_time2 = equation for time window for Mm>=Thwt
% coeff_space_fore = cohefficient to determine space window for foreshocks 
%              coeff_space_fore*R(M)
% coeff_time_fore  = duration of the time window of foreshocks [Years]


% identifies the clusters in the catalogue in filein and writes them in the 
% file fileout
clus_ident(filein, fileout, form_space,form_time, ThM, Thwt,form_time2,coeff_space_fore,coeff_time_fore,module_type);


