function [T,td,ch]=check_T_clus(T,td, NCLUS,NCLUSA)
% Checks the number of available cluster generates the
% vectors T and td only for T(i) having NCLUS(i) >= 9 and NCLUSA>=2

% Input:
% T     =   Time intervals (characters [days])
% td    =   Time intervals (numbers [days]) 
% NCLUS =   Number of available clusters for each T(i)
% NCLUSA=   Number of available clusters of class A for each Ti

% Output:
% T     =   Time intervals (characters [days]) having NCLUS(i) >= 9
% td    =   Time intervals (numbers [days]) having NCLUS(i) >= 9
% ch    =   Binary variable checking if there is at least one T(i)
%           satisfying the condition NCLUS(i)>10 and NCLUSA>=2 [ch=1] 
%           or not [ch=0]

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
% P. Brondi pbrondi@inogs.it
% License: GNUGPLv3
% last change August 11, 2022

fprintf('\n\nThis is check_T_clus.m\n\n');

u=find(NCLUS>=9);
v=find(NCLUSA>=2);
w=find(NCLUS>=9 & NCLUSA>=2);

if (~isempty(u))
    if (~isempty(w))
       T=T(w);
       td=td(w);
       ch=1;
    else
       disp('Number of A-type clusters is always smaller than 3!')
       disp('Too few A-type clusters!')
       T=[];
       td=[];
       ch=0;
    end
else
    disp('Number of clusters is always smaller than 10!')
    disp('Data sample too small!')
    T=[];
    td=[];
    ch=0;
    
end