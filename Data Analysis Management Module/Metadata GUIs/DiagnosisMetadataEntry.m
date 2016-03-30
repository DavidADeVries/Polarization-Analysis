function varargout = DiagnosisMetadataEntry(varargin)
% DIAGNOSISMETADATAENTRY MATLAB code for DiagnosisMetadataEntry.fig
%      DIAGNOSISMETADATAENTRY, by itself, creates a new DIAGNOSISMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = DIAGNOSISMETADATAENTRY returns the handle to a new DIAGNOSISMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      DIAGNOSISMETADATAENTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIAGNOSISMETADATAENTRY.M with the given input arguments.
%
%      DIAGNOSISMETADATAENTRY('Property','Value',...) creates a new DIAGNOSISMETADATAENTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DiagnosisMetadataEntry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DiagnosisMetadataEntry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DiagnosisMetadataEntry

% Last Modified by GUIDE v2.5 29-Mar-2016 15:38:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DiagnosisMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @DiagnosisMetadataEntry_OutputFcn, ...
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


% --- Executes just before DiagnosisMetadataEntry is made visible.
function DiagnosisMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DiagnosisMetadataEntry (see VARARGIN)

% ***************************
% INPUT: (isEdit, diagnosis*)
%        *may be empty
% ***************************

isEdit = varargin{1};

diagnosis = [];

if length(varargin) > 1
    diagnosis = varargin{2};
end

if isempty(diagnosis)
    diagnosis = Diagnosis;
end

handles.cancel = false;

if isEdit
    handles.diagnosisType = diagnosis.diagnosisType;
    handles.diagnosisLevel = diagnosis.diagnosisLevel;
    handles.isPrimaryDiagnosis = diagnosis.isPrimaryDiagnosis;
else
    defaultDiagnosis = Diagnosis;
    
    handles.diagnosisType = defaultDiagnosis.diagnosisType;
    handles.diagnosisLevel = defaultDiagnosis.diagnosisLevel;
    handles.isPrimaryDiagnosis = defaultDiagnosis.isPrimaryDiagnosis;    
end
    
% ** SET POP UP MENUS **

defaultString = 'Select Diagnosis Type';
[diagnosisTypeChoices, ~] = choicesFromEnum('DiagnosisTypes');
selectedChoice = handles.diagnosisType;
setPopUpMenu(handles.diagnosisTypeSelect, defaultString, diagnosisTypeChoices, selectedChoice);

defaultString = 'Select Diagnosis Level';
[diagnosisLevelTypeChoices, ~] = choicesFromEnum('DiagnosisLevelTypes');
selectedChoice = handles.diagnosisLevel;
setPopUpMenu(handles.diagnosisLevelSelect, defaultString, diagnosisLevelTypeChoices, selectedChoice);

% ** SET CHECKBOXES **

set(handles.isPrimaryDiagnosisCheckbox, 'Value', handles.isPrimaryDiagnosis);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DiagnosisMetadataEntry wait for user response (see UIRESUME)
uiwait(handles.diagnosisMetadataEntry);


% --- Outputs from this function are returned to the command line.
function varargout = DiagnosisMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% *******************************************************************
% OUTPUT: [cancel, diagnosisType, diagnosisLevel, isPrimaryDiagnosis]
% *******************************************************************

varargout{1} = handles.cancel;
varargout{2} = handles.diagnosisType;
varargout{3} = handles.diagnosisLevel;
varargout{4} = handles.isPrimaryDiagnosis;

close(handles.diagnosisMetadataEntry);

% --- Executes on selection change in diagnosisTypeSelect.
function diagnosisTypeSelect_Callback(hObject, eventdata, handles)
% hObject    handle to diagnosisTypeSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns diagnosisTypeSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from diagnosisTypeSelect

[choices, ~] = choicesFromEnum('DiagnosisTypes');

% Check if value is default value
if get(hObject, 'Value') == 1 
    handles.source = [];
else
    handles.diagnosisType = choices(get(hObject, 'Value')-1); 
end


guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function diagnosisTypeSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diagnosisTypeSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in diagnosisLevelSelect.
function diagnosisLevelSelect_Callback(hObject, eventdata, handles)
% hObject    handle to diagnosisLevelSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns diagnosisLevelSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from diagnosisLevelSelect

[choices, ~] = choicesFromEnum('DiagnosisLevelTypes');

% Check if value is default value
if get(hObject, 'Value') == 1 
    handles.source = [];
else
    handles.diagnosisLevel = choices(get(hObject, 'Value')-1); 
end


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function diagnosisLevelSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diagnosisLevelSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in isPrimaryDiagnosisCheckbox.
function isPrimaryDiagnosisCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to isPrimaryDiagnosisCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isPrimaryDiagnosisCheckbox

handles.isPrimaryDiagnosis = get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exit = questdlg('Are you sure you want to quit?','Quit','Yes','No','No'); % TODO just cancel or is this just fine?
switch exit
    case 'Yes'
        %Clears variables in the case that they wish to exit the program
        handles.cancel = true;
        
        guidata(hObject, handles);
        uiresume(handles.diagnosisMetadataEntry);
    case 'No'
end

% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.diagnosisMetadataEntry);

% --- Executes when user attempts to close diagnosisMetadataEntry.
function diagnosisMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to diagnosisMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.cancel = true;

guidata(hObject, handles);

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
