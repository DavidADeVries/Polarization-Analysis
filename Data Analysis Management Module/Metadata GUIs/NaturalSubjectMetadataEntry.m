function varargout = NaturalSubjectMetadataEntry(varargin)
% NATURALSUBJECTMETADATAENTRY MATLAB code for NaturalSubjectMetadataEntry.fig
%      NATURALSUBJECTMETADATAENTRY, by itself, creates a new NATURALSUBJECTMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = NATURALSUBJECTMETADATAENTRY returns the handle to a new NATURALSUBJECTMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      NATURALSUBJECTMETADATAENTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NATURALSUBJECTMETADATAENTRY.M with the given input arguments.
%
%      NATURALSUBJECTMETADATAENTRY('Property','Value',...) creates a new NATURALSUBJECTMETADATAENTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NaturalSubjectMetadataEntry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NaturalSubjectMetadataEntry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NaturalSubjectMetadataEntry

% Last Modified by GUIDE v2.5 29-Mar-2016 14:02:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NaturalSubjectMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @NaturalSubjectMetadataEntry_OutputFcn, ...
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
end

% --- Executes just before NaturalSubjectMetadataEntry is made visible.
function NaturalSubjectMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NaturalSubjectMetadataEntry (see VARARGIN)

%***********************************************************************************************
%INPUT: (suggestedSubjectNumber, existingSubjectNumbers, userName, importPath, isEdit, subject*)
%       *may be empty
%***********************************************************************************************

handles.suggestedSubjectNumber = varargin{1};
handles.existingSubjectNumbers = varargin{2};
handles.userName = varargin{3};
handles.importPath = varargin{4};

isEdit = varargin{5};

subject = [];

if length(varargin) > 5
    subject = varargin{6};
end

if isempty(subject)
    subject = NaturalSubject;
end

handles.cancel = false;

if isEdit
    set(handles.pathTitle, 'Visible', 'off');
    set(handles.importPathTitle, 'Visible', 'off');

    handles.subjectNumber = subject.subjectNumber;
    handles.subjectId = subject.subjectId;    
    handles.age = subject.age;
    handles.gender = subject.gender;
    handles.diagnoses = subject.diagnoses;
    handles.causeOfDeath = subject.causeOfDeath;
    handles.timeOfDeath = subject.timeOfDeath;
    handles.medicalHistory = subject.medicalHistory;    
    handles.notes = subject.notes;
else    
    set(handles.importPathTitle, 'String', handles.importPath);
    
    defaultSubject = NaturalSubject;

    handles.subjectNumber = handles.suggestedSubjectNumber;
    handles.subjectId = defaultSubject.subjectId;  
    handles.age = defaultSubject.age;
    handles.gender = defaultSubject.gender;
    handles.diagnoses = defaultSubject.diagnoses;
    handles.causeOfDeath = defaultSubject.causeOfDeath;
    handles.timeOfDeath = defaultSubject.timeOfDeath;
    handles.medicalHistory = defaultSubject.medicalHistory;    
    handles.notes = defaultSubject.notes;
end

% ** SET TEXT FIELDS **

set(handles.ageInput, 'String', num2str(handles.age));
set(handles.deathInput, 'String', handles.causeOfDeath);
set(handles.subjectNumberInput, 'String', num2str(handles.subjectNumber));
set(handles.subjectIdInput, 'String', handles.subjectId);
set(handles.medicalHistoryInput, 'String', handles.medicalHistory);
set(handles.sbjNotesInput, 'String', handles.notes);

justDate = false;

setDateInput(handles.timeOfDeathInput, handles.timeOfDeath, justDate);

% ** SET POP UP MENUS **

defaultString = 'Select a Gender';
[genderTypeChoices, ~] = choicesFromEnum('GenderTypes');
selectedChoice = handles.gender;
setPopUpMenu(handles.genderInput, defaultString, genderTypeChoices, selectedChoice);


% ** SET DIAGNOSES LISTBOX **

setDiagnosesListbox(handles.diagnosesListbox, handles.diagnoses);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NaturalSubjectMetadataEntry wait for user response (see UIRESUME)
uiwait(handles.NaturalSubjectMetadataEntry);
end

% --- Outputs from this function are returned to the command line.
function varargout = NaturalSubjectMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ********************************************************************************************************************
% OUTPUT: [cancel, subjectNumber, subjectId, age, gender, diagnoses, causeOfDeath, timeOfDeath, medicalHistory, notes]
% ********************************************************************************************************************

