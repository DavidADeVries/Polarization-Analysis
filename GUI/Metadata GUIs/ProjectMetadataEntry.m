function varargout = ProjectMetadataEntry(varargin)
% PROJECTMETADATAENTRY MATLAB code for ProjectMetadataEntry.fig
%      PROJECTMETADATAENTRY, by itself, creates a new PROJECTMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = PROJECTMETADATAENTRY returns the handle to a new PROJECTMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      PROJECTMETADATAENTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECTMETADATAENTRY.M with the given input arguments.
%
%      PROJECTMETADATAENTRY('Property','Value',...) creates a new PROJECTMETADATAENTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProjectMetadataEntry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProjectMetadataEntry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProjectMetadataEntry

% Last Modified by GUIDE v2.5 17-Feb-2016 10:36:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProjectMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @ProjectMetadataEntry_OutputFcn, ...
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

% --- Executes just before ProjectMetadataEntry is made visible.
function ProjectMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProjectMetadataEntry (see VARARGIN)

% Choose default command line output for ProjectMetadataEntry
handles.output = hObject;

handles.projectTitle = '';
handles.projectDescription = '';
handles.projectNotes = '';
handles.cancel = false;

set(handles.OK, 'enable', 'off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ProjectMetadataEntry wait for user response (see UIRESUME)
uiwait(handles.projectMetadataEntry);
end

% --- Outputs from this function are returned to the command line.
function varargout = ProjectMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% *******************************************
% OUTPUT: [cancel, title, description, notes]
% *******************************************

% Get default command line output from handles structure
varargout{1} = handles.cancel;
varargout{2} = handles.projectTitle;
varargout{3} = handles.projectDescription;
varargout{4} = handles.projectNotes;

close(handles.projectMetadataEntry);
end


function projectTitleInput_Callback(hObject, eventdata, handles)
% hObject    handle to projectTitleInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectTitleInput as text
%        str2double(get(hObject,'String')) returns contents of projectTitleInput as a double

handles.projectTitle = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function projectTitleInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectTitleInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function projectDescriptionInput_Callback(hObject, eventdata, handles)
% hObject    handle to projectDescriptionInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectDescriptionInput as text
%        str2double(get(hObject,'String')) returns contents of projectDescriptionInput as a double

%Get value from input box
handles.projectDescription = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function projectDescriptionInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectDescriptionInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

end


function projectNotes_Callback(hObject, eventdata, handles)
% hObject    handle to projectNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectNotes as text
%        str2double(get(hObject,'String')) returns contents of projectNotes as a double

%Get value from input box
handles.projectNotes = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function projectNotes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectNotes (see GCBO)
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
        handles.projectTitle = '';
        handles.projectDescription = '';
        handles.projectNotes = '';
        guidata(hObject, handles);
        uiresume(handles.projectMetadataEntry);
    case 'No'
end

end

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
uiresume(handles.projectMetadataEntry);

end

% --- Executes when user attempts to close projectMetadataEntry.
function projectMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to projectMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    %Clears variables in the case that they wish to exit the program
    handles.cancel = true;        
    handles.projectTitle = '';
    handles.projectDescription = '';
    handles.projectNotes = '';
    guidata(hObject, handles);
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    %Clears variables in the case that they wish to exit the program
    handles.cancel = true;        
    handles.projectTitle = '';
    handles.projectDescription = '';
    handles.projectNotes = '';
    guidata(hObject, handles);
    delete(hObject);
end
end

%% Local Functions

function checkToEnableOkButton(handles)

%This function will check to see if any of the input variables are empty,
%and if not it will enable the OK button

if ~isempty(handles.projectTitle) && ~isempty(handles.projectDescription)
    set(handles.OK, 'enable', 'on');
else
    set(handles.OK, 'enable', 'off');
end

end



