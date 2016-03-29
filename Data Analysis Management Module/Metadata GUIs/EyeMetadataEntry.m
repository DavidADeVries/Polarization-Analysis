function varargout = EyeMetadataEntry(varargin)
% EYEMETADATAENTRY MATLAB code for EyeMetadataEntry.fig
%      EYEMETADATAENTRY, by itself, creates a new EYEMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = EYEMETADATAENTRY returns the handle to a new EYEMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      EYEMETADATAENTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EYEMETADATAENTRY.M with the given input arguments.
%
%      EYEMETADATAENTRY('Property','Value',...) creates a new EYEMETADATAENTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EyeMetadataEntry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EyeMetadataEntry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EyeMetadataEntry

% Last Modified by GUIDE v2.5 14-Mar-2016 16:56:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EyeMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @EyeMetadataEntry_OutputFcn, ...
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

% --- Executes just before EyeMetadataEntry is made visible.
function EyeMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EyeMetadataEntry (see VARARGIN)

% Choose default command line output for EyeMetadataEntry
handles.output = hObject;

% *********************************************************************************************************************************
% INPUT: (suggestedSampleNumber, existingSampleNumbers, suggestedEyeNumber, existingEyeNumbers, userName, importPath, isEdit, eye*)
%        *may be empty
% *********************************************************************************************************************************

if isa(varargin{1},'numeric');
    handles.suggestedSampleNumber = num2str(varargin{1}); %Parameter name is 'suggestedSampleNumber' from Eye class function
else
    handles.suggestedSampleNumber = '';
end

handles.existingSampleNumbers = varargin{2};

if isa(varargin{3},'numeric');
    handles.suggestedEyeNumber = num2str(varargin{3}); %Parameter name is 'suggestedEyeNumber' from Eye class function
else
    handles.suggestedEyeNumber = '';
end

handles.existingEyeNumbers = varargin{4};
handles.userName = varargin{5};% Parameter name is 'userName'
handles.importPath = varargin{6}; % Parameter name is 'importPath'

isEdit = varargin{7};

eye = [];

if length(varargin) > 7
    eye = varargin{8};
end

if isempty(eye)
    eye = Eye;
end

handles.cancel = false;

%-----------------------------------------------------
if isEdit
    set(handles.OK, 'enable', 'on');
    
    set(handles.importPathTitle, 'Visible', 'off');
    set(handles.pathTitle, 'Visible', 'off')
    
    handles.eyeId = eye.eyeId;
    handles.eyeTypeChoice = eye.eyeType;
    handles.eyeNumber = eye.eyeNumber;
    handles.dissectionDate = eye.dissectionDate;
    handles.dissectionDoneBy = eye.dissectionDoneBy;
    handles.eyeNotes = eye.notes;
    handles.sampleNumber = eye.sampleNumber;
    handles.source = eye.source;
    handles.timeOfRemoval = eye.timeOfRemoval;
    handles.timeOfProcessing = eye.timeOfProcessing;
    handles.dateReceived =eye.dateReceived;
    handles.storageLocation = eye.storageLocation;
    handles.initialFixative = eye.initialFixative;
    handles.initialFixativePercent = eye.initialFixativePercent;
    handles.initialFixingTime = eye.initialFixingTime;
    handles.secondaryFixative = eye.secondaryFixative;
    handles.secondaryFixativePercent = eye.secondaryFixativePercent;
    handles.secondaryFixingTime = eye.secondaryFixingTime;
