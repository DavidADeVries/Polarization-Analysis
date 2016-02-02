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

% Last Modified by GUIDE v2.5 02-Feb-2016 10:24:22

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

%Input arguments from function call in Eye class function
handles.EyeArg = varargin{1};
handles.suggestedEyeNumber = num2str(varargin{2});

%Set default Eye number based on input to function
set(handles.EyeNumberInput, 'String', handles.suggestedEyeNumber);

% Update handles structure
guidata(hObject, handles);

%Get choice strings from EyeTypes class
[~, choiceStrings] = choicesFromEnum('EyeTypes');

%Setting the list values for the Eye Type pop up menu
choiceList = {'Select an Eye Type:'};
choiceList{2} = choiceStrings{1};
choiceList{3} = choiceStrings{2};
choiceList{4} = choiceStrings{3};
set(handles.EyeTypeList, 'String', choiceList);

%Defining the different input variables as empty, awaiting user input
handles.EyeID = '';
handles.EyeTypeChoice = '';
handles.EyeNumber = [];
handles.DissectionDate = '';
handles.DissectionDoneBy = '';
handles.EyeNotes = '';
        
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

% Get default command line output from handles structure
handles.output = {handles.EyeID, handles.EyeTypeChoice, handles.EyeNumber, handles.DissectionDate, handles.DissectionDoneBy, handles.EyeNotes};
varargout{1} = handles.output;
close(handles.EyeMetadataEntry);
end



function EyeIDInput_Callback(hObject, eventdata, handles)
% hObject    handle to EyeIDInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EyeIDInput as text
%        str2double(get(hObject,'String')) returns contents of EyeIDInput as a double

%Get value from input box
handles.EyeID = get(hObject, 'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function EyeIDInput_CreateFcn(hObject, eventdata, handles)
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
function EyeTypeList_Callback(hObject, eventdata, handles)
% hObject    handle to EyeTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EyeTypeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EyeTypeList

%Set the list of choices for the popupmenu



[choices, ~] = choicesFromEnum('EyeTypes');

%Get value from popup list
contents = cellstr(get(hObject,'String'));
handles.EyeTypeChoice = contents{get(hObject,'Value')};

%Check if value is default value
if isequal(handles.EyeTypeChoice, 'Select an Eye Type:')
    handles.EyeTypeChoice = '';
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
end

function EyeTypeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EyeTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function EyeNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to EyeNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EyeNumberInput as text
%        str2double(get(hObject,'String')) returns contents of EyeNumberInput as a double

%Get value from input box
handles.EyeNumber = str2double(get(hObject, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function EyeNumberInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EyeNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function DissectionDateInput_Callback(hObject, eventdata, handles)
% hObject    handle to DissectionDateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DissectionDateInput as text
%        str2double(get(hObject,'String')) returns contents of DissectionDateInput as a double

%Get value from input box
handles.DissectionDate = get(hObject, 'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function DissectionDateInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DissectionDateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function DissectionDoneBy_Callback(hObject, eventdata, handles)
% hObject    handle to DissectionDoneBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DissectionDoneBy as text
%        str2double(get(hObject,'String')) returns contents of DissectionDoneBy as a double

%Get value from input box
handles.DissectionDoneBy = get(hObject, 'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function DissectionDoneBy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DissectionDoneBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function EyeNotesInput_Callback(hObject, eventdata, handles)
% hObject    handle to EyeNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EyeNotesInput as text
%        str2double(get(hObject,'String')) returns contents of EyeNotesInput as a double

%Get value from input box
handles.EyeNotes = strjoin(rot90(cellstr(get(hObject, 'String'))));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end

function EyeNotesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EyeNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes when user attempts to close EyeMetadataEntry.
function EyeMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to EyeMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
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
        handles.EyeID = '';
        handles.EyeTypeChoice = '';
        handles.EyeNumber = [];
        handles.Dissectiondate = '';
        handles.DissectionDoneBy = '';
        handles.EyeNotes = '';
        guidata(hObject, handles);
        uiresume(handles.EyeMetadataEntry);
    case 'No'
end
end
