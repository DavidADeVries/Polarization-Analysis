function varargout = polarizationAnalysisGui(varargin)
% POLARIZATIONANALYSISGUI MATLAB code for polarizationAnalysisGui.fig
%      POLARIZATIONANALYSISGUI, by itself, creates a new POLARIZATIONANALYSISGUI or raises the existing
%      singleton*.
%
%      H = POLARIZATIONANALYSISGUI returns the handle to a new POLARIZATIONANALYSISGUI or the handle to
%      the existing singleton*.
%
%      POLARIZATIONANALYSISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POLARIZATIONANALYSISGUI.M with the given input arguments.
%
%      POLARIZATIONANALYSISGUI('Property','Value',...) creates a new POLARIZATIONANALYSISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before polarizationAnalysisGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to polarizationAnalysisGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help polarizationAnalysisGui

% Last Modified by GUIDE v2.5 15-Mar-2016 16:26:37

% Begin initialization code - DO NOT EDIT

addpath(genpath('.'));

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @polarizationAnalysisGui_OpeningFcn, ...
                   'gui_OutputFcn',  @polarizationAnalysisGui_OutputFcn, ...
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


% --- Executes just before polarizationAnalysisGui is made visible.
function polarizationAnalysisGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to polarizationAnalysisGui (see VARARGIN)

% import needed libraries
addpath('Callbacks');

handles = guiInitialize(handles);


% Choose default command line output for polarizationAnalysisGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes polarizationAnalysisGui wait for user response (see UIRESUME)
% uiwait(handles.polarizationAnalysisGui);


% --- Outputs from this function are returned to the command line.
function varargout = polarizationAnalysisGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectNetworkPath.
function selectNetworkPath_Callback(hObject, eventdata, handles)
% hObject    handle to selectNetworkPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectNetworkPath(hObject, eventdata, handles);


% --- Executes on button press in selectLocalPath.
function selectLocalPath_Callback(hObject, eventdata, handles)
% hObject    handle to selectLocalPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectLocalPath(hObject, eventdata, handles);


% --------------------------------------------------------------------
function importData_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to importData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

importData(hObject, eventdata, handles);


function userNameTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to userNameTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of userNameTextbox as text
%        str2double(get(hObject,'String')) returns contents of userNameTextbox as a double