else
    defaultEye = Eye;
    
    set(handles.OK, 'enable', 'on');
    
    set(handles.importPathTitle, 'String', handles.importPath);
    
    handles.eyeId = defaultEye.eyeId;
    handles.eyeTypeChoice = defaultEye.eyeType;
    handles.eyeNumber = handles.suggestedEyeNumber;
    handles.dissectionDate = defaultEye.dissectionDate;
    handles.dissectionDoneBy = handles.userName;
    handles.eyeNotes = defaultEye.notes;
    handles.sampleNumber = handles.suggestedSampleNumber;
    handles.source = defaultEye.source;
    handles.timeOfRemoval = defaultEye.timeOfRemoval;
    handles.timeOfProcessing = defaultEye.timeOfProcessing;
    handles.dateReceived = defaultEye.dateReceived;
    handles.storageLocation = defaultEye.storageLocation;
    handles.initialFixative = defaultEye.initialFixative;
    handles.initialFixativePercent = defaultEye.initialFixativePercent;
    handles.initialFixingTime = defaultEye.initialFixingTime;
    handles.secondaryFixative = defaultEye.secondaryFixative;
    handles.secondaryFixativePercent = defaultEye.secondaryFixativePercent;
    handles.secondaryFixingTime = defaultEye.secondaryFixingTime;
end

% ** SET TEXT FIELDS **

set(handles.eyeIdInput, 'String', handles.eyeId);
set(handles.eyeNumberInput, 'String', num2str(handles.eyeNumber));
set(handles.dissectionDoneByInput, 'String', handles.dissectionDoneBy);
set(handles.eyeNotesInput, 'String', handles.eyeNotes);
set(handles.sampleNumberInput, 'String', num2str(handles.sampleNumber));
set(handles.storageLocationInput, 'String', handles.storageLocation);
set(handles.initialFixativePercentInput, 'String', num2str(handles.initialFixativePercent));
set(handles.secondaryFixativePercentInput, 'String', num2str(handles.secondaryFixativePercent));

justDate = true;

setDateInput(handles.timeOfRemovalDisplay, handles.timeOfRemoval, ~justDate);
setDateInput(handles.timeOfProcessingDisplay, handles.timeOfProcessing, ~justDate);
setDateInput(handles.dateReceivedDisplay, handles.dateReceived, justDate);
setDateInput(handles.dissectionDateInput, handles.dissectionDate, justDate);
setDateInput(handles.initialFixingTimeDisplay, handles.initialFixingTime, ~justDate);
setDateInput(handles.secondaryFixingTimeDisplay, handles.secondaryFixingTime, ~justDate);

% ** SET POP UP MENUS **

defaultString = 'Select an Eye Type';
[eyeTypeChoices, ~] = choicesFromEnum('EyeTypes');
selectedChoice = handles.eyeTypeChoice;
setPopUpMenu(handles.eyeTypeList, defaultString, eyeTypeChoices, selectedChoice);

defaultString = 'Select a Sample Source';
[sourceChoices, ~] = choicesFromEnum('TissueSampleSourceTypes');
selectedChoice = handles.source;
setPopUpMenu(handles.tissueSampleSourceList, defaultString, sourceChoices, selectedChoice)

defaultString = 'Select a Fixative';
[fixativeChoices, ~] = choicesFromEnum('FixativeTypes');

selectedChoice = handles.initialFixative;
setPopUpMenu(handles.initialFixativeList, defaultString, fixativeChoices, selectedChoice)

selectedChoice = handles.secondaryFixative;
setPopUpMenu(handles.secondaryFixativeList, defaultString, fixativeChoices, selectedChoice)


guidata(hObject, handles);

% UIWAIT makes EyeMetadataEntry wait for user response (see UIRESUME)
uiwait(handles.EyeMetadataEntry);

end

% --- Outputs from this function are returned to the command line.
function varargout = EyeMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ********************************************************************************************************************************************************************************************************************************************************************************************************
% OUTPUT: [cancel, eyeId, eyeType, sampleNumber, eyeNumber, dissectionDate, dissectionDoneBy, notes, source, timeOfRemoval, timeOfProcessing, dateReceived, storingLocation, initialFixative, initialFixativePercent, initialFixingTime, secondaryFixative, secondaryFixativePercent, secondaryFixingTime]
% ********************************************************************************************************************************************************************************************************************************************************************************************************

