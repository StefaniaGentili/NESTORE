function [clus_file3,res_train_file,res_train_file2,res_file3,PL,Zth,start_time,end_time,yearchMc,Mc1,Mc2,T,td,label,FEA2,COL,MK,MS]=input_test(fileinname)
% Reads the input files and generates input strings and vectors for Testing
% module of NESTORE

% INPUT:
% fileinname = input file listing cluster name, parameters etc

% OUTPUT:
% clus_file3 = name of the clusters' file
% res_train_file = first part of the name of the training feature file 
%                  calculated in all the time periods
% res_train_file2= first part of the name of the training feature file 
%                  calculated in the selected time periods
% res_file3  = first part of the name of the test feature file 
% PL         = polygon in which the analysis is performed
% Zth        = maximum depth
% start_time = starting year to consider the mainshock 
% end_time   = ending year to consider the mainshock 
% yearchMc   = year of Mc change 
% Mc1        = default completeness magnitude for year < yearchMc
% Mc2        = default completeness magnitude for year >= yearchMc
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
% FEA2      = considered features names
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
[clus_file3,res_train_fil,res_fil3,area_file,Zth,start_time,end_time,yearchMc,Mc1,Mc2,label,td]=input_test_read(fileinname);


% Generates names and vectors to be used; adds default values
[res_train_file, res_train_file2,res_file3, T,PL,FEA2,COL,MK,MS]=input_test_build(res_train_fil,res_fil3, area_file,td);


