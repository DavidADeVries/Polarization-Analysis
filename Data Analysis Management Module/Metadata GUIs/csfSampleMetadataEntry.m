function varargout = CsfSampleMetadataEntry(varargin)
% CSFSAMPLEMETADATAENTRY MATLAB code for CsfSampleMetadataEntry.fig
%      CSFSAMPLEMETADATAENTRY, by itself, creates a new CSFSAMPLEMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = CSFSAMPLEMETADATAENTRY returns the handle to a new CSFSAMPLEMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      CSFSAMPLEMETADATAENTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSFSAMPLEMETADATAENTRY.M with the given input arguments.
%
%      CSFSAMPLEMETADATAENTRY('Property','Value',...) creates a new CSFSAMPLEMETADATAENTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CsfSampleMetadataEntry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CsfSampleMetadataEntry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CsfSampleMetadataEntry

% Last Modified by GUIDE v2.5 18-Mar-2016 09:15:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CsfSampleMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @CsfSampleMetadataEntry_OutputFcn, ...
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

% --- Executes just before CsfSampleMetadataEntry is made visible.
function CsfSampleMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CsfSampleMetadataEntry (see VARARGIN)

% Choose default command line output for CsfSampleMetadataEntry
handles.output = hObject;

% ************************************************************************************************************************************************
% INPUT: (suggestedSampleNumber, existingSampleNumbers, suggestedCsfSampleNumber, existingCsfSampleNumbers, userName, importPath, isEdit, sample*)
%        *may be empty
% ************************************************************************************************************************************************

if isa(varargin{1},'numeric');
    handles.suggestedSampleNumber = varargin{1}; %Parameter name is 'suggestedSampleNumber' from Eye class function
else
    handles.suggestedSampleNumber = '';
end

handles.existingSampleNumbers = varargin{2};

if isa(varargin{3},'numeric');
    handles.suggestedCsfSampleNumber = varargin{3}; %Parameter name is 'suggestedEyeNumber' from Eye class function
else
    handles.suggestedCsfSampleNumber = '';
end

handles.existingCsfSampleNumbers = varargin{4};
handles.userName = varargin{5};% Parameter name is 'userName'
handles.importPath = varargin{6}; % Parameter name is 'importPath'

isEdit = varargin{7};

sample = [];

if length(varargin) > 7
    sample = varargin{8};
end

if isempty(sample)
    sample = CsfSample;
end

handles.cancel = false;

if isEdit
    set(handles.OK, 'enable', 'on');
    
    set(handles.importPathDisplay, 'Visible', 'off');
    set(handles.importPathTitle, 'Visible', 'off')

    handles.amountMl = sample.amountMl;
    handles.csfSampleNumber = sample.csfSampleNumber;
    handles.sampleNumber = sample.sampleNumber;
    handles.storageTemp = sample.storageTemp;
    handles.storageLocation = sample.storageLocation;
    handles.source = sample.source;
    handles.timeOfRemoval = sample.timeOfRemoval;
    handles.timeOfProcessing = sample.timeOfProcessing;
    handles.dateReceived = sample.dateReceived;
    handles.notes = sample.notes;
else
    defaultSample = CsfSample;
    
    set(handles.OK, 'enable', 'off');
    
    set(handles.importPathDisplay, 'String', handles.importPath);
    
    handles.amountMl = defaultSample.amountMl;
    handles.csfSampleNumber = handles.suggestedCsfSampleNumber;
    handles.sampleNumber = handles.suggestedSampleNumber;
    handles.storageTemp = defaultSample.storageTemp;
    handles.storageLocation = defaultSample.storageLocation;
    handles.source = defaultSample.source;
    handles.timeOfRemoval = defaultSample.timeOfRemoval;
    handles.timeOfProcessing = defaultSample.timeOfProcessing;
    handles.dateReceived = defaultSample.dateReceived;
    handles.notes = defaultSample.notes;
end

% ** SET TEXT FIELDS **

set(handles.amountInput, 'String', num2str(handles.amountMl));
set(handles.csfSampleNumberInput, 'String', num2str(handles.csfSampleNumber));
set(handles.sampleNumberInput, 'String', num2str(handles.sampleNumber));
set(handles.storageTempInput, 'String', num2str(handles.storageTemp));
set(handles.storageLocationInput, 'String', handles.storageLocation);
set(handles.csfNotesInput, 'String', handles.notes);

justDate = true;

setDateInput(handles.timeOfRemovalDisplay, handles.timeOfRemoval, ~justDate);
setDateInput(handles.timeOfProcessingDisplay, handles.timeOfProcessing, ~justDate);
setDateInput(handles.dateReceivedDisplay, handles.dateReceived, justDate);

% ** SET POP UP MENUS **

defaultString = 'Select a Sample Source';
[sourceTypeChoices, ~] = choicesFromEnum('TissueSampleSourceTypes');
selectedChoice = handles.source;
setPopUpMenu(handles.sampleSourceList, defaultString, sourceTypeChoices, selectedChoice);
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CsfSampleMetadataEntry wait for user response (see UIRESUME)
uiwait(handles.CsfSampleMetadataEntry);

