function varargout = SubsectionSelectionGui(varargin)
% SUBSECTIONSELECTIONGUI MATLAB code for SubsectionSelectionGui.fig
%      SUBSECTIONSELECTIONGUI, by itself, creates a new SUBSECTIONSELECTIONGUI or raises the existing
%      singleton*.
%
%      H = SUBSECTIONSELECTIONGUI returns the handle to a new SUBSECTIONSELECTIONGUI or the handle to
%      the existing singleton*.
%
%      SUBSECTIONSELECTIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUBSECTIONSELECTIONGUI.M with the given input arguments.
%
%      SUBSECTIONSELECTIONGUI('Property','Value',...) creates a new SUBSECTIONSELECTIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SubsectionSelectionGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SubsectionSelectionGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SubsectionSelectionGui

% Last Modified by GUIDE v2.5 29-Feb-2016 14:12:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SubsectionSelectionGui_OpeningFcn, ...
                   'gui_OutputFcn',  @SubsectionSelectionGui_OutputFcn, ...
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


% --- Executes just before SubsectionSelectionGui is made visible.
function SubsectionSelectionGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SubsectionSelectionGui (see VARARGIN)

% *****************************************
% INPUT: (location, locationDescriptorText)
% *****************************************



handles.location = varargin{1};
set(handles.locationDescriptorText, 'String', varargin{2});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SubsectionSelectionGui wait for user response (see UIRESUME)
uiwait(handles.subsectionSelectionGui);


% --- Outputs from this function are returned to the command line.
function varargout = SubsectionSelectionGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in sessionSelection.
function sessionSelection_Callback(hObject, eventdata, handles)
% hObject    handle to sessionSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sessionSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sessionSelection


% --- Executes during object creation, after setting all properties.
function sessionSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionSelection (see GCBO)
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


% --- Executes on selection change in subsectionSelect.
function subsectionSelect_Callback(hObject, eventdata, handles)
% hObject    handle to subsectionSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subsectionSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subsectionSelect


% --- Executes during object creation, after setting all properties.
function subsectionSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subsectionSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function subsectionMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to subsectionMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subsectionMetadata as text
%        str2double(get(hObject,'String')) returns contents of subsectionMetadata as a double


% --- Executes during object creation, after setting all properties.
function subsectionMetadata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subsectionMetadata (see GCBO)
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


% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