userNameTextbox(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function userNameTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to userNameTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in trialSelect.
function trialSelect_Callback(hObject, eventdata, handles)
% hObject    handle to trialSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trialSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trialSelect

trialSelect(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function trialSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in subjectSelect.
function subjectSelect_Callback(hObject, eventdata, handles)
% hObject    handle to subjectSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subjectSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subjectSelect

subjectSelect(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function subjectSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sampleSelect.
function sampleSelect_Callback(hObject, eventdata, handles)
% hObject    handle to sampleSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sampleSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sampleSelect

sampleSelect(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function sampleSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in quarterSampleSelect.
function quarterSampleSelect_Callback(hObject, eventdata, handles)
% hObject    handle to quarterSampleSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns quarterSampleSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from quarterSampleSelect

quarterSampleSelect(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function quarterSampleSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quarterSampleSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in locationSelect.
function locationSelect_Callback(hObject, eventdata, handles)
% hObject    handle to locationSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns locationSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from locationSelect

locationSelect(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function locationSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to locationSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sessionSelect.
function sessionSelect_Callback(hObject, eventdata, handles)
% hObject    handle to sessionSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sessionSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sessionSelect

sessionSelect(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function sessionSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in subfolderSelect.
function subfolderSelect_Callback(hObject, eventdata, handles)
% hObject    handle to subfolderSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subfolderSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subfolderSelect

subfolderSelect(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function subfolderSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subfolderSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fileSelect.
function fileSelect_Callback(hObject, eventdata, handles)
% hObject    handle to fileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fileSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileSelect

fileSelect(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function fileSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uplinkLocalToNetwork.
function uplinkLocalToNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to uplinkLocalToNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in downlinkNetworkToLocal.
function downlinkNetworkToLocal_Callback(hObject, eventdata, handles)
% hObject    handle to downlinkNetworkToLocal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openInNewFigure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openInNewFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

openInNewFigure(hObject, eventdata, handles);


function subjectMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to subjectMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjectMetadata as text
%        str2double(get(hObject,'String')) returns contents of subjectMetadata as a double


% --- Executes during object creation, after setting all properties.
function subjectMetadata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eyeQuarterSampleMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to eyeQuarterSampleMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eyeQuarterSampleMetadata as text
%        str2double(get(hObject,'String')) returns contents of eyeQuarterSampleMetadata as a double


% --- Executes during object creation, after setting all properties.
function eyeQuarterSampleMetadata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eyeQuarterSampleMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function locationMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to locationMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of locationMetadata as text
%        str2double(get(hObject,'String')) returns contents of locationMetadata as a double


% --- Executes during object creation, after setting all properties.
function locationMetadata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to locationMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sessionMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to sessionMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sessionMetadata as text
%        str2double(get(hObject,'String')) returns contents of sessionMetadata as a double


% --- Executes during object creation, after setting all properties.
function sessionMetadata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trialMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to trialMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trialMetadata as text
%        str2double(get(hObject,'String')) returns contents of trialMetadata as a double


% --- Executes during object creation, after setting all properties.
function trialMetadata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function projectMenu_Callback(hObject, eventdata, handles)
% hObject    handle to projectMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function trialMenu_Callback(hObject, eventdata, handles)
% hObject    handle to trialMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sampleMenu_Callback(hObject, eventdata, handles)
% hObject    handle to sampleMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function locationMenu_Callback(hObject, eventdata, handles)
% hObject    handle to locationMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sessionMenu_Callback(hObject, eventdata, handles)
% hObject    handle to sessionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on userNameTextbox and none of its controls.
function userNameTextbox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to userNameTextbox (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on key press with focus on fileSelect and none of its controls.
function fileSelect_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to fileSelect (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

fileSelectKeyPressFcn(hObject, eventdata, handles);




% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function importLegacyData_Callback(hObject, eventdata, handles)
% hObject    handle to importLegacyData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

importLegacyData(hObject, eventdata, handles);

% --------------------------------------------------------------------
function importDataCollectionSession_Callback(hObject, eventdata, handles)
% hObject    handle to importDataCollectionSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function editSessionMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to editSessionMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editSessionMetadata(hObject, eventdata, handles);

% --------------------------------------------------------------------
function editLocationMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to editLocationMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editLocationMetadata(hObject, eventdata, handles);

% --------------------------------------------------------------------
function editSampleMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to editSampleMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editSampleMetadata(hObject, eventdata, handles);

% --------------------------------------------------------------------
function editTrialMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to editTrialMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editTrialMetadata(hObject, eventdata, handles);

% --------------------------------------------------------------------
function editProjectMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to editProjectMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editProjectMetadata(hObject, eventdata, handles);


% --------------------------------------------------------------------
function quarterMenu_Callback(hObject, eventdata, handles)
% hObject    handle to quarterMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function editQuarterMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to editQuarterMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editQuarterMetadata(hObject, eventdata, handles);


% --------------------------------------------------------------------
function subjectMenu_Callback(hObject, eventdata, handles)
% hObject    handle to subjectMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function editSubjectMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to editSubjectMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editSubjectMetadata(hObject, eventdata, handles);


% --------------------------------------------------------------------
function newEye_Callback(hObject, eventdata, handles)
% hObject    handle to newEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newEye(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newBrainSection_Callback(hObject, eventdata, handles)
% hObject    handle to newBrainSection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newBrainSection(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newCsfSample_Callback(hObject, eventdata, handles)
% hObject    handle to newCsfSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newCsfSample(hObject, eventdata, handles);


% --------------------------------------------------------------------
function newProject_Callback(hObject, eventdata, handles)
% hObject    handle to newProject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newProject(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newTrial_Callback(hObject, eventdata, handles)
% hObject    handle to newTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newTrial(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newSubject_Callback(hObject, eventdata, handles)
% hObject    handle to newSubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newSubject(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newQuarter_Callback(hObject, eventdata, handles)
% hObject    handle to newQuarter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newQuarter(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newLocation_Callback(hObject, eventdata, handles)
% hObject    handle to newLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newLocation(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newMicroscopeSession_Callback(hObject, eventdata, handles)
% hObject    handle to newMicroscopeSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newMicroscopeSession(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newCsloSession_Callback(hObject, eventdata, handles)
% hObject    handle to newCsloSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newCsloSession(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newLegacyRegistrationSession_Callback(hObject, eventdata, handles)
% hObject    handle to newLegacyRegistrationSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newLegacyRegistrationSession(hObject, eventdata, handles);

% --------------------------------------------------------------------
function newLegacySubsectionSelectionSession_Callback(hObject, eventdata, handles)
% hObject    handle to newLegacySubsectionSelectionSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newLegacySubsectionSelectionSession(hObject, eventdata, handles);
