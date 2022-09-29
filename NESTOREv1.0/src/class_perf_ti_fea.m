function [pre,re,acc,infor, cm]=class_perf_ti_fea(typeT,typeP)
% Calculates Precision Recall Accuracy Informedness and Confusion Matrix 
% given the vectors of predictions and of the true classes

% Input:
% typeT     = vector of true class
% typeP     = vector of predicted class

% Output: 
% pre       = Precision 
% re        = Recall 
% acc       = Accuracy
% infor     = Informedness
% cm        = Confusion Matrix 



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
% License: GNUGPLv3
% last update: 07.09.20

TP=0;
TN=0;
FP=0;
FN=0;


% evaluates True Positive, False Positive True Negative e False
% Negatives

for(i=1:length(typeP))
    
    if(strcmp('A',typeT{i}) & strcmp('A',typeP{i}))
        TP=TP+1;
    end
    
    if(strcmp('B',typeT{i}) & strcmp('B',typeP{i}))
        TN=TN+1;
    end
    
    if(strcmp('B',typeT{i}) & strcmp('A',typeP{i}))
        FP=FP+1;
    end
    
    if(strcmp('A',typeT{i}) & strcmp('B',typeP{i}))
        FN=FN+1;
    end
    
end


%Precison
pre=TP/(TP+FP);
%Recall
re=TP/(TP+FN);
%Accuracy
acc=(TP+TN)/(TP+FN+FP+TN);
%Confusion Matrix
cm=[TP,FP;FN,TN];

[results,~] = bookmaker(cm);
infor=results.bookmaker;