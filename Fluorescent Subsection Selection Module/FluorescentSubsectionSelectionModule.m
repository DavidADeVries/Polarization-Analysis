function varargout = FluorescentSubsectionSelectionModule(varargin)
% FLUORESCENTSUBSECTIONSELECTIONMODULE MATLAB code for FluorescentSubsectionSelectionModule.fig
%      FLUORESCENTSUBSECTIONSELECTIONMODULE, by itself, creates a new FLUORESCENTSUBSECTIONSELECTIONMODULE or raises the existing
%      singleton*.
%
%      H = FLUORESCENTSUBSECTIONSELECTIONMODULE returns the handle to a new FLUORESCENTSUBSECTIONSELECTIONMODULE or the handle to
%      the existing singleton*.
%
%      FLUORESCENTSUBSECTIONSELECTIONMODULE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLUORESCENTSUBSECTIONSELECTIONMODULE.M with the given input arguments.
%
%      FLUORESCENTSUBSECTIONSELECTIONMODULE('Property','Value',...) creates a new FLUORESCENTSUBSECTIONSELECTIONMODULE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FluorescentSubsectionSelectionModule_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FluorescentSubsectionSelectionModule_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FluorescentSubsectionSelectionModule

% Last Modified by GUIDE v2.5 30-May-2016 12:28:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FluorescentSubsectionSelectionModule_OpeningFcn, ...
                   'gui_OutputFcn',  @FluorescentSubsectionSelectionModule_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FluorescentSubsectionSelectionModule is made visible.
function FluorescentSubsectionSelectionModule_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FluorescentSubsectionSelectionModule (see VARARGIN)

% ********************************************
% INPUT: (polarimetryImages, fluorsecentImage)
% ********************************************

handles.polarimetryImages = varargin{1};
handles.fluorescentImage = varargin{2};

handles.xShift = 0;
handles.yShift = 0;
handles.rotAngle = 0;

handles.polarimetryImageIndex = 1;
handles.displayFluorescentImage = false;

handles.shiftDelta = 0.5;
handles.rotationDelta = 0.1;

handles.cancel = false;

updateImageAxes(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FluorescentSubsectionSelectionModule wait for user response (see UIRESUME)
% uiwait(handles.FluorescentSubsectionSelectionModule);


% --- Outputs from this function are returned to the command line.
function varargout = FluorescentSubsectionSelectionModule_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.transformParameters;


% --- Executes on selection change in polarimetryImageSelect.
function polarimetryImageSelect_Callback(hObject, eventdata, handles)
% hObject    handle to polarimetryImageSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns polarimetryImageSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from polarimetryImageSelect

handles.polarimetryImageIndex = get(hObject,'Value');

updateImageAxes(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function polarimetryImageSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polarimetryImageSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.FluorescentSubsectionSelectionModule);

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exit = questdlg('Are you sure you want to quit?','Quit','Yes','No','No'); 
switch exit
    case 'Yes'
        %Clears variables in the case that they wish to exit the program
        handles.cancel = true;
        
        guidata(hObject, handles);
        uiresume(handles.FluorescentSubsectionSelectionModule);
    case 'No'
end


% --- Executes on key press with focus on FluorescentSubsectionSelectionModule or any of its controls.
function FluorescentSubsectionSelectionModule_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to FluorescentSubsectionSelectionModule (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = eventdata.Key;

switch key
    case 'leftarrow'
        handles.xShift = handles.xShift - handles.shiftDelta;        
    case 'rightarrow'
        handles.xShift = handles.xShfit + handles.shiftDelta;
    case 'uparrow'
        handles.yShift = handles.yShift - handles.shiftDelta;
    case 'downarrow'
        handles.yShift = handles.yShift + handles.shiftDelta;
    case 'period' %that is, '>'
        handles.rotAngle = handles.rotAngle + handles.rotationDelta;
    case 'comma' %that is, '<'
        handles.rotAngle = handles.rotAngle - handles.rotationDelta;
    case 'space'
        handles.displayFluorescentImage = ~handles.displayFluorescentImage;
    otherwise
        disp(key)
end

updateImageAxes(handles)

guidata(hObject, handles);
    



function shiftInput_Callback(hObject, eventdata, handles)
% hObject    handle to shiftInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shiftInput as text
%        str2double(get(hObject,'String')) returns contents of shiftInput as a double

handles.shiftDelta = str2double(get(hObject,'String'));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function shiftInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shiftInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotateInput_Callback(hObject, eventdata, handles)
% hObject    handle to rotateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotateInput as text
%        str2double(get(hObject,'String')) returns contents of rotateInput as a double

handles.rotationDelta = str2double(get(hObject,'String'));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rotateInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when user attempts to close FluorescentSubsectionSelectionModule.
function FluorescentSubsectionSelectionModule_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to FluorescentSubsectionSelectionModule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

handles.cancel = true;
guidata(hObject, handles);

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end



% *** HELPER FUNCTIONS ***


function updateImageAxes(handles)

if handles.displayFluorescentImage
    image = handles.fluorescentImage;
else
    image = handles.polarimetryImages{handles.polarimetryImageIndex};
end

imshow(image, [0,1], 'Parent', handles.imageAxes);




