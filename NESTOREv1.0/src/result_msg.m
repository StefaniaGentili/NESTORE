function result_msg(mCatMain, form_space, form_time, form_time2, Thwt, PC)
% Shows the results of the classification and the time and space for forecasting 

% INPUT:
%
% mCatMain    = Mainshock catalogue
% form_space  = equation for space window [km]
% form_time   = equation for time window [days]
% Thwt        = threshold on mainshock magnitude for possible different
%               time window
% form_time2  = equation for time window for Mm>=Thwt
% PC          = vector with the probability to be an A cluster for each
%               time period
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
% License: GNUGPLv3
% last change August 18, 2022

% Evaluates the space and time window for the analysis



fMagnitude=mCatMain(1,6);
R=ceil(eval(form_space));

if(fMagnitude<Thwt)
    D = ceil(eval(form_time));
else
    D = ceil(eval(form_time2));
end


% %% Piero 13/9/2022
% if(max(PC)<=0.4)
%    tf = imread('Green_Light3.png');
% elseif(min(PC)>0.6)
%    tf = imread('Red_Light3.png'); 
% else 
%    tf = imread('Yellow_Light3.png');  
% end
% 
% figure('Menubar','none','NumberTitle','off');
% imshow(tf)
% axis off;

% do = [ '[x,imap] = imread(str);']; err =  ''; 
% eval(do,err); 
% 
% if exist('x') == 1  
%     figure('Menubar','none','NumberTitle','off'); fi0 = gcf;
%     axes('pos',[0 0 1 1]); axis ij
%     image(x)
%     drawnow
%     pause(5)
%     close
% end

[icondata,iconcmap] = imread('NESTORE_logo.png');

if(max(PC)<=0.4)
    fprintf('NO strong aftershock with Ma>=%.1f is forecasted within R=%d km and D=%d days after the mainshock\n',fMagnitude-1,R,D);
    out_string1=sprintf('Forecasting: Ma<%.1f',fMagnitude-1);
    out_string2=sprintf('within R=%d km and D=%d days',R,D);    
    h = msgbox({out_string1;out_string2;'after the mainshock'},  "B class","custom", ...
        icondata,iconcmap);

    
%     object_handles = findall(h);
%     set( object_handles(6), 'FontSize', 10,'HorizontalAlignment', 'left', ...
%         'VerticalAlignment', 'bottom')    
    
    
elseif(min(PC)>0.6)

    fprintf('Strong aftershock with M_a>=%.1f is forecasted within R=%d km and D=%d days after the mainshock\n',fMagnitude-1,R,D);
    
    out_string1=sprintf('Forecasting: Ma>=%.1f',fMagnitude-1);
    out_string2=sprintf('within R=%d km and D=%d days',R,D);    
    h = msgbox({out_string1;out_string2;'after the mainshock'},  "A class","custom", ...
        icondata,iconcmap);

    
%      object_handles = findall(h);
%     set( object_handles(6), 'FontSize', 10,'HorizontalAlignment', 'left', ...
%         'VerticalAlignment', 'bottom')
    
else
    fprintf('Uncertain classification within R=%d km and D=%d days after the mainshock\n',fMagnitude-1,R,D);
    
    out_string1=sprintf('Uncertain classification',fMagnitude-1);
    out_string2=sprintf('within R=%d km and D=%d days',R,D);    
    h = msgbox({out_string1;out_string2;'after the mainshock'},  "Uncertain","custom", ...
        icondata,iconcmap);

    
%      object_handles = findall(h);
%     set( object_handles(6), 'FontSize', 10,'HorizontalAlignment', 'left', ...
%         'VerticalAlignment', 'bottom')
end
