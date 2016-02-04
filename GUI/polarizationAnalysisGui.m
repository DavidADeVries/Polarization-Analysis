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

% Last Modified by GUIDE v2.5 04-Feb-2016 10:56:11

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

%default GUI values
handles.networkPath = '';
handles.localPath = '';

handles.networkProject = []; %stores project metadata
handles.localProject = [];

handles.image = [];


% Choose default command line output for polarizationAnalysisGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes polarizationAnalysisGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = polarizationAnalysisGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectNetwork.
function selectNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to selectNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectNetworkPath(hObject, eventdata, handles);


% --- Executes on button press in selectLocalDirectory.
function selectLocalDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to selectLocalDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectLocalPath(hObject, eventdata, handles);


% --------------------------------------------------------------------
function importData_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to importData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

importData(hObject, eventdata, handles);

% --- Executes on button press in registerImages.
function registerImages_Callback(hObject, eventdata, handles)
% hObject    handle to registerImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in performAnalysis.
function performAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to performAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in performStats.
function performStats_Callback(hObject, eventdata, handles)
% hObject    handle to performStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function userName_Callback(hObject, eventdata, handles)
% hObject    handle to userName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of userName as text
%        str2double(get(hObject,'String')) returns contents of userName as a double


% --- Executes during object creation, after setting all properties.
function userName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to userName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
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


% --- Executes on selection change in eyeSelect.
function eyeSelect_Callback(hObject, eventdata, handles)
% hObject    handle to eyeSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns eyeSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eyeSelect

eyeSelect(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function eyeSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eyeSelect (see GCBO)
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


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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





% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


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
function eyeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to eyeMenu (see GCBO)
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
