function [NCLUS,NCLUSA,NCLUSB]=feacalc_stop(T,td, res_file, res_file2, clus_file, label, PL,Zth, start_time, end_time,yearchMc,Mc1,Mc2,module_type)

% This function evaluates the features for different time intervals inside 
% the "good interval" defined in the training;
% For each A-type cluster the features are calculated until the occurrence 
% of the first aftershock having Magnitude >Mm-1;
% This event can occur before the occurrence of the strongest aftershock.
% The features evaluation is performed for clusters with Dm<0.8 and Dm>1.2 
% to avoid uncertainties in classification;
% uses the value Mc as completeness magnitude of the cluster when it can 
% not be evaluated due to the small number of available events 

% calls feacalc_stop_ti; 

% Input:
% T           = time intervals (letters)
% td          = time intervals (number [days])
% res_file    = first part of the name of the feature file
% res_file2   = first part of the name of the new feature file calculated in the good interval
% clus_file   = name of the clusters' file
% label        = 0, all clusters
% label        = 1, clusters of Mm-Mc>=3. They can be class type B or class type 
%                A with dt>time 
% label        = 2, clusters of Mm-Mc>=2. They can be class type B or class type
%                A with dt>time (used for the last version of NESTORE)
% PL          = polygon in which the analysis is performed
% Zth         = maximum depth
% start_time  = starting year to consider the mainshock 
% end_time    = ending year to consider the mainshock 
% yearchMc    = year of Mc change 
% Mc1         = default completeness magnitude for year < yearchMc
% Mc2         = default completeness magnitude for year >= yearchMc
% module_type = specifies the calling module type 

% OUTPUT:
% NCLUS      = vector containing the number of clusters available for each Ti
% NCLUSA     = vector containing the number of A clusters available for each Ti
% NCLUSB      = vector containing the number of B clusters available for each Ti

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
% last change September 21, 2022

fprintf('\n\nThis is feacalc_stop.m\n\n');

 if strcmp(module_type,'nrt')==1  
    clus_file1=fullfile('../data/Nrt_Output/',clus_file);
    res_file_2=fullfile('../data/Nrt_Output/',res_file2);
else
    clus_file1=fullfile('../data/Clusters/',clus_file);
    res_file_2=fullfile('../data/Testing_Output/',res_file2);
end


%loads the file containing the good interval
range_file=fullfile('../data/Training_Output/',sprintf('range_M2_%s.dat', res_file));
range=load(range_file);


% for the features used in NESTORE the routine puts in vector v
% the start time of good interval and time corrisponding to the maximum of 
% informedness.
% Some features are disabled by inserting a start time larger than maximum 
% value of td.
v=[td(end)+1,td(end)+1];
[w,~]=size(range);
for(i=1:w-1)
    v=[v,range(i,1),range(i,2)];
end
v=[v,v(1),v(1),v(1),v(1)];
v=[v,range(w,1),range(w,2)];

NCLUS=zeros(length(T),1);
NCLUSA=zeros(length(T),1);
NCLUSB=zeros(length(T),1);

%for each Ti, estimateds the features
for(i=1:length(T))
    fileout=sprintf('%s_%s.dat',res_file_2, T{i});
    fprintf('\n\nCalling feacalc_stop_ti.m Ti=%s\n\n', T{i});
    [nclus,nclusA,nclusB]=feacalc_stop_ti(clus_file1,fileout,3600*24*td(i),label ,v, PL,Zth, start_time, end_time,yearchMc,Mc1,Mc2,module_type);
    NCLUS(i)=nclus;
    NCLUSA(i)=nclusA;
    NCLUSB(i)=nclusB;
end

