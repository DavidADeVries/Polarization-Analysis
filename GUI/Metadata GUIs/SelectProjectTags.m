function varargout = SelectProjectTags(varargin)
% SELECTPROJECTTAGS MATLAB code for SelectProjectTags.fig
%      SELECTPROJECTTAGS, by itself, creates a new SELECTPROJECTTAGS or raises the existing
%      singleton*.
%
%      H = SELECTPROJECTTAGS returns the handle to a new SELECTPROJECTTAGS or the handle to
%      the existing singleton*.
%
%      SELECTPROJECTTAGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTPROJECTTAGS.M with the given input arguments.
%
%      SELECTPROJECTTAGS('Property','Value',...) creates a new SELECTPROJECTTAGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SelectProjectTags_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SelectProjectTags_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SelectProjectTags

% Last Modified by GUIDE v2.5 28-Mar-2016 11:46:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SelectProjectTags_OpeningFcn, ...
                   'gui_OutputFcn',  @SelectProjectTags_OutputFcn, ...
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


% --- Executes just before SelectProjectTags is made visible.
function SelectProjectTags_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SelectProjectTags (see VARARGIN)

% ************************************************************************************************************************
% INPUT: (importPath, filenames, filenameExtensions, suggestedDirectoryName, suggestedDirectoryTag, suggestedFilenameTags)
% ************************************************************************************************************************

handles.importPath = varargin{1};
handles.filenames = varargin{2};
handles.extensionStrings = varargin{3};

handles.folderName = varargin{4};
handles.directoryTag = varargin{5};
handles.filenameTags = varargin{6};

handles.cancel = false;

set(handles.importPathText, 'String', handles.importPath);
set(handles.importFilenames, 'String', handles.filenames);
set(handles.extensions, 'String', handles.extensionStrings);

set(handles.folderNameInput, 'String', handles.folderName);
set(handles.tagInput, 'String', handles.directoryTag);
set(handles.filenameTagsInput, 'String', handles.filenameTags);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SelectProjectTags wait for user response (see UIRESUME)
uiwait(handles.SelectProjectTags);


% --- Outputs from this function are returned to the command line.
function varargout = SelectProjectTags_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ***********************************************************
% OUTPUT: [cancel, directoryName, directoryTag, filenameTags]
% ***********************************************************

% Get default command line output from handles structure
varargout{1} = handles.cancel;
varargout{2} = handles.folderName;
varargout{3} = handles.directoryTag;
varargout{4} = handles.filenameTags;


close(handles.SelectProjectTags);



function importPathText_Callback(hObject, eventdata, handles)
% hObject    handle to importPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of importPathText as text
%        str2double(get(hObject,'String')) returns contents of importPathText as a double

set(handles.importPathText, 'String', handles.importPath);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function importPathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to importPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function folderNameInput_Callback(hObject, eventdata, handles)
% hObject    handle to folderNameInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of folderNameInput as text
%        str2double(get(hObject,'String')) returns contents of folderNameInput as a double


% --- Executes during object creation, after setting all properties.
function folderNameInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to folderNameInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function importFilenames_Callback(hObject, eventdata, handles)
% hObject    handle to importFilenames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of importFilenames as text
%        str2double(get(hObject,'String')) returns contents of importFilenames as a double

set(handles.importFilenames, 'String', handles.filenames);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function importFilenames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to importFilenames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);



function filenameTagsInput_Callback(hObject, eventdata, handles)
% hObject    handle to filenameTagsInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filenameTagsInput as text
%        str2double(get(hObject,'String')) returns contents of filenameTagsInput as a double


% --- Executes during object creation, after setting all properties.
function filenameTagsInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenameTagsInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);


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
        
        handles.folderName = '';
        handles.directoryTag = '';
        handles.filenameTags = {};
        
        guidata(hObject, handles);
        uiresume(handles.SelectProjectTags);
    case 'No'
end


% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.folderName = get(handles.folderNameInput, 'String');
handles.directoryTag = get(handles.tagInput, 'String');
handles.filenameTags = get(handles.filenameTagsInput, 'String');

guidata(hObject, handles);
uiresume(handles.SelectProjectTags);

% --- Executes when user attempts to close SelectProjectTags.
function SelectProjectTags_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to SelectProjectTags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.cancel = true;
handles.folderName = '';
handles.directoryTag = '';
handles.filenameTags = {};

guidata(hObject, handles);

if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
else
    delete(hObject);
end




function tagInput_Callback(hObject, eventdata, handles)
% hObject    handle to tagInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tagInput as text
%        str2double(get(hObject,'String')) returns contents of tagInput as a double


% --- Executes during object creation, after setting all properties.
function tagInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tagInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function extensions_Callback(hObject, eventdata, handles)
% hObject    handle to extensions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of extensions as text
%        str2double(get(hObject,'String')) returns contents of extensions as a double

set(handles.extensions, 'String', handles.extensionStrings);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function extensions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to extensions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
