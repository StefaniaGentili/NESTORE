function [filein,fileout,form_space,form_time,form_time2,ThM,Thwt,coeff_space_fore,coeff_time_fore]=input_clus_id(fileinname)
% Reads variables from the input file and generates output file name 

% INPUT:
% fileinname = input file listing catalogue name, parameters etc

% OUTPUT:
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




[filein,fileout,ThM,Thwt,form_s,form_t,form_t2,coeff_space_fore,coeff_time_fore]=input_clus_id_read(fileinname);


[form_space, form_time, form_time2]=input_clus_id_build(form_s,form_t,form_t2);


