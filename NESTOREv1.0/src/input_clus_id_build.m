function [form_space, form_time, form_time2]=input_clus_id_build(form_s,form_t,form_t2)
% Generates names and vectors to be used; adds default values

% INPUT:
% form_s        = Equation for spatial selection of aftershocks (M)
% form_t        = Equation for temporal selection of aftershocks (M)
% form_t2       = Equation for temporal selection of aftershocks for 
%                   Mm>=Thwt (M)
%
% OUTPUT:
% form_space       = Equation for spatial selection of aftershocks (fMagnitude)
% form_time        = Equation for temporal selection of aftershocks (fMagnitude)
% form_time2       = Equation for temporal selection of aftershocks for 
%                   Mm>=Thwt (fMagnitude)


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





