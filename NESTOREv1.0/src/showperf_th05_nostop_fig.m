function showperf_th05_nostop_fig(est_file,string_est, FEA,td)
% Reads the performance file of each estimator and creates a figure. 

% Input:
% est_file  = performance file of the estimator (e.g. recall, accuracy etc)
% string_est = estimator name [characters])
% FEA       = considered features names
% td        = time intervals (number [days])


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
% last change November 9, 2021

A=load(est_file);

figure;
plot(td,A(:,1),'r','LineWidth',3) %cost feature

hold on; errorbar(td,A(:,5),A(:,6),'Color',[255/255,177/255,100/255],'LineWidth',2,'Marker','o','MarkerSize',10) %S 
hold on; errorbar(td,A(:,7),A(:,8),'Color',[255/255,16/255,100/255],'LineWidth',2,'Marker','o','MarkerSize',5) %Z 
hold on; errorbar(td,A(:,9),A(:,10),'Color',[255/255,100/255, 177/255],'LineWidth',2,'Marker','o','MarkerSize',5) %SLcum 
hold on; errorbar(td,A(:,11),A(:,12),'Color',[177/255,255/255,100/255],'LineWidth',2,'Marker','o','MarkerSize',10) %QLcum 
hold on; errorbar(td,A(:,13),A(:,14),'Color',[255/255,100/255, 77/255],'LineWidth',2,'Marker','o','MarkerSize',5) %SLcum2 
hold on; errorbar(td,A(:,15),A(:,16),'Color',[177/255,10/255,10/255],'LineWidth',2,'Marker','o','MarkerSize',5) %QLcum2 
hold on; errorbar(td,A(:,17),A(:,18),'Color',[206/255,60/255,162/255],'LineWidth',2,'Marker','>','MarkerSize',5) %Q 
hold on; errorbar(td,A(:,19),A(:,20),'Color',[122/255,16/255,228/255],'LineWidth',2,'Linestyle', '--','Marker','^','MarkerSize',5) %V_m 
hold on; errorbar(td,A(:,25),A(:,26),'Color','b','LineWidth',2,'Marker','*','MarkerSize',5) %N2



xmax=td(end);

if strcmp(string_est,'Informedness')==1
    axis([0.25,xmax,-1,1]);
    
elseif strcmp(string_est,'Precision')==1
    axis([0.25,xmax,0,1]);
    
elseif strcmp(string_est,'Recall')==1
    axis([0.25,xmax,0,1]);
    
elseif strcmp(string_est,'Accuracy')==1
    axis([0.25,xmax,0,1]);
    
end
    





xlabel('T [days]')
ylabel(string_est);
FEA={'const',FEA{1:end}};
legend(FEA)
p=ylim;

xmax=td(end)+1.5;
axis([0,xmax,p(1),p(2)]);