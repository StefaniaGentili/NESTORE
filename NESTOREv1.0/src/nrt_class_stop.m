function [PC]=nrt_class_stop( res_train_file2, res_nrt_file, T,td )
% Takes in input Th_prob file, the NAB file, and the file to be
% classified and generates the classification file; shows the results

% Threshold for Bayes classification in A class pc>=0.5, for classification 
% in B class pc<0.5 for simple classifier A if 
% (number of A classification)>= (number of B classifications)


% INPUT: 
% res_train_file2 = name of the training feature file with the stops 
%                   defined during the training; it is used to generate the 
%                   names of Th_prob file and  NAB file to be used
% res_nrt_file    = name of the feature file to be classified
% T               = string with the times to be added in generating input and
%                   output file names
% td              = time intervals (number [days])

% Output:
% PC             = vector with the probability to be an A cluster for each
%                  time period
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

% Authors:
% S. Gentili, sgentili@ogs.it
% P. Brondi,  pbrondi@ogs.it
% License: GNUGPLv3
% last change September 23, 2022

PC=[];

%TIP: IF FILENAME IS TOO LONG, LOAD DOESN'T WORK


%threshods and probability to be A file
th_prob_file=fullfile('../data/Training_Output/',sprintf('Th_prob_M2_%s.txt',res_train_file2));

Th=load(th_prob_file);


% file with the number or A and B in each training set
numAB_file=fullfile('../data/Training_Output/',sprintf('NumAB_%s.txt',res_train_file2));
NAB=load(numAB_file);


u=length(T);
n1=ceil(sqrt(u));
n2=ceil(u/n1);


