function [NCLUS,NCLUSA,NCLUSB]=feacalc_nostop(T,td, res_file, clus_file, label,PL,Zth, start_time, end_time,yearchMc, Mc1,Mc2)
% Evaluates the features for every time interval T(i).
% it calls feacalc_nostop_ti for every time interval which writes 
% res_no_stop files for every time interval

% INPUT:
% T          = time interval (letters)
% td         = time interval (number [days])
% res_file   = first part of the name of the feature file
% clus_file  = name of the clusters' file
% label      = 0, all clusters
% label      = 1, clusters of Mm-Mc>=3. They can be class type B or class type 
%              A with dt>time 
% label      = 2, clusters of Mm-Mc>=2. They can be class type B or class type
%              A with dt>time (used for the last version of NESTORE)
% PL  = polygon in which the analysis is performed
% Zth     = maximum depth
% start_time = starting year to consider the mainshock 
% end_time   = ending year to consider the mainshock 
% yearchMc   = year of Mc change 
% Mc1        = default completeness magnitude for year < yearchMc
% Mc2        = default completeness magnitude for year >= yearchMc

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
% last change September 22, 2022

fprintf('\n\nThis is feacalc_nostop.m\n\n');


NCLUS=zeros(length(T),1);
NCLUSA=zeros(length(T),1);
NCLUSB=zeros(length(T),1);

%for each Ti, estimateds the features
for(i=1:length(T))
    fileout=sprintf('%s_%s.dat',res_file, T{i});
    fprintf('\n\nCalling feacalc_nostop_ti.m Ti=%s\n\n', T{i});
    [nclus,nclusA,nclusB]=feacalc_nostop_ti(clus_file,fileout,3600*24*td(i),label,PL, Zth, start_time, end_time, yearchMc, Mc1, Mc2);
    NCLUS(i)=nclus;
    NCLUSA(i)=nclusA;
    NCLUSB(i)=nclusB;
end

