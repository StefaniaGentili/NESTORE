function varargout = guidefunc(action, varargin)
% READ THIS FIRST PARAGRAPH BEFORE USING THIS FILE
% =========================================================================
% GUIDEFUNC() (this file) is a wrapper function to Matlab's guidefunc.m
% file of the same name which is called when a GUI is accessed from guide().
% In the r2019b release of Matlab annotationPane objects were added to
% certain GUI components and these objects cause an error when certain
% properties are changed in the guide editor. These errors prevent users
% from editing their GUIs from withing guide. To patch that error,
% annotationPane objects must be removed from the GUI figure prior to
% loading the GUI into guide.  Since the annotationPane objects are added
% back to the GUI when changes are saved, they must be removed each time
% guide() accesses the GUI figure.  This function detects and deletes the
% annotationPane objects when the GUI is opened by guide() which prevents
% the errors and allows the user to edit the GUI from guide.
%
% ** INSTRUCTIONS **
% 1) Save a backup of your GUI (.m and .fig files).
% 2) Save this function to your Matlab path and confirm that it precedes
%    Matlab's function by running:    which('guidefunc','-all')
% 3) Open your GUI as you normally would in guide(). To confirm you're
%    using this wrapper function, a warning should occasionally appear
%    in the command window.
%
% ** HOW TO REMOVE AnnotationPane OBJECTS WHEN OPENING YOUR GUI **
% As described above, the annotationPanes will always be added back to your
% fig file.  If the annotationPane objects are causing problems while running
% your GUI, add these lines to the end of your GUI's xxx_OpeningFcn() function.
%  >
%  >  if isfield(handles,'scribeOverlay') && isa(handles.scribeOverlay(1),'matlab.graphics.shape.internal.AnnotationPane')
%  >      delete(handles.scribeOverlay);
%  >      handles = rmfield(handles, 'scribeOverlay');
%  > end
%
% ** WHO SHOULD USE THIS? **
% Only use this if you have already experienced the error dialogs that
% appear when attempting to edit your GUI from within guide.  A description
% of this error can be found at the link below.  Your Matlab release must
% be r2019b or later since this is when the error first appeared. Otherwise,
% this function is bypassed and inputs are sent to the built-in version.  
%
% ** OTHER DETAILS **
% The first time this file is called during your Matlab session you will be
% asked to confirm to continue.  You will see an occasional warning message
% to remind you that you're using this override function. Every time a GUI
% is opening in guide, this function will store a backup of the GUI's .fig
% file in tempdir() directory.  The fig file name will be appended to include
% the current datetime (year,month,day,hour,minut,second).
%
% Please participate in the discussion here:
% https://www.mathworks.com/matlabcentral/answers/482510-annotationpane-handle-appearing-in-guide-guis-with-panel-axes-in-r2019b
%
% Please send any bugs, suggestions, feature requests or high-fives to
% the email address below.
% char([97 100 97 109 46 100 97 110 122 64 103 109 97 105 108 46 99 111 109])
% Adam Danz 11/18/19

%% Release notes
% vs 1.0 on 191119 - first upload to FEX.
% vs 1.1 on 191212 - Slight restructuring to bypass the custom function when matlab release <r2019b.

%% Warn user that they are using an override method.
% guide() calls guidefunc() many times when opening a GUI in guide.  To prevent many
% warnings, we'll only show it once per minute.
persistent confirmation guidefuncROOT warnTime bypass
if isempty(warnTime) || toc(warnTime)>60
    warnTime = tic();
    warning(['You are using a custom version of GUIDEFUNC.M. Read the help section '...
        'of that file if are not familiar with this override.'])
end

%% Set up first use per session
% On first use per session,
% 1) Check that an acceptable matlab release is being used
% 2) user must confirm permission to proceed
% 3) create the anonymous function handle to the built-in guidefunc().
if isempty(confirmation) || ~confirmation || ...
        isempty(guidefuncROOT) || ~isa(guidefuncROOT,'function_handle') || isempty(bypass)
    % Get matlab version and check that it is r2019b or later.
    vStrct = ver('Matlab');
    vs = str2double(vStrct.Version);
    if vs < 9.7 || isnan(vs)
        % Display help section, throw warning dialog and bypass this overshaddowed function.
        help(mfilename)
        warnMsg = sprintf(['You''re using a custom version of Matlab''s guidefunc() that patches '...
            'a problem that exists in Matlab 9.7 (r2019b) and possibly later releases.  However, '...
            'the current Matlab release in use is %s so this custom function will be bypassed and '...
            'Matlab''s guidefunc() will be used instead.  Consider removing this custom function '...
            'from your Matlab path if you continue to use a Matlab release prior to r2019b.'], vStrct.Version);
        opts.WindowStyle = 'modal';
        opts.Interpreter = 'tex';
        uiwait(msgbox(['\fontsize{12}',warnMsg], mfilename, 'warn', opts))
        bypass = true;
    else
        bypass = false;
    end
    
    % Display confirmation question box
    if bypass
        confirmation = true;
    else
        opts.Default = 'Quit & throw error';
        opts.Interpreter = 'tex';
        resp = questdlg(['\fontsize{12}You are using a custom override of Matlab''s built-in '...
            'guidefunc.m that will remove all annotation panes from your GUI prior to loading '...
            'the GUI into GUIDE.  The annotation panes will be added back when you save changes '...
            'in GUIDE. This override will also save a back-up of your GUI''s .fig file prior to '...
            'making any changes but it is recommended that you store back-ups of your GUI''s '...
            '.fig and .m files prior to proceeding.'], mfilename,...
            'Continue', 'Quit & throw error',opts);
        if isempty(resp) || strcmpi(resp,'Quit & throw error')
            confirmation = false;
            error('User terminated function.')
        else
            confirmation = true;
        end
    end
    
    % get function handle to built-in function
    allPaths = which('guidefunc', '-all'); % The should only be 2 paths!
    isRootPath = contains(allPaths, matlabroot);
    builtinPath = fileparts(allPaths{find(isRootPath,1,'first')});
    origCD = cd(builtinPath); %store original CD, then switch to root path temporarily
    guidefuncROOT = @guidefunc;
    cd(origCD); %switch back to original CD
end

if ~bypass
    %% Save a copy of the figure to temp-directory every time the action is 'readFigure'
    if nargin>0 && ~isempty(action) && ischar(action) && strcmpi(action,'readFigure')
        [~,figName,figExt] = fileparts(varargin{2});
        newFig = fullfile(tempdir,[figName,'_',datestr(now,'yyyymmddhhMMss'),figExt]);
        copyfile(varargin{2}, newFig)
        disp(['Backup of ',figName,figExt,' saved in ',...
            '<a href="matlab: winopen(tempdir) ">temporary directory</a>','.'])
    end
    
    %% Detect & remove annotation panes and send inputs to built-in guidefunc()
    if nargin > 1 ...
            && ~isempty(varargin) ...
            && iscell(varargin) ...
            && numel(varargin)>0 ...
            && iscell(varargin{1}) ...
            && numel(varargin{1})>0 ...
            && ishghandle(varargin{1}{1})
        
        % Search for annotation panes
        aph = findall(varargin{1}{1}, 'Type', 'AnnotationPane');
        
        % Delete them (they will be restored when you open the GUI again r2019b)
        if numel(aph) > 0
            fprintf('>>>>>> Annotation panes being deleted under action ''%s'' <<<<<<\n', action)
            delete(aph);
        end
    end
end

% Send inputs to built-in guidefunc()
varargout = cell(1,nargout());
[varargout{:}] = guidefuncROOT(action, varargin{:});

