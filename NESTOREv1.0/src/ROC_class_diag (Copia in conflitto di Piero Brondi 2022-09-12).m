function ROC_class_diag(input_file,T,td,FEA2, COL, MK, MS)
% Calculates the fpr and tps using cm file (confusion matrices) for each T
% shows the ROC diagram and Precision-Recall graph 

% INPUT:
% input_file = name of the file that has been classified (used to generate 
%              input confusion matrix file name)
% T          = time intervals (string)
% td         = time intervals (number [days])
% FEA2       = 'Random' + features names
% COL        = color of the lines
% MK         = symbols of the markers
% MS         = markers' size
%

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.

% S. Gentili, sgentili@ogs.it
% English comments and variable naming by P. Brondi pbrondi@ogs.it
% License: GNUGPLv3
% last update: August 17, 2022


fprintf('\n\nThis is ROC_class_diag.m\n\n');

%generates the confusion matrix name and reads it
cm=fullfile('../data/Testing_Output/',sprintf('cm_class_M2_stop_%s.dat', input_file));
cm
CM=load(cm);
CM


%generates the indexes
I=1:length(FEA2)-1;
p2=(I-1)*4+1;

pp=p2(end-1);
p2(end-1)=p2(end);
p2(end)=pp;

%estimates the number of clusters and A clusters in the testing set 
NCLUS=[];
NCLUSA=[];

[u,v]=size(CM)
for(i=1:u)
 NCLUS=[NCLUS;sum(CM(i,[v-3:v]))];
 NCLUSA=[NCLUSA;CM(i,v-3)+CM(i,v-1)];
end
NCLUS
NCLUSA
% Checks the number of available cluster generates the
% vectors T and td only for T(i) having NCLUS(i) > 10 and NCLUSA>=2
[T,td,ch]=check_T_clus(T,td, NCLUS,NCLUSA)

%shows the diagrams on reliable data only
max_R=length(T);
CM=CM(1:max_R,:);

CM

%figure of the ROC for all features and all time intervals
figure;
% shows the line corresponding to random classifier
hold on; plot([0,1],[0,1],'k','LineWidth',2,'LineStyle','--'); %random
%shows the ROCS diagram for all time periods Ti
for(i=1:length(p2))
    hold on; plot(CM(:,p2(i)+1) ./(CM(:,p2(i)+1)+ CM(:,p2(i)+3)) ,CM(:,p2(i)) ./(CM(:,p2(i)) +CM(:,p2(i)+2)),'Color',COL(i,:),'LineWidth',2,'LineStyle','none','Marker',MK(i),'MarkerSize',MS(i));
end
xlabel('False Positive Rate')
ylabel('True Positive Rate');
legend(FEA2)





% figure of the Precision-Recall curve for all features and all time intervals
figure;
%random classifier shown only for T=6h: P/(P+N)
P=CM(1,end-3)+CM(1,end-1);
N=CM(1,end-2)+CM(1,end);
crand=P/(P+N);
% shows the line corresponding to random classifier
hold on; plot([0,1],[crand,crand],'k','LineWidth',2,'LineStyle','--'); %random
ylim([0 1]);
%shows the Precision Recall curve for all time periods Ti
for(i=1:length(p2))
    hold on; plot( CM(:,p2(i)) ./(CM(:,p2(i)) +CM(:,p2(i)+2)),CM(:,p2(i)) ./(CM(:,p2(i))+ CM(:,p2(i)+1)),'Color',COL(i,:),'LineWidth',2,'LineStyle','none','Marker',MK(i),'MarkerSize',MS(i));
end
xlabel('Recall')
ylabel('Precision');
legend(FEA2,'Location','northwest')




%ROC diagrams for different time intervals separately
for(i=1:length(td))
    fpr=[];
    tpr=[];
    %random classifier
    figure; plot([0,1],[0,1],'k','LineWidth',2,'LineStyle','--');
    
    for(j=1:length(p2))
        fpr=[fpr,CM(i,p2(j)+1)./(CM(i,p2(j)+1)+CM(i,p2(j)+3))];
        tpr=[tpr,CM(i,p2(j))  ./(CM(i,p2(j))  +CM(i,p2(j)+2))];
        hold on; plot(fpr(end),tpr(end),'Color',COL(j,:),'LineWidth',2,'Marker',MK(j),'MarkerSize',MS(j));
        
    end   

    xlabel('False Positive Rate')
    ylabel('True Positive Rate');
    stringT=sprintf('Observation Time %.2f [days]',td(i));
    title(stringT);
    
    string_ROC=sprintf('../data/Testing_Output/Figures/ROC_ObservationTime%s.png',T{i});
    legend(FEA2)
    print(gcf,string_ROC,'-dpng','-r100')
end


%Precision-Recall curve for different time intervals separately
for(i=1:length(td))
    
    figure;
    %random classifier for Ti: P/(P+N)
    P=CM(i,end-3)+CM(i,end-1);
    N=CM(i,end-2)+CM(i,end);
    crand=P/(P+N);
    % shows the line corresponding to random classifier
    plot([0,1],[crand,crand],'k','LineWidth',2,'LineStyle','--'); %random
    ylim([0 1]);
    
    for(j=1:length(p2))
        hold on; plot( CM(i,p2(j)) ./(CM(i,p2(j)) +CM(i,p2(j)+2)),CM(i,p2(j)) ./(CM(i,p2(j))+ CM(i,p2(j)+1)),'Color',COL(j,:),'LineWidth',2,'LineStyle','none','Marker',MK(j),'MarkerSize',MS(j));
    end
    xlabel('Recall')
    ylabel('Precision');
    stringT=sprintf('Observation Time %.2f [days]',td(i));
    title(stringT);
    string_PR=sprintf('../data/Testing_Output/Figures/PR_ObservationTime%s.png',T{i});
    legend(FEA2,'Location','northwest')
    print(gcf,string_PR,'-dpng','-r100')

end
