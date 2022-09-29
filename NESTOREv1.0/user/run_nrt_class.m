% Near Real Time classification of a new cluster by NESTORE algorithm

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
% last update: August 12, 2022


addpath('../src/');
addpath('../src/external/');
addpath('../src/external/Bookmaker/');
addpath('../src/external/filetime/');

%input filename
fileinname='fileinput_nrt_class.txt';

% Reads the input files and generates input strings and vectors
[filein,clus_file,res_nrt_file,res_train_file,res_train_file2,form_space,form_time,form_time2,ThM,Thwt,coeff_space_fore,coeff_time_fore,PL,Zth,start_time,end_time,yearchMc,Mc1,Mc2,T,td,label,dt]=input_nrt(fileinname);


%label for using the same functions in different cases
module_type='nrt';


%extracts the cluster from the input file
[mCatalog, mCatDecluster, mCatAfter, mCatMain, vCluster, vCl, vMainCluster]=clus_ident(filein, clus_file, form_space,form_time, ThM, Thwt,form_time2,coeff_space_fore,coeff_time_fore,module_type);

%selects td in order to perform the analysis for td<= of the time selected
%by the user
u=find(td<=dt);
td=td(u);
T=T(u);



% Plots the magnitude time distribution of cluster's aftershocks and the 
% map of the aftershock distribution 
nrt_maps(mCatMain,mCatAfter,td);


% Evaluates the features for different time intervals for each feature 
% inside the "good interval" defined in the training
feacalc_stop(T,td, res_train_file, res_nrt_file, clus_file, label, PL,Zth, start_time,end_time,yearchMc,Mc1,Mc2,module_type);


% Takes in input Th_prob file, and the NAB file, and the file to be 
% classified  and generates the classification file; shows the results  
[PC]=nrt_class_stop(res_train_file2, res_nrt_file, T,td);



% Shows the results of the classification and the time and space for forecasting 
result_msg(mCatMain, form_space, form_time, form_time2, Thwt, PC);