function varargout = TrialMetadataEntry(varargin)
% TRIALMETADATAENTRY MATLAB code for TrialMetadataEntry.fig
%      TRIALMETADATAENTRY, by itself, creates a new TRIALMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = TRIALMETADATAENTRY returns the handle to a new TRIALMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      TRIALMETADATAENTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRIALMETADATAENTRY.M with the given input arguments.
%
%      TRIALMETADATAENTRY('Property','Value',...) creates a new TRIALMETADATAENTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrialMetadataEntry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrialMetadataEntry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrialMetadataEntry

% Last Modified by GUIDE v2.5 08-Feb-2016 16:57:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrialMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @TrialMetadataEntry_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT

% --- Executes just before TrialMetadataEntry is made visible.
function TrialMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrialMetadataEntry (see VARARGIN)

% **********************************************************************
%INPUT: (suggestedTrialNumber, existingTrialNumbers, importPath, trial*)
%       *may be empty
% **********************************************************************

if isa(varargin{1},'numeric');
    handles.suggestedTrialNumber = num2str(varargin{1}); %Parameter name is 'suggestedTrialNumber' from Quarter class function
else
    handles.suggestedTrialNumber = '';
end

handles.existingTrialNumbers = varargin{2}; % the existing trial numbers
handles.importPath = varargin{3}; %Parameter name is 'importPath'

%Get choice strings from EyeTypes class
[~, choiceStrings] = choicesFromEnum('SubjectTypes');

%Default choice list setting
handles.choiceListDefault = 'Select a Subject Type';

%Setting the list values for the Eye Type pop up menu
choiceList = {handles.choiceListDefault};

for i = 1:size(choiceStrings)
    choiceList{i+1} = choiceStrings{i};
end

set(handles.subjectTypesMenu, 'String', choiceList);


if length(varargin) > 3
    handles.title = trial.title;
    handles.description = trial.description;
    handles.trialNumber = trial.trialNumber;
    handles.subjectType = trial.subjectType;
    handles.trialNotes = trial.notes;
    
    set(handles.importPathDisplay, 'String', 'None'); 
    set(handles.titleInput, 'String', handles.title);
    set(handles.descriptionInput, 'String', handles.description);
    set(handles.trialNotesInput, 'String', handles.trialNotes);
    set(handles.trialNumberInput, 'String', num2str(handles.trialNumber));
    
    matchString = handles.subjectType.displayString;
    
    for i=1:length(choiceStrings)
        if strcmp(matchString, choiceStrings{i})
            set(handles.subjectTypesMenu, 'Value', i+1);
            break;
        end
    end
    
    set(handles.OK, 'enable', 'on');
else
    handles.title = '';
    handles.description = '';
    handles.trialNumber = str2double(handles.suggestedTrialNumber);
    handles.subjectType = [];
    handles.trialNotes = '';
    
    set(handles.importPathDisplay, 'String', handles.importPath);
    set(handles.trialNumberInput, 'String', handles.suggestedTrialNumber);
    
    set(handles.OK, 'enable', 'off');
end


%Define default variables
handles.cancel = false;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrialMetadataEntry wait for user response (see UIRESUME)
uiwait(handles.trialMetadataEntry);
end

% --- Outputs from this function are returned to the command line.
function varargout = TrialMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% Output: [cancel, title, description, trialNumber, subjectType, trialNotes]

%Output variables
varargout{1} = handles.cancel;
varargout{2} = handles.title;
varargout{3} = handles.description;
varargout{4} = handles.trialNumber;
varargout{5} = handles.subjectType;
varargout{6} = handles.trialNotes;

close(handles.trialMetadataEntry);
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


function titleInput_Callback(hObject, eventdata, handles)
% hObject    handle to titleInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of titleInput as text
%        str2double(get(hObject,'String')) returns contents of titleInput as a double

%Get value from input box
handles.title = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function titleInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to titleInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function descriptionInput_Callback(hObject, eventdata, handles)
% hObject    handle to descriptionInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of descriptionInput as text
%        str2double(get(hObject,'String')) returns contents of descriptionInput as a double

%Get value from input box
handles.description = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);


end

% --- Executes during object creation, after setting all properties.
function descriptionInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to descriptionInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

end


function trialNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to trialNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trialNumberInput as text
%        str2double(get(hObject,'String')) returns contents of trialNumberInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.trialNumberInput, 'String', '');
    handles.trialNumber = [];
    
    warndlg('Trial Number must be numerical.', 'Trial Number Error', 'modal'); 
    
else
    handles.trialNumber = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function trialNumberInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function trialNotesInput_Callback(hObject, eventdata, handles)
% hObject    handle to trialNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trialNotesInput as text
%        str2double(get(hObject,'String')) returns contents of trialNotesInput as a double

%Get value from input box
handles.trialNotes = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function trialNotesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialNotesInput (see GCBO)
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
exit = questdlg('Are you sure you want to quit?','Quit','Yes','No','No'); 
switch exit
    case 'Yes'
        %Clears variables in the case that they wish to exit the program
        handles.cancel = true;
        handles.title = '';
        handles.description = '';
        handles.trialNumber = [];
        handles.subjectType = [];
        handles.trialNotes = '';
        guidata(hObject, handles);
        uiresume(handles.trialMetadataEntry);
    case 'No'
end

end

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);

uiresume(handles.trialMetadataEntry);

end


% --- Executes on selection change in subjectTypesMenu.
function subjectTypesMenu_Callback(hObject, eventdata, handles)
% hObject    handle to subjectTypesMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subjectTypesMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subjectTypesMenu

[choices, ~] = choicesFromEnum('SubjectTypes');


% Check if value is default value
if get(hObject, 'Value') == 1 
    handles.subjectType = [];
else
    handles.subjectType = choices(get(hObject, 'Value')-1); 
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function subjectTypesMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectTypesMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes when user attempts to close trialMetadataEntry.
function trialMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to trialMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    handles.cancel = true;
    handles.title = '';
    handles.description = '';
    handles.trialNumber = [];
    handles.subjectType = [];
    handles.trialNotes = '';
    guidata(hObject, handles);
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    handles.cancel = true;
    handles.title = '';
    handles.description = '';
    handles.trialNumber = [];
    handles.subjectType = [];
    handles.trialNotes = '';
    guidata(hObject, handles);
    delete(hObject);
end
end


%% Local Functions

function checkToEnableOkButton(handles)

%This function will check to see if any of the input variables are empty,
%and if not it will enable the OK button

if ~isempty(handles.title) && ~isempty(handles.description) && ~isempty(handles.trialNumber) && ~isempty(handles.subjectType)
    set(handles.OK, 'enable', 'on');
else
    set(handles.OK, 'enable', 'off');
end

end
