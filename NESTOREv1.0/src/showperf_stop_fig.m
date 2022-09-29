function showperf_stop_fig(est_file,FEA, string_est, v,td, COL, MK, MS, hide,res_file2)

% Reads the performance file of each estimator and, taking into account the 
% good interval, creates a figure. 

% Input:
% est_file  = performance file of the estimator (e.g. recall, accuracy etc)
% string_est = estimator name [characters])
% v         = good interval vector
% FEA       = considered features names
% td        = time intervals (number [days])
% COL       = color of the lines
% MK        = symbols of the markers
% MS        = markers size
% hide      = hiding mask (1=yes, 0=no)

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

A2=load(est_file);
I=1:length(v)/2-1;
p1=I*2+1;
p2=[p1(1:8),p1(11)];





LEG={'const fea'};
j=1;

figure;
plot(td,A2(:,1),'r','LineWidth',3) %constant feature

for(i=1:length(p2))
    if(~isnan(v(p2(i)))& ~isnan(v(p2(i)+1)))
        hold on; errorbar(td(v(p2(i)):v(p2(i)+1)),A2(v(p2(i)):v(p2(i)+1),p2(i)+2),A2(v(p2(i)):v(p2(i)+1),p2(i)+3),'Color',COL(i,:),'LineWidth',2,'Marker',MK(i),'MarkerSize',MS(i))
        j=j+1;
        LEG{j}=FEA{i};
    end
end


xlabel('T [days]')
ylabel(string_est);

p=ylim;
xmax=td(end);

if(hide==1)
    
    blue_str='Excluded Values';
    LEG=[LEG blue_str];
    
    hold on
    if strcmp(string_est,'Informedness')==1
        axis([0.25,xmax,-1,1]);
        pgon=polyshape([td(1) td(1) td(end) td(end)],[0 -1 -1 0]);
    elseif strcmp(string_est,'Precision')==1
        axis([0.25,xmax,0,1]);
        pgon=polyshape([td(1) td(1) td(end) td(end)],[0.5 0 0 0.5]);
    elseif strcmp(string_est,'Recall')==1
        axis([0.25,xmax,0,1]);
        pgon=polyshape([td(1) td(1) td(end) td(end)],[0.5 0 0 0.5]);
    elseif strcmp(string_est,'Accuracy')==1
        axis([0.25,xmax,0,1]);
        pgon=polyshape([td(1) td(end)  td(end:-1:1)],[ 0 0 A2(end:-1:1,1)'],'simplify', false);
    end
    plot(pgon)
    
else
    axis([0,xmax,p(1),p(2)]);
end


legend(LEG,'Location', 'southeast')

string_perf=strcat('../data/Training_Output/Figures/Performance_',res_file2,'_',string_est,'.png'); 
print(gcf,string_perf,'-dpng','-r100')




