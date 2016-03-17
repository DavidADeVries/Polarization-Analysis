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

% Last Modified by GUIDE v2.5 17-Mar-2016 15:23:22

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


% --- Executes just before CsfSampleMetadataEntry is made visible.
function CsfSampleMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CsfSampleMetadataEntry (see VARARGIN)

% Choose default command line output for CsfSampleMetadataEntry
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CsfSampleMetadataEntry wait for user response (see UIRESUME)
% uiwait(handles.CsfSampleMetadataEntry);


% --- Outputs from this function are returned to the command line.
function varargout = CsfSampleMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function importPathDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to importPathDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of importPathDisplay as text
%        str2double(get(hObject,'String')) returns contents of importPathDisplay as a double


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



function amountInput_Callback(hObject, eventdata, handles)
% hObject    handle to amountInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amountInput as text
%        str2double(get(hObject,'String')) returns contents of amountInput as a double


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



function csfSampleNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to csfSampleNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of csfSampleNumberInput as text
%        str2double(get(hObject,'String')) returns contents of csfSampleNumberInput as a double


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



function sampleNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to sampleNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampleNumberInput as text
%        str2double(get(hObject,'String')) returns contents of sampleNumberInput as a double


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



function storageTempInput_Callback(hObject, eventdata, handles)
% hObject    handle to storageTempInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of storageTempInput as text
%        str2double(get(hObject,'String')) returns contents of storageTempInput as a double


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



function storageLocationInput_Callback(hObject, eventdata, handles)
% hObject    handle to storageLocationInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of storageLocationInput as text
%        str2double(get(hObject,'String')) returns contents of storageLocationInput as a double


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


% --- Executes on selection change in sampleSourceList.
function sampleSourceList_Callback(hObject, eventdata, handles)
% hObject    handle to sampleSourceList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sampleSourceList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sampleSourceList


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



function timeOfRemovalDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to timeOfRemovalDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeOfRemovalDisplay as text
%        str2double(get(hObject,'String')) returns contents of timeOfRemovalDisplay as a double


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



function timeOfProcessingDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to timeOfProcessingDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeOfProcessingDisplay as text
%        str2double(get(hObject,'String')) returns contents of timeOfProcessingDisplay as a double


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



function dateReceivedDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to dateReceivedDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dateReceivedDisplay as text
%        str2double(get(hObject,'String')) returns contents of dateReceivedDisplay as a double


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
