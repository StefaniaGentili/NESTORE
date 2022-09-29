function [x]=train_tree(fea,ty)
% Trains a one-node decision tree given one feature and the corresponding 
% classification. Returns the threshold corresponding to the split in the 
% node. If one or more elements of the feature vector is NaN the function
% returns NaN

% Input:
% fea      =  feature vector for a given T(i) each element corresponds to a 
%             different cluster
% ty       =  class vector for a given T(i) each element corresponds to a 
%             different cluster
% Output:
% x        =  threshold for the feature


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
% English comments and variable naming by P. Brondi pbrondi@inogs.it
% License: GNUGPLv3
% last change November 10, 2021

if(prod(~isnan(fea)))
    X=fea;
    Y=ty;
    
    % The decision tree is trained by imposing one only split
    tr=fitctree(X,Y,'MaxNumSplits',1);
    x=tr.CutPoint(1);
else
    x=NaN;
end