% Get default command line output from handles structure
varargout{1} = handles.cancel;
varargout{2} = handles.subjectNumber;
varargout{3} = handles.subjectId;
varargout{4} = handles.age;
varargout{5} = handles.gender;
varargout{6} = handles.diagnoses;
varargout{7} = handles.causeOfDeath;
varargout{8} = handles.timeOfDeath;
varargout{9} = handles.medicalHistory;
varargout{10} = handles.notes;

close(handles.NaturalSubjectMetadataEntry);
end


function ageInput_Callback(hObject, eventdata, handles)
% hObject    handle to ageInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ageInput as text
%        str2double(get(hObject,'String')) returns contents of ageInput as a double

if isnan(str2double(get(hObject, 'String')))
    
    set(handles.ageInput, 'String', '');
    handles.age = [];
    
    warndlg('Age must be numerical.', 'Age Error', 'modal'); 
    
else
    handles.age = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function ageInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ageInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in genderInput.
function genderInput_Callback(hObject, eventdata, handles)
% hObject    handle to genderInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns genderInput contents as cell array
%        contents{get(hObject,'Value')} returns selected item from genderInput

%Get value from popup list
[genderChoice,~] = choicesFromEnum('GenderTypes');

if get(hObject, 'Value') == 1 
    handles.gender = [];
else
    handles.gender = genderChoice(get(hObject, 'Value')-1); 
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function genderInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to genderInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in diagnosisInput.
function diagnosisInput_Callback(hObject, eventdata, handles)
% hObject    handle to diagnosisInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns diagnosisInput contents as cell array
%        contents{get(hObject,'Value')} returns selected item from diagnosisInput



[diagnosisChoice,~] = choicesFromEnum('DiagnosisTypes');

%Check if value is default value
if get(hObject, 'Value') == 1 
    handles.ADDiagnosis = [];
else
    handles.ADDiagnosis = diagnosisChoice(get(hObject, 'Value')-1); 
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function diagnosisInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diagnosisInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function deathInput_Callback(hObject, eventdata, handles)
% hObject    handle to deathInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deathInput as text
%        str2double(get(hObject,'String')) returns contents of deathInput as a double

handles.causeOfDeath = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);


end

% --- Executes during object creation, after setting all properties.
function deathInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deathInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function sbjNotesInput_Callback(hObject, eventdata, handles)
% hObject    handle to sbjNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sbjNotesInput as text
%        str2double(get(hObject,'String')) returns contents of sbjNotesInput as a double

handles.notes = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function sbjNotesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sbjNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

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
        handles.age = [];
        handles.gender = [];
        handles.ADDiagnosis = [];
        handles.causeOfDeath = '';
        handles.notes = '';
        handles.medicalHistory = '';
        handles.subjectId = '';
        handles.subjectNumber = [];
        handles.cancel = true;
        guidata(hObject, handles);
        uiresume(handles.NaturalSubjectMetadataEntry);
    case 'No'
end

end

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
uiresume(handles.NaturalSubjectMetadataEntry);

end

% --- Executes when user attempts to close NaturalSubjectMetadataEntry.
function NaturalSubjectMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to NaturalSubjectMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    handles.age = [];
    handles.gender = [];
    handles.ADDiagnosis = [];
    handles.causeOfDeath = '';
    handles.notes = '';
    handles.medicalHistory = '';
    handles.subjectId = '';
    handles.subjectNumber = [];
    handles.cancel = true;
    guidata(hObject, handles);
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    handles.age = [];
    handles.gender = [];
    handles.ADDiagnosis = [];
    handles.causeOfDeath = '';
    handles.notes = '';
    handles.medicalHistory = '';
    handles.subjectId = '';
    handles.subjectNumber = [];
    handles.cancel = true;
    guidata(hObject, handles);
    delete(hObject);
end
end

function importPathTitle_Callback(hObject, eventdata, handles)
% hObject    handle to importPathTitle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of importPathTitle as text
%        str2double(get(hObject,'String')) returns contents of importPathTitle as a double

set(handles.importPathTitle, 'String', handles.importPath);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function importPathTitle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to importPathTitle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function subjectNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to subjectNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjectNumberInput as text
%        str2double(get(hObject,'String')) returns contents of subjectNumberInput as a double

if isnan(str2double(get(hObject, 'String')))
    
    set(handles.subjectNumberInput, 'String', '');
    handles.subjectNumber = [];
    
    warndlg('Subject number must be numerical.', 'Subject Number Error', 'modal'); 
    
