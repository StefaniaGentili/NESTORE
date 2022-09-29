function [clus_file,res_file,PL,Zth,start_time,end_time,yearchMc,Mc1,Mc2,res_file2,T,td,label,FEA,k,COL,MK,MS]=input_train(fileinname)
% Reads the input files and generates input strings and vectors

% INPUT:
% fileinname = input file listing cluster name, parameters etc

% OUTPUT:
% clus_file  = name of the clusters' file
% res_file   = first part of the name of the feature file calculated in all 
%              the time periods
% PL         = polygon in which the analysis is performed
% Zth        = maximum depth
% start_time = starting year to consider the mainshock 
% end_time   = ending year to consider the mainshock 
% yearchMc   = year of Mc change 
% Mc1        = default completeness magnitude for year < yearchMc
% Mc2        = default completeness magnitude for year >= yearchMc
% res_file2  = first part of the name of the new feature file calculated in 
%              the good interval
% T          = time interval (letters)
% td         = time interval (number [days])
% label      = selection on the clusters characteristics (current version
%              label=2
%    label      = 0, all clusters
%    label      = 1, clusters of Mm-Mc>=3. They can be class type B or 
%                 class type A with dt>time 
%    label      = 2, clusters of Mm-Mc>=2. They can be class type B or 
%                 class type A with dt>time (used for the last version of 
%                 NESTORE)
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
% Last change: June 16, 2022

% Reads the input file
[clus_file,res_fil,area_file,Zth,start_time,end_time,yearchMc,Mc1,Mc2,label,td]=input_train_read(fileinname);


% Generates names and vectors to be used; adds default values
[res_file,res_file2,T,PL,FEA,k,COL,MK,MS]=input_train_build(res_fil,area_file,td);