varargout{1} = handles.cancel;
varargout{2} = handles.eyeId; %Output eyeId variable
varargout{3} = handles.eyeTypeChoice;  %Output eyeTypeChoice variable
varargout{4} = handles.sampleNumber;
varargout{5} = handles.eyeNumber;  %Output eyeNumber variable
varargout{6} = handles.dissectionDate; %Output dissectionDate variable
varargout{7} = handles.dissectionDoneBy; %Output dissectionDoneBy variable
varargout{8} = handles.eyeNotes; %Output eyeNotes variable
varargout{9} = handles.source;
varargout{10} = handles.timeOfRemoval;
varargout{11} = handles.timeOfProcessing;
varargout{12} = handles.dateReceived;
varargout{13} = handles.storageLocation;
varargout{14} = handles.initialFixative;
varargout{15} = handles.initialFixativePercent;
varargout{16} = handles.initialFixingTime;
varargout{17} = handles.secondaryFixative;
varargout{18} = handles.secondaryFixativePercent;
varargout{19} = handles.secondaryFixingTime;

close(handles.EyeMetadataEntry);
end



function eyeIdInput_Callback(hObject, eventdata, handles)
% hObject    handle to EyeIDInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EyeIDInput as text
%        str2double(get(hObject,'String')) returns contents of EyeIDInput as a double

%Get value from input box
handles.eyeId = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function eyeIdInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EyeIDInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in EyeTypeList.
function eyeTypeList_Callback(hObject, eventdata, handles)
% hObject    handle to EyeTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EyeTypeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EyeTypeList

[choices, ~] = choicesFromEnum('EyeTypes');


% Check if value is default value
if get(hObject, 'Value') == 1 
    handles.eyeTypeChoice = [];
else
    handles.eyeTypeChoice = choices(get(hObject, 'Value')-1); 
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function eyeTypeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EyeTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function eyeNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to EyeNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EyeNumberInput as text
%        str2double(get(hObject,'String')) returns contents of EyeNumberInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.eyeNumberInput, 'String', '');
    handles.eyeNumber = [];
    
    warndlg('Eye Number must be numerical.', 'Eye Number Error', 'modal'); 
    
else
    handles.eyeNumber = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

function eyeNumberInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EyeNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function dissectionDateInput_Callback(hObject, eventdata, handles)
% hObject    handle to DissectionDateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DissectionDateInput as text
%        str2double(get(hObject,'String')) returns contents of DissectionDateInput as a double

%Get value from input box
handles.dissectionDate = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function dissectionDateInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DissectionDateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function dissectionDoneByInput_Callback(hObject, eventdata, handles)
% hObject    handle to DissectionDoneBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DissectionDoneBy as text
%        str2double(get(hObject,'String')) returns contents of DissectionDoneBy as a double

%Get value from input box
handles.dissectionDoneBy = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function dissectionDoneByInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DissectionDoneBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function eyeNotesInput_Callback(hObject, eventdata, handles)
% hObject    handle to EyeNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EyeNotesInput as text
%        str2double(get(hObject,'String')) returns contents of EyeNotesInput as a double

%Get value from input box
handles.eyeNotes = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function eyeNotesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EyeNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

end


% --- Executes when user attempts to close EyeMetadataEntry.
function EyeMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to EyeMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    handles.cancel = true;
    handles.eyeId = '';
    handles.eyeTypeChoice = [];
    handles.eyeNumber = [];
    handles.dissectionDate = '';
    handles.dissectionDoneBy = '';
    handles.eyeNotes = '';
    guidata(hObject, handles);
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    handles.cancel = true;
    handles.eyeId = '';
    handles.eyeTypeChoice = [];
    handles.eyeNumber = [];
    handles.dissectionDate = '';
    handles.dissectionDoneBy = '';
    handles.eyeNotes = '';
    guidata(hObject, handles);
    delete(hObject);
