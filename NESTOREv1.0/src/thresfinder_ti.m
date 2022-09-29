function [thfea]=thresfinder_ti(filein)

% Reads the feature file and calls train_tree for each feature
% Input:
% filein =  first part of the name of the feature file calculated in 
%           the good interval for a given T(i)

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.

% S. Gentili, sgentili@inogs.it 
% P. Brondi pbrondi@inogs.it
% License: GNUGPLv3
% last change April 7, 2022


[Date,Time,ML,Lat,Lon,Depth,Naft,Maft,Dateaft,Timeaft,Lataft,Lonaft,Depthaft,Dt,ty,Mc,dMc,N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor] = textread(filein,'%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d');



% building the vector of features
FEATURES=[S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,N2];

% defining vector of the features threshold
thfea=zeros(1,length(FEATURES(1,:)));

%threshold evaluation
for j=1:length(FEATURES(1,:))
   fea_vect=FEATURES(:,j);
   [th]=train_tree(fea_vect,ty);
   thfea(j)=th;
   clear th;
end  


