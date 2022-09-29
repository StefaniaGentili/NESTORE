% Testing of NESTORE algorithm

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

% last update: August 22, 2022

addpath('../src/');
addpath('../src/external/');
addpath('../src/external/Bookmaker/');
addpath('../src/external/filetime/');

%input filename
fileinname='fileinput_testing.txt';


% Reads the input files and generates input strings and vectors
[clus_file3,res_train_file,res_train_file2,res_file3,PL,Zth,start_time,end_time,yearchMc,Mc1,Mc2,T,td,label,FEA2,COL,MK,MS]=input_test(fileinname);

%specifies the module type for feacalc_stop function
module_type='test';


% Evaluates the features for different time intervals for each feature 
% inside the "good interval" defined in the training
[NCLUS,NCLUSA,NCLUSB]=feacalc_stop(T,td,res_train_file, res_file3, clus_file3, label,PL,Zth,start_time,end_time,yearchMc,Mc1,Mc2,module_type);


% Takes in input Th_prob file, and the NAB file, and the file to be 
% classified  and generates the classification file.  
[max_T]=class_stop(res_train_file2,res_file3,T);

T=T(1:max_T);
td=td(1:max_T);

% Evaluates the performances of the features and of Nestore basing on the 
% classification files, automatically generated. 
% Output: files of precision, recall, accuracy, informedness, 
% cm (confusion matrix)
class_perf(T,res_file3);


% Plots the classification in time for all the elements of the
% classification file. In red A clusters and in blue B ones. Writes on
% screen if some cluster is wrongly classified for all time periods and
% outlines the corresponding plot in yellow
class_bayes_fig( res_file3, T , td)

% Checks the number of available cluster generates the
% vectors T and td only for T(i) having NCLUS(i) > 10 and NCLUSA>=2
[T,td,ch]=check_T_clus(T,td, NCLUS,NCLUSA);


%shows the diagrams on reliable data only
max_R=length(T);

if(max_R>0)   
    % Shows the ROC diagram using cm file(confusion matrices)
    ROC_class_diag(res_file3, T, td,FEA2, COL, MK, MS)
    fprintf('Last reliable time interval for statistical analysis Ti = %s\n',T{end});
else
    fprintf('Not enough data for ROC and Precision-Recall:\nAt 6 hours number of clusters = %d, number of A clusters = %d\n',NCLUS(1),NCLUSA(1));
end