end

% --- Outputs from this function are returned to the command line.
function varargout = CsfSampleMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%**************************************************************************************************************************************************************************************************************************
%OUTPUT: [cancel, amountMl, csfSampleNumber, sampleNumber, storageTemp, storageLocation, source, timeOfRemoval, timeOfProcessing, dateReceived, notes]
%**************************************************************************************************************************************************************************************************************************

varargout{1} = handles.cancel;
varargout{2} = handles.amountMl;
varargout{3} = handles.csfSampleNumber;
varargout{4} = handles.sampleNumber;
varargout{5} = handles.storageTemp;
varargout{6} = handles.storageLocation;
varargout{7} = handles.source;
varargout{8} = handles.timeOfRemoval;
varargout{9} = handles.timeOfProcessing;
varargout{10} = handles.dateReceived;
varargout{11} = handles.notes;

close(handles.CsfSampleMetadataEntry);
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


function amountInput_Callback(hObject, eventdata, handles)
% hObject    handle to amountInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amountInput as text
%        str2double(get(hObject,'String')) returns contents of amountInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.amountInput, 'String', '');
    handles.amountMl = [];
    
    warndlg('Sample amount must be numerical.', 'Sample amount Error', 'modal'); 
    
else
    handles.amountMl = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function amountInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amountInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function csfSampleNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to csfSampleNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of csfSampleNumberInput as text
%        str2double(get(hObject,'String')) returns contents of csfSampleNumberInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.csfSampleNumberInput, 'String', '');
    handles.csfSampleNumber = [];
    
    warndlg('CSF Sample Number must be numerical.', 'CSF Sample Number Error', 'modal'); 
    
else
    handles.csfSampleNumber = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function csfSampleNumberInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to csfSampleNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
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


function storageTempInput_Callback(hObject, eventdata, handles)
% hObject    handle to storageTempInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of storageTempInput as text
%        str2double(get(hObject,'String')) returns contents of storageTempInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.storageTempInput, 'String', '');
    handles.eyeNumber = [];
    
    warndlg('Storage Temperature must be numerical.', 'Storage Temperature Error', 'modal'); 
    
else
    handles.storageTemp = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function storageTempInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to storageTempInput (see GCBO)
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

%Get value from input box
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

% --- Executes on selection change in sampleSourceList.
function sampleSourceList_Callback(hObject, eventdata, handles)
% hObject    handle to sampleSourceList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sampleSourceList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sampleSourceList

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
function sampleSourceList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleSourceList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


function csfNotesInput_Callback(hObject, eventdata, handles)
% hObject    handle to csfNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of csfNotesInput as text
%        str2double(get(hObject,'String')) returns contents of csfNotesInput as a double

%Get value from input box
handles.notes = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);


end

% --- Executes during object creation, after setting all properties.
function csfNotesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to csfNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
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
        handles.amountMl = [];
        handles.csfSampleNumber = [];
        handles.sampleNumber = [];
        handles.storageTemp = [];
        handles.storageLocation = '';
        handles.source = [];
        handles.timeOfRemoval = [];
        handles.timeOfProcessing = [];
        handles.dateReceived = [];
        handles.notes = '';
        guidata(hObject, handles);
        uiresume(handles.CsfSampleMetadataEntry);
    case 'No'
end

end

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
uiresume(handles.CsfSampleMetadataEntry);

end


% --- Executes when user attempts to close CsfSampleMetadataEntry.
function CsfSampleMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to CsfSampleMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    handles.cancel = true;
    handles.amountMl = [];
    handles.csfSampleNumber = [];
    handles.sampleNumber = [];
    handles.storageTemp = [];
    handles.storageLocation = '';
    handles.source = [];
    handles.timeOfRemoval = [];
    handles.timeOfProcessing = [];
    handles.dateReceived = [];
    handles.notes = '';
    guidata(hObject, handles);
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    handles.cancel = true;
    handles.amountMl = [];
    handles.csfSampleNumber = [];
    handles.sampleNumber = [];
    handles.storageTemp = [];
    handles.storageLocation = '';
    handles.source = [];
    handles.timeOfRemoval = [];
    handles.timeOfProcessing = [];
    handles.dateReceived = [];
    handles.notes = '';
    delete(hObject);
end

end

%% Local Functions

function checkToEnableOkButton(handles)

%This function will check to see if any of the input variables are empty,
%and if not it will enable the OK button

if ~isempty(handles.amountMl) && ~isempty(handles.csfSampleNumber) && ~isempty(handles.sampleNumber) && ~isempty(handles.storageTemp) && ~isempty(handles.storageLocation) && ~isempty(handles.source) && ~isempty(handles.timeOfRemoval) && ~isempty(handles.timeOfProcessing) && ~isempty(handles.dateReceived)
    set(handles.OK, 'enable', 'on');
else
    set(handles.OK, 'enable', 'off');
end

end