else
    handles.subjectNumber = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function subjectNumberInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function subjectIdInput_Callback(hObject, eventdata, handles)
% hObject    handle to subjectIdInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjectIdInput as text
%        str2double(get(hObject,'String')) returns contents of subjectIdInput as a double

handles.subjectId = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function subjectIdInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectIdInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function medicalHistoryInput_Callback(hObject, eventdata, handles)
% hObject    handle to medicalHistoryInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of medicalHistoryInput as text
%        str2double(get(hObject,'String')) returns contents of medicalHistoryInput as a double

handles.medicalHistory = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function medicalHistoryInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to medicalHistoryInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

end

function timeOfDeathInput_Callback(hObject, eventdata, handles)
% hObject    handle to timeOfDeathInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeOfDeathInput as text
%        str2double(get(hObject,'String')) returns contents of timeOfDeathInput as a double

end

% --- Executes during object creation, after setting all properties.
function timeOfDeathInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeOfDeathInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in timeOfDeathButton.
function timeOfDeathButton_Callback(hObject, eventdata, handles)
% hObject    handle to timeOfDeathButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

justDate = false;

serialDate = guiDatePicker(now, justDate);

handles.timeOfDeath = serialDate;

setDateInput(handles.timeOfDeathInput, serialDate, justDate);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on selection change in diagnosesListbox.
function diagnosesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to diagnosesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns diagnosesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from diagnosesListbox

end

% --- Executes during object creation, after setting all properties.
function diagnosesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diagnosesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in addDiagnosisButton.
function addDiagnosisButton_Callback(hObject, eventdata, handles)
% hObject    handle to addDiagnosisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

isEdit = false;

[cancel, diagnosisType, diagnosisLevel, isPrimaryDiagnosis] = DiagnosisMetadataEntry(isEdit);

if ~cancel
    newDiagnosis = Diagnosis(diagnosisType, diagnosisLevel, isPrimaryDiagnosis);
    
    if isempty(handles.diagnoses)
        handles.diagnoses = {newDiagnosis};
    else
        handles.diagnoses = [handles.diagnoses, {newDiagnosis}];
    end
    
    setDiagnosesListbox(handles.diagnosesListbox, handles.diagnoses);
    
    guidata(hObject, handles);
end

end

% --- Executes on button press in deleteDiagnosisButton.
function deleteDiagnosisButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteDiagnosisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

diagnoses = handles.diagnoses;

if ~isempty(diagnoses)
    yes = 'Yes';
    no = 'No';
    
    exit = questdlg('Are you sure you want to delete the selected diagnosis?', 'Delete', yes, no, yes);
    
    switch exit
        case yes
            index = get(handles.diagnosesListbox, 'Value');
            
            handles.diagnoses(index) = [];
            
            setDiagnosesListbox(handles.diagnosesListbox, handles.diagnoses);
            
            guidata(hObject, handles);        
    end
    
end


end

% --- Executes on button press in editDiagnosisButton.
function editDiagnosisButton_Callback(hObject, eventdata, handles)
% hObject    handle to editDiagnosisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

diagnoses = handles.diagnoses;

if ~isempty(diagnoses)
    index = get(handles.diagnosesListbox, 'Value');
    
    selectedDiagnosis = diagnoses{index};
    
    isEdit = true;
    
    [cancel, diagnosisType, diagnosisLevel, isPrimaryDiagnosis] = DiagnosisMetadataEntry(isEdit, selectedDiagnosis);
    
    if ~cancel
        selectedDiagnosis.diagnosisType = diagnosisType;
        selectedDiagnosis.diagnosisLevel = diagnosisLevel;
        selectedDiagnosis.isPrimaryDiagnosis = isPrimaryDiagnosis;
        
        diagnoses{index} = selectedDiagnosis;
        
        handles.diagnoses = diagnoses;
        
        setDiagnosesListbox(handles.diagnosesListbox, handles.diagnoses);
        
        guidata(hObject, handles);
    end
end


end






%% Local Functions

function checkToEnableOkButton(handles)

%This function will check to see if any of the input variables are empty,
%and if not it will enable the OK button

if ~isempty(handles.subjectNumber) && ~isempty(handles.subjectId) && ~isempty(handles.age) && ~isempty(handles.gender) && ~isempty(handles.timeOfDeath) && ~isempty(handles.causeOfDeath)
    set(handles.OK, 'enable', 'on');
else
    set(handles.OK, 'enable', 'off');
end

end