end
end


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
uiresume(handles.EyeMetadataEntry);

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
        handles.eyeId = '';
        handles.eyeTypeChoice = [];
        handles.eyeNumber = [];
        handles.dissectionDate = '';
        handles.dissectionDoneBy = '';
        handles.eyeNotes = '';
        guidata(hObject, handles);
        uiresume(handles.EyeMetadataEntry);
    case 'No'
end
end

function importPathTitle_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in pickImagingDate.
function pickDissectionDate_Callback(hObject, eventdata, handles)
% hObject    handle to pickImagingDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

justDate = true;

serialDate = guiDatePicker(now, justDate);

handles.dissectionDate = serialDate;

setDateInput(handles.dissectionDateInput, serialDate, justDate);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

function sampleNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to sampleNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampleNumberInput as text
%        str2double(get(hObject,'String')) returns contents of sampleNumberInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.sampleNumberInput, 'String', '');
    handles.sampleNumber = [];
    
    warndlg('Sample Number must be numerical.', 'Sample Number Error', 'modal'); 
    
else
    handles.sampleNumber = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function sampleNumberInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in tissueSampleSourceList.
function tissueSampleSourceList_Callback(hObject, eventdata, handles)
% hObject    handle to tissueSampleSourceList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tissueSampleSourceList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tissueSampleSourceList

[choices, ~] = choicesFromEnum('TissueSampleSourceTypes');


% Check if value is default value
if get(hObject, 'Value') == 1 
    handles.source = [];
else
    handles.source = choices(get(hObject, 'Value')-1); 
end

checkToEnableOkButton(handles);

guidata(hObject, handles);


end

% --- Executes during object creation, after setting all properties.
function tissueSampleSourceList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tissueSampleSourceList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function timeOfProcessingDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to timeOfProcessingDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeOfProcessingDisplay as text
%        str2double(get(hObject,'String')) returns contents of timeOfProcessingDisplay as a double
end

% --- Executes during object creation, after setting all properties.
function timeOfProcessingDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeOfProcessingDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function dateReceivedDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to dateReceivedDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dateReceivedDisplay as text
%        str2double(get(hObject,'String')) returns contents of dateReceivedDisplay as a double
end

% --- Executes during object creation, after setting all properties.
function dateReceivedDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dateReceivedDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function storageLocationInput_Callback(hObject, eventdata, handles)
% hObject    handle to storageLocationInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of storageLocationInput as text
%        str2double(get(hObject,'String')) returns contents of storageLocationInput as a double

handles.storageLocation = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function storageLocationInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to storageLocationInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function initialFixingTimeDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to initialFixingTimeDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initialFixingTimeDisplay as text
%        str2double(get(hObject,'String')) returns contents of initialFixingTimeDisplay as a double
end

% --- Executes during object creation, after setting all properties.
function initialFixingTimeDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initialFixingTimeDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function initialFixativePercentInput_Callback(hObject, eventdata, handles)
% hObject    handle to initialFixativePercentInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initialFixativePercentInput as text
%        str2double(get(hObject,'String')) returns contents of initialFixativePercentInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.initialFixativePercentInput, 'String', '');
    handles.initialFixativePercent = [];
    
    warndlg('Initial Fixative Percent must be numerical.', 'Initial Fixative Percent Error', 'modal'); 
    
else
    handles.initialFixativePercent = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function initialFixativePercentInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initialFixativePercentInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function timeOfRemovalDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to timeOfRemovalDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeOfRemovalDisplay as text
%        str2double(get(hObject,'String')) returns contents of timeOfRemovalDisplay as a double
end

% --- Executes during object creation, after setting all properties.
function timeOfRemovalDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeOfRemovalDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in initialFixativeList.
function initialFixativeList_Callback(hObject, eventdata, handles)
% hObject    handle to initialFixativeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns initialFixativeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from initialFixativeList

[choices, ~] = choicesFromEnum('FixativeTypes');


% Check if value is default value
if get(hObject, 'Value') == 1 
    handles.initialFixative = [];
else
    handles.initialFixative = choices(get(hObject, 'Value')-1); 
