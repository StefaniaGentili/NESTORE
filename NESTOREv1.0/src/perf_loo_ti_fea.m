function [cvErr,pre,re,acc,cm]=perf_loo_ti_fea(fea,type)
% Calculates by the LOO method the performances of a single
% features at a given time T(i). In particular, for each training set
% evaluates the decision tree to classify the test cluster 

% Input:
% fea      = selected feature vector (one value for each cluster)
% type     = correct classification vector

% Output:
% cvErr    = normalized error
% pre      = precision
% re       = recall
% acc      = accuracy
% cm       = confusion matrix


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
% last change November 8, 2021

CVO = cvpartition(type,'leaveout');
err = zeros(CVO.NumTestSets,1);

TP=0;
TN=0;
FP=0;
FN=0;

for i = 1:CVO.NumTestSets
    %current training
    trIdx = CVO.training(i);
    %current test
    teIdx = CVO.test(i);
    
    % fictree needs at least 10 patterns to
    % perform training.
    
    X=fea(trIdx,:);
    Y=type(trIdx,:);

    %the constant feature classifies all clusters as B
    if(max(X)==min(X))
        ytest='B';
    else
        tr=fitctree(X,Y,'MaxNumSplits' ,1 );
        ytest = predict(tr, fea(teIdx,:));
    end
    % Estimates the number of True Positives, False Positives, True
    % Negatives and False Negatives
    
    if(strcmp('A',type(teIdx)) & strcmp('A',ytest))
        TP=TP+1;
    end
    
    if(strcmp('B',type(teIdx)) & strcmp('B',ytest))
        TN=TN+1;
    end
    
    if(strcmp('B',type(teIdx)) & strcmp('A',ytest))
        FP=FP+1;
    end
    
    if(strcmp('A',type(teIdx)) & strcmp('B',ytest))
        FN=FN+1;
    end
    

    err_perf=~strcmp(type(teIdx),ytest);
    err(i) = sum(err_perf);

end

%precision
pre=TP/(TP+FP);
%recall
re=TP/(TP+FN);
%accuracy
acc=(TP+TN)/(TP+FN+FP+TN);
cm=[TP,FP;FN,TN];

cvErr = sum(err)/sum(CVO.TestSize);