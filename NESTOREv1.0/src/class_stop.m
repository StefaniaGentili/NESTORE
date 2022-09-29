function [max_T]=class_stop( res_file2, res_file3, T )
% Takes in input Th_prob file, and the NAB file, and the file to be
% classified  and generates the classification file
% Threshold for Bayes classification in A class pc>=0.5, for classification 
% in B class pc<0.5 for simple classifier A if 
% (number of A classification)>= (number of B classifications)

% INPUT:
% res_file2 = name of the training feature file with the stops defined by the first
%             part of the training; it is used to generate the names of Th_prob file
%             and  NAB file to be used
% res_file3 = name of the feature file to be classified
% T         = string with the times to be added in generating input and
%             output file names

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
% last update: August 11, 2022

fprintf('\n\nThis is class_stop.m\n\n');


%threshods and probability to be A file
th_prob_file=fullfile('../data/Training_Output/',sprintf('Th_prob_M2_%s.txt',res_file2));

Th=load(th_prob_file);

[~,v]=size(Th);
max_T=min(v/3,length(T));
T=T(1:max_T);

% file showing the number or A and B clusters in the training set for each
% Ti
numAB_file=fullfile('../data/Training_Output/',sprintf('NumAB_%s.txt',res_file2));
NAB=load(numAB_file);

% Loop on time interval
for(col=1:length(T))
    
    
    filein=fullfile('../data/Testing_Output/',sprintf('%s_%s.dat',res_file3,T{col}));
    
    
    fileout=fullfile('../data/Testing_Output/',sprintf('class_%s_%s.dat',res_file3,T{col}));
    
    fid=fopen(fileout,'w');
    
    
    [Date,Time,ML,Lat,Lon,Depth,Naft,Maft,Dateaft,Timeaft,Lataft,Lonaft,Depthaft,Dt,ty,Mc,dMc,N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor] = textread(filein,'%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d');
    fprintf(fid,'Date Time ML Lat Lon Depth Naft Maft Dateaft Timeaft Lataft Lonaft Depthaft Dt ty Mc dMc N S Z SLcum QLcum SLcum2 QLcum2 Q Vm Vmed Vn N2 Nfor P_S C_S P_Z C_Z P_SLcum C_SLcum P_QLcum C_QLcum P_SLcum2 C_SLcum2 P_QLcum2 C_QLcum2 P_Q C_Q P_Vm C_Vm P_N2 C_N2 P_A_Bayes C_Bayes numB numA Class_simp \n');
    
    %the features are listed in fea file
    fea=[S,Z,SLcum,QLcum,SLcum2, QLcum2,Q,Vm, N2];
    
    
    [v,su]=size(fea);
    
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
        
        % cicle on the features; Th format: th1, P_less1, P_more1, th2....
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
        na=NAB((col-1)*2+1);
        nb=NAB((col-1)*2+2);
        
        %calculates the Bayes probabiility only if some feature supplies a
        %classification
        if(~isempty(P))
            [pc]=class_stop_comb_bayes(P,na,nb);
        else
            pc=NaN;
        end
        
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
    
    fclose(fid);
end