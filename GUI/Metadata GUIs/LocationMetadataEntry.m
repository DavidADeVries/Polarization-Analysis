function varargout = LocationMetadataEntry(varargin)
%LOCATIONMETADATAENTRY M-file for LocationMetadataEntry.fig
%      LOCATIONMETADATAENTRY, by itself, creates a new LOCATIONMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = LOCATIONMETADATAENTRY returns the handle to a new LOCATIONMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      LOCATIONMETADATAENTRY('Property','Value',...) creates a new LOCATIONMETADATAENTRY using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to LocationMetadataEntry_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LOCATIONMETADATAENTRY('CALLBACK') and LOCATIONMETADATAENTRY('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LOCATIONMETADATAENTRY.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LocationMetadataEntry

% Last Modified by GUIDE v2.5 08-Feb-2016 15:43:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LocationMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @LocationMetadataEntry_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end
% End initialization code - DO NOT EDIT

%Created By: Frank Corapi
%January 18th, 2016
%This program will allow the user to select a point, and/or quarter of the
%retina of the left or right eye, with or without a fovea. The GUI will
%then return the values for the x and y coordinates oi the selected point
%as well as the name of the quarter or the retina.

% --- Executes just before LocationMetadataEntry is made visible.
function LocationMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

%Comments about varargin
%The first varargin value determines whether the left or right eye will be displayed; should be either 'R' or 'L'
%The second varargin value determines whether or not the fovea will be plotted; should be either true or false


% *******************************************************************************************************************
% INPUT: (eyeType, subjectType, quarterType, suggestedLocationNumber, existingLocationNumbers, importPath, location*)
%        *may be empty
% *******************************************************************************************************************

%Variable inputs from program calling this GUI
handles.eyeType = varargin{1}; %Input param is 'eyeType', determines whether the left or right eye will be displayed
handles.subjectType = varargin{2}; %Input parameter is 'subjectType', and determines whether or not the fovea will be plotted
handles.selectedQuarter = varargin{3}; %Input parameter is 'quarterType'

if isa(varargin{4},'numeric');
    handles.suggestedLocationNumber = num2str(varargin{4}); %Parameter name is 'suggestedLocationNumber' from Quarter class function
else
    handles.suggestedLocationNumber = '';
end

handles.existingLocationNumbers = varargin{5};

handles.importPath = varargin{6}; %Input parameter is 'importPath'


handles.cancel = false;

%Chooses right eye to map if selected eye is unknown
if handles.eyeType == EyeTypes.Unknown
    handles.eyeType = Constants.DEFAULT_EYE_TYPE;
end

%Subject type check
if handles.subjectType == SubjectTypes.Dog
    handles.plotFovea = false;
elseif handles.subjectType == SubjectTypes.Human
    handles.plotFovea = true;
end

%Shading out the appropriate areas on the retina based on selected quarter
if handles.selectedQuarter == QuarterTypes.Superior
    retinaShade(0,0,1,5*pi/4, 7*pi/4);
    retinaShade(0,0,1,-pi/4, pi/4);
    retinaShade(0,0,1,3*pi/4, 5*pi/4);
    hold on;
elseif handles.selectedQuarter == QuarterTypes.Inferior
    retinaShade(0,0,1,pi/4, 3*pi/4);
    retinaShade(0,0,1,3*pi/4, 5*pi/4);
    retinaShade(0,0,1,-pi/4, pi/4);
    hold on;
elseif handles.selectedQuarter == QuarterTypes.Temporal
    if handles.eyeType == EyeTypes.Right
        retinaShade(0,0,1,pi/4, 3*pi/4);
        retinaShade(0,0,1,-pi/4, pi/4);
        retinaShade(0,0,1,5*pi/4, 7*pi/4);
        hold on;
    elseif handles.eyeType == EyeTypes.Left
        retinaShade(0,0,1,pi/4, 3*pi/4);
        retinaShade(0,0,1,3*pi/4, 5*pi/4);
        retinaShade(0,0,1,5*pi/4, 7*pi/4);
        hold on;
    end
elseif handles.selectedQuarter == QuarterTypes.Nasal
    if handles.eyeType == EyeTypes.Right
        retinaShade(0,0,1,pi/4, 3*pi/4);
        retinaShade(0,0,1,3*pi/4, 5*pi/4);
        retinaShade(0,0,1,5*pi/4, 7*pi/4)
        hold on;
    elseif handles.eyeType == EyeTypes.Left
        retinaShade(0,0,1,pi/4, 3*pi/4);
        retinaShade(0,0,1,-pi/4, pi/4);
        retinaShade(0,0,1,5*pi/4, 7*pi/4);
        hold on;
    end
end

%Plot retina and quarter divisions

xRetina = 0; %x value for the center of retina
yRetina = 0; %y value for the center of retina
rRetina = 1; %radius of retina

circle(xRetina,yRetina,rRetina); 
hold on
x1 = [-1,0,1];
y1 = abs(x1);

plot(x1, y1);

y2 = -abs(x1);

plot(x1, y2);


%Checking whether or not the eye is right or left, and whether or not there
%is a fovea
if handles.eyeType == EyeTypes.Right && handles.plotFovea
%Plot fovea for right eye
    foveaX = -0.2;
    foveaY = 0;
    foveaRadius = 0.025;

    circle(foveaX, foveaY, foveaRadius);
    
    set(handles.MapTitle,'String','Right Eye with Fovea');
elseif handles.eyeType == EyeTypes.Left && handles.plotFovea
    %Plot fovea for left eye
    foveaX = 0.2;
    foveaY = 0;
    foveaRadius = 0.025;

    circle(foveaX, foveaY, foveaRadius);
    
    set(handles.MapTitle,'String','Left Eye with Fovea');
    
    %Switching the location of the nasal and temporal quarters buttons
    buttonSwitch(handles);
elseif handles.eyeType == EyeTypes.Right && handles.plotFovea == false
    set(handles.MapTitle,'String','Right Eye without Fovea');
elseif handles.eyeType == EyeTypes.Left && handles.plotFovea == false
    %Switching the location of the nasal and temporal quarters
    buttonSwitch(handles);
    
    set(handles.MapTitle,'String','Left Eye without Fovea');
end

%Remove axes from retina diagram
set(gca,'xtick',[],'ytick',[]);

[choices, quarterChoiceStrings] = choicesFromEnum('QuarterTypes');

for i = (1:size(quarterChoiceStrings))
    if handles.selectedQuarter == choices(i)
        handles.selectedQuarterDisplay = quarterChoiceStrings(i); %creates the appropriate quarter type string
    end
end

%Defining Marker Parameters
handles.MarkerStyle = 'x';
handles.MarkerSize = 10;
handles.MarkerEdgeColor = 'b';
handles.MarkerFaceColor = 'b';

set(handles.DisplayQuarter,'String',handles.selectedQuarterDisplay);

if length(varargin) > 6
    location = varargin{7};
    
    if isempty(location.locationCoords)
        handles.xCoords = [];
        handles.yCoords = [];
        handles.coordsUnknown = true;
        
        set(handles.DisplayPoint,'String','Unknown');
        
        handles.marker = plot(handles.xCoords, handles.yCoords, handles.MarkerStyle, 'MarkerSize', handles.MarkerSize, 'MarkerEdgeColor', handles.MarkerEdgeColor, 'MarkerFaceColor', handles.MarkerFaceColor, 'Visible', 'off');
    else
        handles.xCoords = location.locationCoords(1);
        handles.yCoords = location.locationCoords(2);
        handles.coordsUnknown = false;
        
        pointDisplay = ['x: ',  num2str(handles.xCoords),  ' y: ',  num2str(handles.yCoords)];
        set(handles.DisplayPoint,'String',pointDisplay);
        
        %Plots a marker at the point selected
        handles.marker = plot(handles.xCoords, handles.yCoords, handles.MarkerStyle, 'MarkerSize', handles.MarkerSize, 'MarkerEdgeColor', handles.MarkerEdgeColor, 'MarkerFaceColor', handles.MarkerFaceColor); 
    end
    
    handles.locationNumber = location.locationNumber;
    handles.deposit = location.deposit;
    handles.locationNotes = location.notes;
    
    set(handles.DisplayQuarter,'String',handles.selectedQuarterDisplay);
    set(handles.importPathDisplay, 'String', 'None');
    set(handles.locationNumberInput, 'String', num2str(handles.locationNumber));
    set(handles.locationNotesInput, 'String', handles.locationNotes);
    
    if handles.deposit
        set(handles.depositFieldButton, 'Value', 1);
        set(handles.controlFieldButton, 'Value', 0);
    else
        set(handles.depositFieldButton, 'Value', 0);
        set(handles.controlFieldButton, 'Value', 1);        
    end
    
    set(handles.OK,'enable','on');
else
    %Defining the coordinate variables, and other input variables
    handles.xCoords = [];
    handles.yCoords = [];
    handles.locationNumber = str2double(handles.suggestedLocationNumber);
    handles.deposit = 1;
    handles.locationNotes = '';
    handles.coordsUnknown = false;
    handles.marker = plot(handles.xCoords, handles.yCoords, handles.MarkerStyle, 'MarkerSize', handles.MarkerSize, 'MarkerEdgeColor', handles.MarkerEdgeColor, 'MarkerFaceColor', handles.MarkerFaceColor, 'Visible', 'off');
    
    %Assigning default display values
    set(handles.importPathDisplay, 'String', handles.importPath);
    set(handles.locationNumberInput, 'String', handles.suggestedLocationNumber);
    set(handles.depositFieldButton, 'Value', 1);
    
    %Disable buttons until needed
    set(handles.OK,'enable','off');
end



guidata(hObject, handles);

%Await user input
uiwait(handles.LocationMetadataEntry);

end


% --- Outputs from this function are returned to the command line.
function varargout = LocationMetadataEntry_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ********************************************************
% OUTPUT: [cancel, coords, locationNumber, deposit, notes]
% ********************************************************

% Get default command line output from handles structure
varargout{1} = handles.cancel;
varargout{2} = [handles.xCoords, handles.yCoords];
varargout{3} = handles.locationNumber;
varargout{4} = handles.deposit;
varargout{5} = handles.locationNotes;
close(handles.LocationMetadataEntry);
end



% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
uiresume(handles.LocationMetadataEntry);
end





% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Dialog box asking the user whether or not they wish to exit the program
exit = questdlg('Are you sure you want to quit?','Quit','Yes','No','No'); % TODO just cancel or is this just fine?
switch exit
    case 'Yes'
        %Clears variables in the case that they wish to exit the program
        handles.cancel = true;
        handles.xCoords = [];
        handles.yCoords = [];
        handles.locationNumber = [];
        handles.deposit = [];
        handles.locationNotes = '';
        guidata(hObject, handles);
        uiresume(handles.LocationMetadataEntry);
    case 'No'
end
end

% --- Executes on button press in Point.
function Point_Callback(hObject, eventdata, handles)
% hObject    handle to Point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.coordsUnknown = false;

%Preventing the use of other buttons while selecting a point
set(handles.Unknown,'enable','off');
set(handles.OK,'enable','off');
set(handles.Cancel,'enable','off');
set(handles.Point,'enable','off');
set(handles.locationNumberInput, 'enable', 'off');
set(handles.depositFieldButton, 'enable', 'off');
set(handles.controlFieldButton, 'enable', 'off');
set(handles.locationNotesInput, 'enable', 'off');

%Clears marked point
if ishandle(handles.marker)
    delete(handles.marker);
end
axes(handles.retinalmap);
[handles.xCoords,handles.yCoords] = ginput(1);


%Makes sure that the user is selecting a point that doesn't conflict with
%the selected quarter.
if handles.selectedQuarter == QuarterTypes.Superior
    while handles.yCoords < abs(handles.xCoords) || sqrt((handles.xCoords)^2 + (handles.yCoords)^2) > 1
        waitfor(warndlg('Selected point conflicts with selected quarter type.','Invalid Point Selection'));
        [handles.xCoords,handles.yCoords] = ginput(1);
    end
elseif handles.selectedQuarter == QuarterTypes.Inferior
    while handles.yCoords > -abs(handles.xCoords) || sqrt((handles.xCoords)^2 + (handles.yCoords)^2) > 1
        waitfor(warndlg('Selected point conflicts with selected quarter type.','Invalid Point Selection'));
        [handles.xCoords,handles.yCoords] = ginput(1);
    end
elseif handles.selectedQuarter == QuarterTypes.Temporal
    if handles.eyeType == EyeTypes.Right
         while handles.yCoords < handles.xCoords || handles.yCoords > -handles.xCoords || sqrt((handles.xCoords)^2 + (handles.yCoords)^2) > 1
               waitfor(warndlg('Selected point conflicts with selected quarter type.','Invalid Point Selection'));
               [handles.xCoords,handles.yCoords] = ginput(1);
         end
    elseif handles.eyeType == EyeTypes.Left
        while handles.yCoords > handles.xCoords || handles.yCoords < -handles.xCoords || sqrt((handles.xCoords)^2 + (handles.yCoords)^2) > 1
               waitfor(warndlg('Selected point conflicts with selected quarter type.','Invalid Point Selection'));
               [handles.xCoords,handles.yCoords] = ginput(1);
         end
    end
elseif handles.selectedQuarter == QuarterTypes.Nasal
    if handles.eyeType == EyeTypes.Right
         while handles.yCoords > handles.xCoords || handles.yCoords < -handles.xCoords || sqrt((handles.xCoords)^2 + (handles.yCoords)^2) > 1
               waitfor(warndlg('Selected point conflicts with selected quarter type.','Invalid Point Selection'));
               [handles.xCoords,handles.yCoords] = ginput(1);
         end
    elseif handles.eyeType == EyeTypes.Left
        while handles.yCoords < handles.xCoords || handles.yCoords > -handles.xCoords || sqrt((handles.xCoords)^2 + (handles.yCoords)^2) > 1
               waitfor(warndlg('Selected point conflicts with selected quarter type.','Invalid Point Selection'));
               [handles.xCoords,handles.yCoords] = ginput(1);
         end
    end
elseif handles.selectedQuarter == QuarterTypes.Unknown
    while sqrt((handles.xCoords)^2 + (handles.yCoords)^2) > 1
        waitfor(warndlg('Selected point conflicts with selected quarter type.','Invalid Point Selection'));
        [handles.xCoords,handles.yCoords] = ginput(1);
    end
end

%Plots a marker at the point selected
handles.marker = plot(handles.xCoords, handles.yCoords, handles.MarkerStyle, 'MarkerSize', handles.MarkerSize, 'MarkerEdgeColor', handles.MarkerEdgeColor, 'MarkerFaceColor', handles.MarkerFaceColor); 


%Display the point coordinates
pointDisplay = ['x: ',  num2str(handles.xCoords),  ' y: ',  num2str(handles.yCoords)];
set(handles.DisplayPoint,'String',pointDisplay);

%Enable the other buttons

set(handles.Unknown,'enable','on');
set(handles.Cancel,'enable','on');
set(handles.Point,'enable','on');
set(handles.locationNumberInput, 'enable', 'on');
set(handles.depositFieldButton, 'enable', 'on');
set(handles.controlFieldButton, 'enable', 'on');
set(handles.locationNotesInput, 'enable', 'on');

checkToEnableOkButton(handles)

guidata(hObject, handles);
end

% --- Executes on button press in Unknown.
function Unknown_Callback(hObject, eventdata, handles)
% hObject    handle to Unknown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Enabling the ok button and clearing the selected point and quarter
handles.xCoords = [];
handles.yCoords = [];
handles.coordsUnknown = true;
set(handles.DisplayPoint,'String','Unknown');


%Clearing the marker
if ishandle(handles.marker)
    delete(handles.marker);
end

checkToEnableOkButton(handles)

guidata(hObject, handles);
end

% --- Executes when user attempts to close LocationMetadataEntry.
function LocationMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to LocationMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    handles.cancel = true;
    handles.xCoords = [];
    handles.yCoords = [];
    handles.locationNumber = [];
    handles.deposit = [];
    handles.locationNotes = '';
    guidata(hObject, handles);
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    handles.cancel = true;
    handles.xCoords = [];
    handles.yCoords = [];
    handles.locationNumber = [];
    handles.deposit = [];
    handles.locationNotes = '';
    guidata(hObject, handles);
    delete(hObject);
end
end

function locationNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to locationNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of locationNumberInput as text
%        str2double(get(hObject,'String')) returns contents of locationNumberInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.locationNumberInput, 'String', '');
    handles.locationNumber = [];
    
    warndlg('Location Number must be numerical.', 'Location Number Error', 'modal'); 
    
