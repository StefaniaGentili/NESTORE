function class_bayes_fig( input_file, T, td)
% Plots the classification during in time for all the elements of the
% test set. In red A clusters and in blue B ones. If some a cluster is 
% wrongly classified for all time periods the function outlines the 
% corresponding plot in yellow and writes the mainshock time on the screen. 

% INPUT:
% input_file = name of the file that has been classified (used to generate 
%              input confusion matrix file name)
% T          = time intervals (string)
% td         = time intervals (number [days])

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
% last change June 22, 2022


%writes on CP the time of the mainshock, the real class and in the
%following columns the classification for each time interval. if the
%cluster has not be classified at the given time interval writes NaN

fprintf('\n\nThis is class_bayes_fig.m\n\n');

% Loop on time intervals
for(col=1:length(T))
    %generates the classification file name and reads it
    filein=fullfile('../data/Testing_Output/',sprintf('class_%s_%s.dat',input_file,T{col}));
    [Date,Time,ML,Lat,Lon,Depth,Naft,Maft,Dateaft,Timeaft,Lataft,Lonaft,Depthaft,Dt,ty,Mc,dMc,N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor,P_S,C_S,P_Z,C_Z,P_SLcum,C_SLcum,P_QLcum,C_QLcum,P_SLcum2,C_SLcum2,P_QLcum2,C_QLcum2,P_Q,C_Q,P_Vm,C_Vm,P_N2,C_N2,P_A_Bayes,C_Bayes,numB,numA,Class_simp] = textread(filein,'%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d %f %s %f %s %f %s %f %s %f %s %f %s %f %s %f %s %f %s %f %s %d %d %s', 'headerlines',1);
    
    
    % for the first time interval 
    
    % For all clusters of the classification file writes in CP the time 
    % (in years and fractions of year), the real class (A=1 B=0), the
    % final classification 
    if(col==1)
        CP=[];
        for(i=1:length(Date))
            
            k = strfind(Date{i},'/');
            
            day=str2double(Date{i}(1:k(1)-1));
            month=str2double(Date{i}(k(1)+1:k(2)-1));
            year=str2double(Date{i}(k(2)+1:end));
           
            
            k = strfind(Time{i},':');
            
            hour=str2double(Time{i}(1:k(1)-1));
            minute=str2double(Time{i}(k(1)+1:k(2)-1));
            second=str2double(Time{i}(k(2)+1:end));

            
            time = datenum(year,month, day, hour, minute, second);

            
            if(strcmp('A',ty{i}))
                CP=[CP;time,1,P_A_Bayes(i)];
            else
                CP=[CP;time,0,P_A_Bayes(i)];
            end
            
            
        end
        
        
        
    %for all the other intervals:
    else
        %adds a column of NaN
        [u,v]=size(CP);
        last_col=ones(u,1)*NaN;
        CP=[CP,last_col];
        
        %for the cluster still available at the given time interval adds
        %the probability in the last column in place of NaN; otherwise
        %leaves NaN
        for(i=1:length(Date))
            
            k = strfind(Date{i},'/');
            
            day=str2double(Date{i}(1:k(1)-1));
            month=str2double(Date{i}(k(1)+1:k(2)-1));
            year=str2double(Date{i}(k(2)+1:end));

            
            k = strfind(Time{i},':');
            
            hour=str2double(Time{i}(1:k(1)-1));
            minute=str2double(Time{i}(k(1)+1:k(2)-1));
            second=str2double(Time{i}(k(2)+1:end));

            
            time = datenum(year,month, day, hour, minute, second);


            
            p=find(CP(:,1)==time);
            CP(p,v+1)=P_A_Bayes(i);

        end
    end
end


        
%plots the classification in time for all the elements of the
%classification file. In red A clusters and in blue B ones. 
figure;
hold on;

n1=ceil(sqrt(u));
n2=ceil(u/n1);


for(i=1:u)        

    %if A clusters
    if(CP(i,2)==1)
        % plots in long dashed red line and circles the classification of
        % the A cluster for different time periods
        subplot(n1,n2,i)
        plot(td, CP(i,3:end),'r-o','Linewidth',1.5)
        xlim([0,td(end)]);
        ylim([0,1]);
        set(gca, 'fontweight', 'bold')
        if(floor((i-1)/n2)==(n1-1))
            xlabel('T [days]','fontweight', 'bold');
        end
        if(rem(i-1,n2)==0)
            ylabel('P(A)','fontweight', 'bold');
        end
        hold on;
        plot([0,td(end)],[0.5,0.5],'k--')

        hold on;
        
        % plots the date of clusters A wrongly classified as B for all time 
        % intervals
        v=find(~isnan(CP(i,3:end)));
        if(~isempty(v) & length(find(CP(i,v+2)<0.5))==length(v))
            fprintf('A always classified as B\n')
            fprintf('%s\n',datestr(CP(i,1)))
            set(gca,'Color','y');
        end

        hold on;
        
        



    %if B clusters
    else
        % plots continuous blue line the classification of the B
        % cluster for different time periods
        subplot(n1,n2,i)
        plot(td, CP(i,3:end),'b-o','Linewidth',1.5)
        xlim([0,td(end)]);
        ylim([0,1]);
        set(gca, 'fontweight', 'bold')
        if(floor((i-1)/n2)==(n1-1))
            xlabel('T [days]','fontweight', 'bold');
        end
        if(rem(i-1,n2)==0)
            ylabel('P(A)','fontweight', 'bold');
        end
        hold on;
        plot([0,td(end)],[0.5,0.5],'k--')

        hold on;
        
        % plots the date of clusters B wrongly classified as A for all time 
        % intervals
        v=find(~isnan(CP(i,3:end)));
        if(~isempty(v) & length(find(CP(i,v+2)>=0.5))==length(v))
            fprintf('B always classified as A\n')
            fprintf('%s\n',datestr(CP(i,1)))
            set(gca,'Color','y');
        end

        hold on;
        
    end
end
hold on
print(gcf,'../data/Testing_Output/Figures/TestingPerformance.png','-dpng','-r100')

