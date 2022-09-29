% Training of NESTORE algorithm

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

% last change August 11, 2022

addpath('../src/');
addpath('../src/external/');
addpath('../src/external/Bookmaker/');
addpath('../src/external/filetime/');

fileinname='fileinput_training.txt';	
%fileinname='fileinput_training_Italy.txt';	
%fileinname='fileinput_training_Italy_GNGTS.txt';	
%fileinname='fileinput_training_friuli.txt';	
%fileinname='fileinput_training_Corinth.txt';	

% Reads the input files and generates input strings and vectors
[clus_file,res_file,PL,Zth,start_time,end_time,yearchMc,Mc1,Mc2,res_file2,T,td,label,FEA,k,COL,MK,MS]=input_train(fileinname);


% Evaluates the features for every time interval and writes them in 
% res_stop files 
% Output: NCLUS vector containing the number of clusters available for each
% T(i)
[NCLUS,NCLUSA,NCLUSB]=feacalc_nostop(T,td, res_file, clus_file,label,PL,Zth, start_time, end_time,yearchMc,Mc1,Mc2);

% Allows the analysis only for T(i) having NCLUS(i) > 10
[T,td,ch]=check_T_clus(T,td,NCLUS,NCLUSA);

if ch==0
    return
end

% Evaluates the performances of the features in the selected time intervals  
% by training one-node decision trees and testing with LOO method;
% writes files of precision, recall, accuracy, informedness, markedness,
% confusion matrix (cm) and performances for every cluster and time interval
perf_loo_nostop(T,res_file)


% Reads performances files (estimators) and shows them; 
% each feature evaluates the "good" interval [in days] in which
% - the estimators are defined, 
% - they are greater than 0.5 (Informedness >0) 
% - the accuracy is greater or equal to the one of the constant feature
% writes range_file 
showperf_th05_nostop(td,FEA,k,res_file)


% Evaluates the features for different time intervals for each feature 
% by using the "good interval" defined in showperf_th05_nostop 
rebuild_feafile_stop(T,td, res_file, res_file2);

% Evaluates the performances of the features in the selected "good interval"  
% by a LOO method and one-node decision trees 
perf_loo_stop(T,res_file2)

% Reads performances files (estimators) and shows them; 
% each performance file is evaluated in the  "good" interval 
showperf_stop(td,FEA, res_file, res_file2, COL, MK, MS)

%Shows ROC diagrams
[FPR,TPR]=ROC_diag(res_file2,T,td,FEA, COL, MK, MS);

%Calculates the thresholds for every feature in the selected time intervals
%[tin, tfin]. after the evalution, imposes th(j-i)<=th(j); if it does not 
%happen, sets th(j-i)=th(j) going from tfin to tin
%writes thresholds' file
thresfinder(T,td, FEA, res_file, res_file2, FPR, TPR);


%estimates the probabilities to be an A cluster under and over threshold
%for each feature if the probability to be A is over the threshold is <0=.5,
%the threshold is set to NaN
calcprobA_th05(T,res_file2);


