function varargout = selectLegacyDataPaths(varargin)
% SELECTLEGACYDATAPATHS MATLAB code for selectLegacyDataPaths.fig
%      SELECTLEGACYDATAPATHS, by itself, creates a new SELECTLEGACYDATAPATHS or raises the existing
%      singleton*.
%
%      H = SELECTLEGACYDATAPATHS returns the handle to a new SELECTLEGACYDATAPATHS or the handle to
%      the existing singleton*.
%
%      SELECTLEGACYDATAPATHS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTLEGACYDATAPATHS.M with the given input arguments.
%
%      SELECTLEGACYDATAPATHS('Property','Value',...) creates a new SELECTLEGACYDATAPATHS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selectLegacyDataPaths_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selectLegacyDataPaths_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectLegacyDataPaths

% Last Modified by GUIDE v2.5 09-Feb-2016 13:57:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selectLegacyDataPaths_OpeningFcn, ...
                   'gui_OutputFcn',  @selectLegacyDataPaths_OutputFcn, ...
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


% --- Executes just before selectLegacyDataPaths is made visible.
function selectLegacyDataPaths_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectLegacyDataPaths (see VARARGIN)

% Choose default command line output for selectLegacyDataPaths
handles.rawDataPathOutput = '';
handles.alignedDataPathOutput = '';
handles.positiveAreaPathOutput = '';
handles.negativeAreaPathOutput = '';

% read in varargin
handles.defaultPath = varargin{1};

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.selectLegacyDataPaths,'WindowStyle','modal')

% UIWAIT makes selectEntryOrCreateNew wait for user response (see UIRESUME)
uiwait(handles.selectLegacyDataPaths);


% --- Outputs from this function are returned to the command line.
function varargout = selectLegacyDataPaths_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% Output: [cancel, rawDataPath, alignedDataPath, positiveAreaPath, negativeAreaPath]
varargout{1} = handles.cancelOutput;
varargout{2} = handles.rawDataPathOutput;
varargout{3} = handles.alignedDataPathOutput;
varargout{4} = handles.positiveAreaPathOutput;
varargout{5} = handles.negativeAreaPathOutput;

% The figure can be deleted now
delete(handles.selectLegacyDataPaths);



function rawDataPath_Callback(hObject, eventdata, handles)
% hObject    handle to rawDataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rawDataPath as text
%        str2double(get(hObject,'String')) returns contents of rawDataPath as a double


% --- Executes during object creation, after setting all properties.
function rawDataPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rawDataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectRawDataPath.
function selectRawDataPath_Callback(hObject, eventdata, handles)
% hObject    handle to selectRawDataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start = handles.defaultPath;
title = 'Select Raw Data Directory';

importDir = uigetdir(start, title);

if importDir ~= 0 %dir successfully selected
    handles.rawDataPathOutput = importDir;
    set(handles.rawDataPath, 'String', importDir);
    
    guidata(hObject, handles);
end

function alignedDataPath_Callback(hObject, eventdata, handles)
% hObject    handle to alignedDataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alignedDataPath as text
%        str2double(get(hObject,'String')) returns contents of alignedDataPath as a double


% --- Executes during object creation, after setting all properties.
function alignedDataPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alignedDataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectAlignedDataPath.
function selectAlignedDataPath_Callback(hObject, eventdata, handles)
% hObject    handle to selectAlignedDataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start = handles.defaultPath;
title = 'Select Aligned Data Directory';

importDir = uigetdir(start, title);

if importDir ~= 0 %dir successfully selected
    handles.alignedDataPathOutput = importDir;
    set(handles.alignedDataPath, 'String', importDir);
    
    guidata(hObject, handles);
end


function positiveAreaPath_Callback(hObject, eventdata, handles)
% hObject    handle to positiveAreaPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of positiveAreaPath as text
%        str2double(get(hObject,'String')) returns contents of positiveAreaPath as a double


% --- Executes during object creation, after setting all properties.
function positiveAreaPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to positiveAreaPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectPositiveAreaPath.
function selectPositiveAreaPath_Callback(hObject, eventdata, handles)
% hObject    handle to selectPositiveAreaPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start = handles.defaultPath;
title = 'Select Positive Area Directory';

importDir = uigetdir(start, title);

if importDir ~= 0 %dir successfully selected
    handles.positiveAreaPathOutput = importDir;
    set(handles.positiveAreaPath, 'String', importDir);
    
    guidata(hObject, handles);
end


function negativeAreaPath_Callback(hObject, eventdata, handles)
% hObject    handle to negativeAreaPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of negativeAreaPath as text
%        str2double(get(hObject,'String')) returns contents of negativeAreaPath as a double


% --- Executes during object creation, after setting all properties.
function negativeAreaPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to negativeAreaPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectNegativeAreaPath.
function selectNegativeAreaPath_Callback(hObject, eventdata, handles)
% hObject    handle to selectNegativeAreaPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start = handles.defaultPath;
title = 'Select Negative Area Directory';

importDir = uigetdir(start, title);

if importDir ~= 0 %dir successfully selected
    handles.negativeAreaPathOutput = importDir;
    set(handles.negativeAreaPath, 'String', importDir);
    
    guidata(hObject, handles);
end

% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.cancelOutput = 0;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.selectLegacyDataPaths);

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.cancelOutput = 1;
handles.rawDataPathOutput = '';
handles.alignedDataPathOutput = '';
handles.positiveAreaPathOutput = '';
handles.negativeAreaPathOutput = '';

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.selectLegacyDataPaths);

% --- Executes when user attempts to close selectLegacyDataPaths.
function selectLegacyDataPaths_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to selectLegacyDataPaths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