else
    handles.locationNumber = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function locationNumberInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to locationNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function importPathDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to importPathDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of importPathDisplay as text
%        str2double(get(hObject,'String')) returns contents of importPathDisplay as a double

set(handles.importPathDisplay, 'String', handles.importPath);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function importPathDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to importPathDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function locationNotesInput_Callback(hObject, eventdata, handles)
% hObject    handle to locationNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of locationNotesInput as text
%        str2double(get(hObject,'String')) returns contents of locationNotesInput as a double

%Get value from input box
handles.locationNotes = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function locationNotesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to locationNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

end

% --- Executes on button press in depositFieldButton.
function depositFieldButton_Callback(hObject, eventdata, handles)
% hObject    handle to depositFieldButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of depositFieldButton

set(handles.depositFieldButton, 'Value', 1);

handles.deposit = true;

set(handles.controlFieldButton, 'Value', 0);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in controlFieldButton.
function controlFieldButton_Callback(hObject, eventdata, handles)
% hObject    handle to controlFieldButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of controlFieldButton

set(handles.depositFieldButton, 'Value', 0);

handles.deposit = false;

set(handles.controlFieldButton, 'Value', 1);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end


%% Local Functions %%

function circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)

ang = 0:0.001:2*pi; %creates a list of angles, so that each x, y point on a circle is plotted as the angle goes from 0 to 2pi

xp = r*cos(ang);
yp = r*sin(ang);

plot(x+xp, y+yp);

end

function retinaShade(x,y,r, ang1,ang2)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
%This function shades out unwanted areas of the retina by graphing a series
%of grey arcs

for rs = 0:0.01:r;
     ang = ang1:0.001:ang2; %creates a list of angles, so that each x, y point on a circle is plotted as the angle goes from 0 to 2pi
     xp = rs*cos(ang);
     yp = rs*sin(ang);
     plot(x+xp, y+yp, 'color', [0.5 0.5 0.5]);
     hold on
end


end


function buttonSwitch(handles)
    posT = getpixelposition(handles.Temporal);
    posN = getpixelposition(handles.Nasal);
    setpixelposition(handles.Temporal,posN); 
    setpixelposition(handles.Nasal,posT);
end

function checkToEnableOkButton(handles)

%This function will check to see if any of the input variables are empty,
%and if not it will enable the OK button

if ~isempty(handles.locationNumber) && ~isempty(handles.deposit) && ((~isempty(handles.xCoords) && ~isempty(handles.yCoords)) || handles.coordsUnknown)
    set(handles.OK, 'enable', 'on');
else
    set(handles.OK, 'enable', 'off');
end

end
