function [FPR,TPR]=ROC_diag(res_file2,T,td,FEA, COL, MK, MS)

% Calculates the fpr and tps using cm file (confusion matrices) for each T
% and stores in vectors FPR and TPR; shows the ROC diagram; old cm file order 
% INPUT:
% res_file2 = name of the file that has been classified to generate cm
%              file name
% T          = time intervals (string)
% td         = time intervals (number [days])
% FEA        = features names
% COL        = color of the lines
% MK         = symbols of the markers
% MS         = markers' size
%
% OUTPUT:
% FPR        = False Positive Rate for all time intervals
% TPR        = True Positive Rate for all time intervals

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
% last change July 22, 2022

fprintf('\n\nThis is ROC_diag.m\n\n');

cm=fullfile('../data/Training_Output/',sprintf('cm_M2_stop_%s.dat', res_file2));

A=load(cm);

%generates the indexes
I=1:length(FEA)+3;
p1=I*4+1;
p2=[p1(2:9),p1(12)];


%figure of the ROC for all features and all time intervals
figure;
% shows the line corresponding to random classifier and generates the legend
hold on; plot([0,1],[0,1],'k','LineWidth',2,'LineStyle','--'); %random
LEG={'Random'};

%shows the ROC diagram for all time periods Ti and updates the legend
for(i=1:length(p2))
    
    hold on; plot(A(:,p2(i)+1) ./(A(:,p2(i)+1)+ A(:,p2(i)+3)) ,A(:,p2(i)) ./(A(:,p2(i)) +A(:,p2(i)+2)),'Color',COL(i,:),'LineWidth',2,'Marker',MK(i),'MarkerSize',MS(i));
    LEG{i+1}=FEA{i};
end
xlabel('False Positive Rate')
ylabel('True Positive Rate');
legend(LEG)


blue_str='Excluded Values';
LEG1=[LEG blue_str];

%ROC diagrams for different time intervals Ti
FPR=[];
TPR=[];
for(i=1:length(td))
    fpr=[];
    tpr=[];
    
    
    figure; plot([0,1],[0,1],'k','LineWidth',2,'LineStyle','--');
    
    for(j=1:length(p2))
        fpr=[fpr,A(i,p2(j)+1)./(A(i,p2(j)+1)+A(i,p2(j)+3))];
        tpr=[tpr,A(i,p2(j))  ./(A(i,p2(j))  +A(i,p2(j)+2))];
        hold on; plot(fpr(end),tpr(end),'Color',COL(j,:),'LineWidth',2,'Marker',MK(j),'MarkerSize',MS(j));        
    end
    
    
    FPR=[FPR;fpr];
    TPR=[TPR;tpr];
    xlabel('False Positive Rate')
    ylabel('True Positive Rate');

    string_time=sprintf('Observation Time %.2f [days]',td(i));
    title(string_time);

    %polygon mask
    axis([0,1,0,1]);
    pgon=polyshape([0 1 1],[0 0 1]);
    plot(pgon,'FaceColor','c')
    legend(LEG1)
    
    string_ROC=strcat('../data/Training_Output/Figures/ROC_',res_file2,'_ObservationTime',T{i},'.png'); 
    print(gcf,string_ROC,'-dpng','-r100')

end