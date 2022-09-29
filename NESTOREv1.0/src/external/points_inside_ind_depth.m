function [selec,ind3]=points_inside_ind_depth(a,x,y,z)
% This function is extracted and modified from Zmap pickpo.m function.
% Given a set of coordinates and depths (a) and polygon having coordinates 
% (x,y), it selects the points inside the polygon and above the depth z.
% In this modified version, this function provides the indexes of the 
% selected points inside the polygon and above the depth z.
% PLEASE NOTE: The last point of the polygon has to coincide with the first one. 


% Input:
% a = vector of point coordinates (Lon,Lat,Depth)
% x = Longitude of polygon vertexes 
% y = Latitude of polygon vertexes
% z = maximum depth

% Output:
% selec = selected point of a inside the polygon (Lon,Lat) and above the
%         depth z (depth<z)
% ind3 = indexes of vector a correspondent to selec 


% EXAMPLE:
% a=rand(30,3)
% figure;
% plot3(a(:,1),a(:,2),a(:,3),'LineStyle','none','Marker','.') 
% hold on;
% x=[0.2,0.6,0.5,0.1,0.2] 
% y=[0.2,0.3,0.6,0.7,0.2] 
% z = 0.5; 
% z1=x*0+z; 
% hold on; plot3(x,y,z1,'k') 
% [selec,ind3]=points_inside_ind_depth(a,x,y,z) 
% hold on;
% plot3(selec(:,1),selec(:,2),selec(:,3),'LineStyle','none','Marker','<','MarkerEdgeColor','m')
% 
% hold on;
% plot3(a(ind3,1),a(ind3,2),a(ind3,3),'LineStyle','none','Marker','o','MarkerEdgeColor','r', 'MarkerSize',11)
% 
% figure; plot(selec(:,1),selec(:,2),'LineStyle','none','Marker','.','MarkerEdgeColor','r')
% hold on; plot(x,y,'k')



% last change 11/2/2021 by Stefania Gentili sgentili@inogs.it
% English comments and variable naming by P. Brondi pbrondi@inogs.it

XI = a(:,1);          % this substitution just to make equation below simple
YI = a(:,2);
ZI = a(:,3);
m = length(x)-1;      %  number of coordinates of polygon
l = 1:length(XI);
l = (l*0)';
ll = l;               %  Algorithm to select points inside a closed
%  polygon based on Analytic Geometry    R.Z. 4/94
for i = 1:m
    % To avoid the division by zero if y(i)==y(i+1)
    if(y(i+1)==y(i))
        y(i+1)=y(i+1)+10^(-13);
    end

    l= ((y(i)-YI < 0) & (y(i+1)-YI >= 0)) & ...
        (XI-x(i)-(YI-y(i))*(x(i+1)-x(i))/(y(i+1)-y(i)) < 0) | ...
        ((y(i)-YI >= 0) & (y(i+1)-YI < 0)) & ...
        (XI-x(i)-(YI-y(i))*(x(i+1)-x(i))/(y(i+1)-y(i)) < 0);


    if i ~= 1
        ll(l) = 1 - ll(l);
    else
        ll = l;
    end         % if i

end         %  for

            

ind=find(ll);

ind2=find(ZI(ind)<z);
ind3=ind(ind2);

selec=a(ind3,:);