for(col=1:length(T))

    filein=fullfile('../data/Nrt_Output/',sprintf('%s_%s.dat',res_nrt_file,T{col}));
    
    fileout=fullfile('../data/Nrt_Output/',sprintf('class_%s_%s.dat',res_nrt_file,T{col}));
    
    fid=fopen(fileout,'w');

   
    [Date,Time,ML,Lat,Lon,Depth,Naft,Maft,Dateaft,Timeaft,Lataft,Lonaft,Depthaft,Dt,ty,Mc,dMc,N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor] = textread(filein,'%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d');
    fprintf(fid,'Date Time ML Lat Lon Depth Naft Maft Dateaft Timeaft Lataft Lonaft Depthaft Dt ty Mc dMc N S Z SLcum QLcum SLcum2 QLcum2 Q Vm Vmed Vn N2 Nfor P_S C_S P_Z C_Z P_SLcum C_SLcum P_QLcum C_QLcum P_SLcum2 C_SLcum2 P_QLcum2 C_QLcum2 P_Q C_Q P_Vm C_Vm P_N2 C_N2 P_A_Bayes C_Bayes numB numA Class_simp \n');
    
    %the features are listed in fea file
    fea=[S,Z,SLcum,QLcum,SLcum2, QLcum2,Q,Vm, N2];

    

    [~,su]=size(fea);
     

    % Loop on the clusters to be analyzed
    for(i=1:length(ML))
        fprintf(fid,'%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d ',Date{i},Time{i},ML(i),Lat(i),Lon(i),Depth(i),Naft(i),Maft(i),Dateaft{i},Timeaft{i},Lataft(i),Lonaft(i),Depthaft(i),Dt(i),ty{i},Mc(i),dMc(i),N(i),S(i),Z(i),SLcum(i),QLcum(i),SLcum2(i),QLcum2(i),Q(i),Vm(i),Vmed(i),Vn(i),N2(i),Nfor(i));
        

        numB=0;
        numA=0;
        
        %Probability vector P, P2: 
        % P contains only data for available features for the analyzed Ti, 
        % P2 contains also NaN for unavailable features for the analyzed Ti
        P=[];
        P2=[];
  
        % loop on the features; Th format: th1, P_less1, P_more1, th2....
        % th#=threshold for the #th feature 
        % P_less# and P_more# probability to be A under and over th#
        
        for(j=1: su)
            
            if(~isnan(Th(j,(col-1)*3+1)))
                if(fea(i,j)<Th(j,(col-1)*3+1))
                    
                    p=Th(j,(col-1)*3+2);
                    if(~isnan(p))
                        P=[P;p];
                        P2=[P2;p];
                        fprintf(fid, '%.2f B ', p);
                        numB=numB+1;
                    else
                        fprintf(fid, 'NaN NaN ');
                        P2=[P2;NaN];
                    end
                else
                    p=Th(j,(col-1)*3+3);
                    if(~isnan(p))
                        P=[P;p];
                        P2=[P2;p];
                        fprintf(fid, '%.2f A ', p);
                        numA=numA+1;
                    else
                        fprintf(fid, 'NaN NaN ');
                        P2=[P2;NaN];
                    end
                end
            else
                
                fprintf(fid, 'NaN NaN ');
                P2=[P2;NaN];
            end
            
            
        end
        
 
        % Probability to be an A for the single cluster for all features.
        % Should be commented for multi-cluster analysis
        PA={'P(A|S)','P(A|Z)', 'P(A|SLCum)', 'P(A|QLCum)','P(A|SLCum2)','P(A|QLCum2)', 'P(A|Q)','P(A|Vm)','P(A|N2)'};
        
        
        %plots the probabilities for each feature
        multiwaitbar_nrt(length(P2),P2',PA);
        
        
        string_pa=sprintf('P(A) %s',T{col});
        fig=gcf;
        fig.Name=string_pa;
        string_FeaProb=sprintf('../data/Nrt_Output/Figures/AClassFeaProbability_OT%s.png',T{col});
        print(gcf,string_FeaProb,'-dpng','-r100')

        
        na=NAB((col-1)*2+1);
        nb=NAB((col-1)*2+2);
        
        %calculates the Bayes probabiility only if some feature supplies a
        %classification
        if(~isempty(P))
            [pc]=class_stop_comb_bayes(P,na,nb);
        else
            pc=NaN;
        end

        PC=[PC;pc];
        
        %assigns the class A to Bayes classifier if pc in not NaN and is
        %>=0.5
        if(pc>=0.5)
            fprintf(fid,'%.2f A ',pc);
        elseif(pc<0.5)
            fprintf(fid,'%.2f B ',pc);
        else
            fprintf(fid,'NaN NaN ');
        end
        
        fprintf(fid, '%d %d ',numB,numA);
        
        %assigns the class A to Simple classifier if (numA OR numB >0) and
        %numA>=numB
        if(numB+numA>0)
            if(numB>numA)
                fprintf(fid, 'B\n');
            elseif(numA>=numB)
                fprintf(fid, 'A\n');
            end
        else
            fprintf(fid, 'NaN\n');
        end
        
        
    end
    hold off
    fclose(fid);
end

% Plots the probability of being type A during time with ATLS classification;
% the color is blue or red if all the probabilities to be A are lower than 
% 0.6 [green light] or larger than 0.8 [red light], respectively (the class
% is coherent and well-defined for all time periods analyzed). In all the 
% other cases [yellow light], the color is black


figure;
pos1 = [0.2 0.2 0.7 0.7];
pos2 = [0.9 0.7 0.1 0.3];
if(max(PC)<=0.4)
    subplot('Position',pos1)
    plot(td,PC,'o-','markersize',10,'color',[0,113/255,188/255],'MarkerFaceColor',[0,113/255,188/255]);
    hold on; plot([0,td(end)+0.5],[0.5,0.5],'k');
    
    xlabel('T [Days]','FontWeight','bold','FontSize',13)
    ylabel('Prob(A)','FontWeight','bold','FontSize',13)

    set(gca,'box','on',...
        'SortMethod','childorder','TickDir','out','FontWeight',...
        'bold','FontSize',13,'Linewidth',[1.2])
    ylim([-0.1, 1.1]);
    xlim([0, td(end)+0.5]);
    subplot('Position',pos2)
    imshow(imread('Green_Light.jpg'));
    
elseif(min(PC)>0.6)   
    subplot('Position',pos1)
    plot(td,PC,'o-','markersize',10,'color','r','MarkerFaceColor','r');
    hold on; plot([0,td(end)+0.5],[0.5,0.5],'k');
    
    xlabel('T [Days]','FontWeight','bold','FontSize',13)
    ylabel('Prob(A)','FontWeight','bold','FontSize',13)

    set(gca,'box','on',...
        'SortMethod','childorder','TickDir','out','FontWeight',...
        'bold','FontSize',13,'Linewidth',[1.2])
    ylim([-0.1, 1.1]);
    xlim([0, td(end)+0.5]);
    subplot('Position',pos2)
    imshow(imread('Red_Light.jpg'));
else
    
    subplot('Position',pos1)
    plot(td,PC,'o-','markersize',10,'color','k','MarkerFaceColor','k');
    hold on; plot([0,td(end)+0.5],[0.5,0.5],'k');
    
    xlabel('T [Days]','FontWeight','bold','FontSize',13)
    ylabel('Prob(A)','FontWeight','bold','FontSize',13)

    set(gca,'box','on',...
        'SortMethod','childorder','TickDir','out','FontWeight',...
        'bold','FontSize',13,'Linewidth',[1.2])
    ylim([-0.1, 1.1]);
    xlim([0, td(end)+0.5]);
    subplot('Position',pos2)
    imshow(imread('Yellow_Light.jpg'));
end
print(gcf,'../data/Nrt_Output/Figures/AClassProbability-Time.png','-dpng','-r100')