end

checkToEnableOkButton(handles);

guidata(hObject, handles);


end

% --- Executes during object creation, after setting all properties.
function initialFixativeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initialFixativeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in secondaryFixativeList.
function secondaryFixativeList_Callback(hObject, eventdata, handles)
% hObject    handle to secondaryFixativeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns secondaryFixativeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from secondaryFixativeList

[choices, ~] = choicesFromEnum('FixativeTypes');


% Check if value is default value
if get(hObject, 'Value') == 1 
    handles.secondaryFixative = [];
else
    handles.secondaryFixative = choices(get(hObject, 'Value')-1); 
end

checkToEnableOkButton(handles);

guidata(hObject, handles);


end

% --- Executes during object creation, after setting all properties.
function secondaryFixativeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondaryFixativeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function secondaryFixativePercentInput_Callback(hObject, eventdata, handles)
% hObject    handle to secondaryFixativePercentInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secondaryFixativePercentInput as text
%        str2double(get(hObject,'String')) returns contents of secondaryFixativePercentInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.secondaryFixativePercentInput, 'String', '');
    handles.secondaryFixativePercent = [];
    
    warndlg('Secondary Fixative Percent must be numerical.', 'Secondary Fixative Percent Error', 'modal'); 
    
else
    handles.secondaryFixativePercent = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function secondaryFixativePercentInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondaryFixativePercentInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function secondaryFixingTimeDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to secondaryFixingTimeDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secondaryFixingTimeDisplay as text
%        str2double(get(hObject,'String')) returns contents of secondaryFixingTimeDisplay as a double
end

% --- Executes during object creation, after setting all properties.
function secondaryFixingTimeDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondaryFixingTimeDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in timeOfRemovalPicker.
function timeOfRemovalPicker_Callback(hObject, eventdata, handles)
% hObject    handle to timeOfRemovalPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

justDate = false;

serialDate = guiDatePicker(now, justDate);

handles.timeOfRemoval = serialDate;

setDateInput(handles.timeOfRemovalDisplay, serialDate, justDate);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in timeOfProcessingPicker.
function timeOfProcessingPicker_Callback(hObject, eventdata, handles)
% hObject    handle to timeOfProcessingPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

justDate = false;

serialDate = guiDatePicker(now, justDate);

handles.timeOfProcessing = serialDate;

setDateInput(handles.timeOfProcessingDisplay, serialDate, justDate);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in dateReceivedPicker.
function dateReceivedPicker_Callback(hObject, eventdata, handles)
% hObject    handle to dateReceivedPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

justDate = true;

serialDate = guiDatePicker(now, justDate);

handles.dateReceived = serialDate;

setDateInput(handles.dateReceivedDisplay, serialDate, justDate);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in initialFixingTimePicker.
function initialFixingTimePicker_Callback(hObject, eventdata, handles)
% hObject    handle to initialFixingTimePicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

justDate = false;

serialDate = guiDatePicker(now, justDate);

handles.initialFixingTime = serialDate;

setDateInput(handles.initialFixingTimeDisplay, serialDate, justDate);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in secondaryFixingTimePicker.
function secondaryFixingTimePicker_Callback(hObject, eventdata, handles)
% hObject    handle to secondaryFixingTimePicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

justDate = false;

serialDate = guiDatePicker(now, justDate);

handles.secondaryFixingTime = serialDate;

setDateInput(handles.secondaryFixingTimeDisplay, serialDate, justDate);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

%% Local Functions

function checkToEnableOkButton(handles)

%This function will check to see if any of the input variables are empty,
%and if not it will enable the OK button

% if ~isempty(handles.eyeId) && ~isempty(handles.eyeTypeChoice) && ~isempty(handles.eyeNumber) && ~isempty(handles.dissectionDate) && ~isempty(handles.dissectionDoneBy)
%     set(handles.OK, 'enable', 'on');
% else
%     set(handles.OK, 'enable', 'off');
% end

end


