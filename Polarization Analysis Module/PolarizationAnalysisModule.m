function varargout = PolarizationAnalysisModule(varargin)
% POLARIZATIONANALYSISMODULE MATLAB code for PolarizationAnalysisModule.fig
%      POLARIZATIONANALYSISMODULE, by itself, creates a new POLARIZATIONANALYSISMODULE or raises the existing
%      singleton*.
%
%      H = POLARIZATIONANALYSISMODULE returns the handle to a new POLARIZATIONANALYSISMODULE or the handle to
%      the existing singleton*.
%
%      POLARIZATIONANALYSISMODULE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POLARIZATIONANALYSISMODULE.M with the given input arguments.
%
%      POLARIZATIONANALYSISMODULE('Property','Value',...) creates a new POLARIZATIONANALYSISMODULE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PolarizationAnalysisModule_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PolarizationAnalysisModule_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PolarizationAnalysisModule

% Last Modified by GUIDE v2.5 01-Apr-2016 13:26:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PolarizationAnalysisModule_OpeningFcn, ...
                   'gui_OutputFcn',  @PolarizationAnalysisModule_OutputFcn, ...
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


% --- Executes just before PolarizationAnalysisModule is made visible.
function PolarizationAnalysisModule_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PolarizationAnalysisModule (see VARARGIN)

% ***************************************
% INPUT: (project, projectPath, username)
% ***************************************

handles.project = varargin{1};
handles.projectPath = varargin{2};
handles.userName = varargin{3};

handles.versionCutoff = PolarizationAnalysisModuleVersion.versionNumber;

handles.rejected = false;
handles.rejectedReason = '';
handles.rejectedBy = handles.userName;

handles.validated = false;

handles.cancel = false;


% ** SET POP UP MENUS **

[choices, ~] = choicesFromEnum('MuellerMatrixNormalizationTypes');
defaultChoiceString = 'Select a Normalization Type';

selectedChoice = MuellerMatrixNormalizationTypes.mm00Max;

setPopUpMenu(handles.normalizationTypeSelect, defaultChoiceString, choices, selectedChoice);



[choices, ~] = choicesFromEnum('MuellerMatrixComputationTypes');
defaultChoiceString = 'Select a Computation Type';

selectedChoice = MuellerMatrixComputationTypes.frankProgram;

setPopUpMenu(handles.mmComputationSelect, defaultChoiceString, choices, selectedChoice);


% ** SET TEXT FIELDS **

set(handles.versionCutoffInput, 'String', num2str(handles.versionCutoff));
set(handles.currentVersionDisplay, 'String', num2str(handles.versionCutoff));


% ** SET LISTBOXES **

[choices, ~] = choicesFromEnum('CroppingTypes');

setListBox(handles.subsectionSelectListbox, choices);

setSubsectionSelectListbox(handles);


% ** SET REJECTED INPUTS **

handles = setRejectedInputFields(handles);


% SET LOCATION SELECT AND PROCESSING PROGRESS

selectedTrial = handles.project.getSelectedTrial();

[hasValidLocation, locationSelectStructure] = selectedTrial.createLocationSelectStructure();

if hasValidLocation
    [selectStrings, selectValues] = getSelectStringsAndValues(locationSelectStructure);
else
    selectStrings = {'No Valid Locations for Selected Trial'};
    selectValues = {};
    
    set(handles.runAnalysisButton, 'enable', 'off');
end

set(handles.locationSelectListbox, 'String', selectStrings, 'Value', selectValues);

progressStrings = getProgressStrings(locationSelectStructure);

set(handles.progressDisplay, 'String', progressStrings);

handles.locationSelectStructure = locationSelectStructure;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PolarizationAnalysisModule wait for user response (see UIRESUME)
uiwait(handles.PolarizationAnalysisModule);


% --- Outputs from this function are returned to the command line.
function varargout = PolarizationAnalysisModule_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% *************************
% OUTPUT: [cancel, project]
% *************************

varargout{1} = handles.cancel;
varargout{2} = handles.project;


% --- Executes on selection change in normalizationTypeSelect.
function normalizationTypeSelect_Callback(hObject, eventdata, handles)
% hObject    handle to normalizationTypeSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns normalizationTypeSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from normalizationTypeSelect


% --- Executes during object creation, after setting all properties.
function normalizationTypeSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalizationTypeSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mmComputationSelect.
function mmComputationSelect_Callback(hObject, eventdata, handles)
% hObject    handle to mmComputationSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mmComputationSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mmComputationSelect


% --- Executes during object creation, after setting all properties.
function mmComputationSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mmComputationSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fullFieldDataCheckbox.
function fullFieldDataCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to fullFieldDataCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fullFieldDataCheckbox


% --- Executes on button press in useRegisteredDataCheckbox.
function useRegisteredDataCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to useRegisteredDataCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useRegisteredDataCheckbox


