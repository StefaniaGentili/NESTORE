function nrt_maps(mCatMain,mCatAfter,td)
% Plots the magnitude time distribution of cluster's aftershocks and the 
% map of the aftershock distribution 

% INPUT:
%
% mCatMain   = Mainshock catalogue
% mCatAfter  = Aftershocks catalogue
% td         = time intervals (number [days])
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


% S. Gentili, sgentili@inogs.it 
% P. Brondi pbrondi@inogs.it
% License: GNUGPLv3
% last change September 21, 2022



fprintf('\n\nThis is nrt_maps\n\n');

dt1=td(end);


% t_start = mainshock time; t_end = time after the mainshock selected by the
% user (dt1)
t_start=datetime(fix(mCatMain(1,3)),mCatMain(1,4),mCatMain(1,5),mCatMain(1,8),mCatMain(1,9),mCatMain(1,10));
t_end=t_start+days(dt1);

Id_time=find(datetime(fix(mCatAfter(:,3)),mCatAfter(:,4),mCatAfter(:,5),mCatAfter(:,8),mCatAfter(:,9),mCatAfter(:,10))>t_start & datetime(fix(mCatAfter(:,3)),mCatAfter(:,4),mCatAfter(:,5),mCatAfter(:,8),mCatAfter(:,9),mCatAfter(:,10))<t_end);

time1_main=datetime(fix(mCatMain(1,3)),mCatMain(1,4),mCatMain(1,5),mCatMain(1,8),mCatMain(1,9),mCatMain(1,10));
time1_aft=datetime(fix(mCatAfter(Id_time,3)),mCatAfter(Id_time,4),mCatAfter(Id_time,5),mCatAfter(Id_time,8),mCatAfter(Id_time,9),mCatAfter(Id_time,10));

% Plots the Magnitude-Time Distribution
figure;
set(gca,'visible','off');
orient tall
rect = [0.15, 0.15, 0.75, 0.65];
axes('position',rect)


%stem(mCatMain(1,3),mCatMain(1,6),'color',[0.5 0.5 0.5])
stem(time1_main,mCatMain(1,6),'color',[0.5 0.5 0.5]);
hold on;
% stem(mCatAfter(Id_time,3),mCatAfter(Id_time,6),'color',[0.5 0.5 0.5])
stem(time1_aft,mCatAfter(Id_time,6),'color',[0.5 0.5 0.5]);
xtickformat('MM-dd-yy');




xlabel('T [Years ]','FontWeight','bold','FontSize',13)
ylabel('Magnitude','FontWeight','bold','FontSize',13)


set(gca,'box','on',...
        'SortMethod','childorder','TickDir','out','FontWeight',...
        'bold','FontSize',13,'Linewidth',[1.2])

grid
print(gcf,'../data/Nrt_Output/Figures/Mag-Time_Distribution.png','-dpng','-r100')


% Plots the map of seismicity for the cluster
figure;


set(gca,'visible','off');
orient tall
rect = [0.15, 0.15, 0.75, 0.65];
axes('position',rect)


LatMm=mCatMain(:,2);
LonMm=mCatMain(:,1);

LatMa=mCatAfter(Id_time,2);
LonMa=mCatAfter(Id_time,1);

deltaLat=max(abs(diff(LatMm-LatMa)))+0.1;
deltaLon=max(abs(diff(LonMm-LonMa)))+0.1;
plot(LonMa,LatMa,'o','MarkerFaceColor',[0.5 0.5 0.5],'Markersize',7)
hold on
% sz=15;
% c=linspace(0,1,length(LonMa));

plot(LonMm,LatMm,'p','MarkerFaceColor','red','Markersize',18)
xlabel('Longitude','FontWeight','bold','FontSize',13)
ylabel('Latitude','FontWeight','bold','FontSize',13)
xlim([LonMm-deltaLon,LonMm+deltaLon]);
ylim([LatMm-deltaLat,LatMm+deltaLat]);
legend('Aftershocks','Mainshock','Orientation','vertical')
grid on
print(gcf,'../data/Nrt_Output/Figures/ClusterMap.png','-dpng','-r100');








