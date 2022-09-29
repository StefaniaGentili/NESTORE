function [fout] = multiwaitbar_nrt(NumAxes,StepAxes,TitleAxes, handle)
% MULTIWAITBAR displays multiple waitbars.
%   H = MULTIWAITBAR(NumAxes,StepAxes,TitleAxes)
%   creates and displays a waitbars of fractional lengths StepAxes.  The
%   handle to the multiwaitbar figure is returned in H.
%   StepAxes should be an array, length equal to number of axeses, between
%   0 and 1. TitleAxes should be a cell array,length equal to number of
%   axeses, Containing messeges as the title of axeses.
%
%   H = MULTIWAITBAR(NumAxes,StepAxes,TitleAxes) will set the length of 
%   the bars in the most recently created waitbars window to the fractional
%   length StepAxes values.
%
%
%   MULTIWAITBAR(NumAxes,StepAxes,TitleAxes,H) will update the messeges text in
%   the multiwaitbar figure, in addition to setting the fractional
%   length to StepAxeses.
%
%   MULTIWAITBAR is typically used inside nested FOR loops that performs a
%   lengthy computation.  
%
%   use delete and clear as stated below to clear the object of
%   multiwaitbar figure
%   delete(H.figure)
%   clear('H')
%
%   Example:
%   H = multiwaitbar(3,[0 0 0 0],{'Please wait','Please wait','Please wait'});
%   for i = 0:0.2:1
%     for j = 0:0.2:1
%        for k = 0:0.1:1
%          multiwaitbar(3,[i j k],{'Computing','Computing','Computing'},H);
%        end
%     end
%   end
%   delete(H.figure)
%   clear('H')
% 
% Copyright (c) 2013, Sandeep Solanki
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

% Modified by S. Gentili and Piero Brondi for NESTORE software. 
% Last change
% August 17, 2022


% check Inputs
if ~iscell(TitleAxes)
    error('Titles should be in a Cell array')
end
SS = size(StepAxes,2);
ST = size(TitleAxes,2);
if ~isequal(SS,ST) && ~isequal(NumAxes,ST) && ~isequal(SS,NumAxes)
    error('Invalid Input Arguments');
end
if nargin < 4
    
    set(0, 'Units', 'pixel');
    screenSize = get(0,'ScreenSize');
    pointsPerPixel = 72/get(0,'ScreenPixelsPerInch');
    width = 360 * pointsPerPixel;
    height = NumAxes * 75 * pointsPerPixel;
    pos = [screenSize(3)/2-width/2 screenSize(4)/2-height/2 width height];
    handle.figure = figure('Position',pos,...
        'Numbertitle','off',...
        'Name','P(A)',...
        'Resize','off');
    axeswidth = 172;
    axesheight = 172/14;
    for i = 1:NumAxes
        R = max(0,min(100*StepAxes(i),100));
        X = 15;
        Y = 15+((NumAxes-i)*(pos(4)/(1.4*NumAxes)));
        axPos = [X Y axeswidth axesheight];
        handle.Axeshandle(i).list = axes('Parent',handle.figure, ...
            'Box','on', ...
            'Units','Points',...
            'Position',axPos);
        if isnan(StepAxes(i))
            fill([0 R R 0],[0 0 1 1],[0.95 0.95 0.95]);
            hold on
            t = text(R/2-15,0.5,'Not Available');
            s = t.FontSize;
            t.FontSize = 9;
        else
            if(StepAxes(i)<0.5)
               fill([0 R R 0],[0 0 1 1],'b');
            else
               fill([0 R R 0],[0 0 1 1],'r');
            end
        end
        set(handle.Axeshandle(i).list,'XLim',[0 100],...
            'YLim',[0 1],...
            'XTick',[],...
            'YTick',[]);
        titlehand = get(handle.Axeshandle(i).list,'title');
        set(titlehand,'string',TitleAxes(i));
        drawnow
        
    end
    if nargout > 0
        fout = handle;
    end
else
    for i = 1:NumAxes
        R = max(0,min(100*StepAxes(i),100));
        axes(handle.Axeshandle(i).list)
        fill([0 R R 0],[0 0 1 1],'r');
        set(handle.Axeshandle(i).list,'XLim',[0 100],...
            'YLim',[0 1],...
            'XTick',[],...
            'YTick',[]);
        titlehand = get(handle.Axeshandle(i).list,'title');
        set(titlehand,'string',TitleAxes(i));
        drawnow
    end
end
