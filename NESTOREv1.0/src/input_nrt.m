function [filein,clus_file,res_nrt_file,res_train_file,res_train_file2,form_space,form_time,form_time2,ThM,Thwt,coeff_space_fore,coeff_time_fore,PL,Zth,start_time,end_time,yearchMc,Mc1,Mc2,T,td,label,dt]=input_nrt(fileinname)
% Reads the input files and generates input strings and vectors for Near
% Real Time module of NESTORE

% INPUT:
% fileinname = input file listing cluster name, parameters etc

% OUTPUT:
% filein           = Catalogue name
% clus_file        = Cluster file name
% res_nrt_file        = Features res file name for the cluster to be analyzed
% res_train_file   = first part of the name of the feature file calculated 
%                    in all the time periods during the training
% res_trein_file2  = first part of the name of the feature file calculated 
%                    in the good interval during the training
% form_space       = Equation for spatial selection of aftershocks
% form_time        = Equation for temporal selection of aftershocks
% form_time2       = Equation for temporal selection of aftershocks for 
%                   Mm>=Thwt
% ThM              = Lower limit on Mainshock Magnitude (Mm) for clusters
% Thwt             = Threshold on Mainshock Magnitude (Mm) for time duration 
%                   equation change
% coeff_space_fore = Coefficient for spatial selection of foreshocks
% coeff_time_fore  = Coefficient for temporal selection of foreshocks
% PL               = Polygon Area
% Zth              = Maximum depth
% start_time       = Start time of the analysis
% end_time         = End time of the analysis
% yearchMc         = Completeness Magnitude Change
% Mc1              = Completeness Magnitude before yearchMc
% Mc2              = Completeness Magnitude for yearchMc and following years
% T                = Periods vector (string)
% td               = Periods vector [days]
% label            = selection on the clusters characteristics 
%       label      = 0, all clusters
%       label      = 1, clusters of Mm-Mc>=3. They can be class type B or 
%                    class type A with dt>time 
%       label      = 2, clusters of Mm-Mc>=2. They can be class type B or 
%                    class type A with dt>time (used for the last version 
%                    of NESTORE)
% dt               = Upperbound limit for periods


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
% S. Gentili, sgentili@ogs.it
% P. Brondi,  pbrondi@ogs.it
% License: GNUGPLv3
% Last change: August 12, 2022

% Reads the input file
[filein,res_train_fil,res_nrt_fil,ThM,Thwt,form_s,form_t,form_t2,coeff_space_fore,coeff_time_fore,area_file,Zth,start_time,end_time,yearchMc,Mc1,Mc2,label,td,dt]=input_nrt_read(fileinname);


% Generates names and vectors to be used; adds default values
[res_train_file, res_train_file2,res_nrt_file,clus_file,form_space, form_time, form_time2,T,PL]=input_nrt_build(res_nrt_fil,res_train_fil,filein,area_file,td,form_s,form_t,form_t2);