% --- Executes on button press in autoUseMostRecentDataCheckbox.
function autoUseMostRecentDataCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to autoUseMostRecentDataCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoUseMostRecentDataCheckbox


% --- Executes on button press in processSubsectionDataCheckbox.
function processSubsectionDataCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to processSubsectionDataCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of processSubsectionDataCheckbox

setSubsectionSelectListbox(handles)


% --- Executes on selection change in subsectionSelectListbox.
function subsectionSelectListbox_Callback(hObject, eventdata, handles)
% hObject    handle to subsectionSelectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subsectionSelectListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subsectionSelectListbox


% --- Executes during object creation, after setting all properties.
function subsectionSelectListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subsectionSelectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rejectedReasonInput_Callback(hObject, eventdata, handles)
% hObject    handle to rejectedReasonInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rejectedReasonInput as text
%        str2double(get(hObject,'String')) returns contents of rejectedReasonInput as a double


% --- Executes during object creation, after setting all properties.
function rejectedReasonInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rejectedReasonInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rejectedByInput_Callback(hObject, eventdata, handles)
% hObject    handle to rejectedByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rejectedByInput as text
%        str2double(get(hObject,'String')) returns contents of rejectedByInput as a double


% --- Executes during object creation, after setting all properties.
function rejectedByInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rejectedByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function notesInput_Callback(hObject, eventdata, handles)
% hObject    handle to notesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notesInput as text
%        str2double(get(hObject,'String')) returns contents of notesInput as a double


% --- Executes during object creation, after setting all properties.
function notesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in onlyComputeMMCheckbox.
function onlyComputeMMCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to onlyComputeMMCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of onlyComputeMMCheckbox


% --- Executes on button press in doNotRerunDataAboveCutoffCheckbox.
function doNotRerunDataAboveCutoffCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to doNotRerunDataAboveCutoffCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of doNotRerunDataAboveCutoffCheckbox



function versionCutoffInput_Callback(hObject, eventdata, handles)
% hObject    handle to versionCutoffInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of versionCutoffInput as text
%        str2double(get(hObject,'String')) returns contents of versionCutoffInput as a double


% --- Executes during object creation, after setting all properties.
function versionCutoffInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to versionCutoffInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function currentVersionDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to currentVersionDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentVersionDisplay as text
%        str2double(get(hObject,'String')) returns contents of currentVersionDisplay as a double


% --- Executes during object creation, after setting all properties.
function currentVersionDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentVersionDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in locationSelectListbox.
function locationSelectListbox_Callback(hObject, eventdata, handles)
% hObject    handle to locationSelectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns locationSelectListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from locationSelectListbox

locationSelectStructure = handles.locationSelectStructure;

clickedIndex = get(hObject, 'Value');

if length(clickedIndex) == 1
    
    locationSelectStructure = updateLocationSelectStructure(locationSelectStructure, clickedIndex);
    
    % update highlighting
    [~, selectValues] = getSelectStringsAndValues(locationSelectStructure);
    
    set(handles.locationSelectListbox, 'Value', selectValues);
    
    % update progress strings
    progressStrings = getProgressStrings(locationSelectStructure);
    
    set(handles.progressDisplay, 'String', progressStrings);
    
    % push to handles
    handles.locationSelectStructure = locationSelectStructure;
    
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function locationSelectListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to locationSelectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in progressDisplay.
function progressDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to progressDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns progressDisplay contents as cell array
%        contents{get(hObject,'Value')} returns selected item from progressDisplay


% --- Executes during object creation, after setting all properties.
function progressDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to progressDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in yesRejectedButton.
function yesRejectedButton_Callback(hObject, eventdata, handles)
% hObject    handle to yesRejectedButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yesRejectedButton


% --- Executes on button press in noRejectedButton.
function noRejectedButton_Callback(hObject, eventdata, handles)
% hObject    handle to noRejectedButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noRejectedButton


% --- Executes on button press in runAnalysisButton.
function runAnalysisButton_Callback(hObject, eventdata, handles)
% hObject    handle to runAnalysisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in autoIgnoreRejectedSessions.
function autoIgnoreRejectedSessions_Callback(hObject, eventdata, handles)
% hObject    handle to autoIgnoreRejectedSessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoIgnoreRejectedSessions

% --- Executes on button press in validateButton.
function validateButton_Callback(hObject, eventdata, handles)
% hObject    handle to validateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disable fields that cann


selectionStructure = handles.locationSelectionStructure;



[isValidated, locationSelectionStructure] = validateLocationsForProcessing(selectionStructure


% ****************
% Helper Functions
% ****************

function setSubsectionSelectListbox(handles)

if get(handles.processSubsectionDataCheckbox, 'Value')
    enable = 'on';
else
    enable = 'off';
end

set(handles.subsectionSelectListbox, 'enable', enable);