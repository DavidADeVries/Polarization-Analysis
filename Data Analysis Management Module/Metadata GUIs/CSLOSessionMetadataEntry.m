function varargout = CSLOSessionMetadataEntry(varargin)
% CSLOSESSIONMETADATAENTRY MATLAB code for CSLOSessionMetadataEntry.fig
%      CSLOSESSIONMETADATAENTRY, by itself, creates a new CSLOSESSIONMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = CSLOSESSIONMETADATAENTRY returns the handle to a new CSLOSESSIONMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      CSLOSESSIONMETADATAENTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSLOSESSIONMETADATAENTRY.M with the given input arguments.
%
%      CSLOSESSIONMETADATAENTRY('Property','Value',...) creates a new CSLOSESSIONMETADATAENTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CSLOSessionMetadataEntry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CSLOSessionMetadataEntry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CSLOSessionMetadataEntry

% Last Modified by GUIDE v2.5 19-Feb-2016 10:10:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CSLOSessionMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @CSLOSessionMetadataEntry_OutputFcn, ...
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

% --- Executes just before CSLOSessionMetadataEntry is made visible.
function CSLOSessionMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CSLOSessionMetadataEntry (see VARARGIN)

% Choose default command line output for CSLOSessionMetadataEntry
handles.output = hObject;

% *****************************
% INPUT: (userName, importPath)
% *****************************

handles.userName = varargin{1}; %Param is userName
handles.importPath = varargin{2}; %Param is importPath

%Defining the different input variables, awaiting user input
handles.magnification = [];
handles.pixelSizeMicrons = [];
handles.instrument = '';
handles.entrancePinholeSizeMicrons = [];
handles.confocalPinholeSizeMicrons = [];
handles.lightLevelMicroWatts = [];
handles.fieldOfViewDegrees = [];
handles.imagingDate = [];
handles.imagingDoneBy = handles.userName;
handles.fluoroSignature = 0;
handles.crossedSignature = 0;
handles.visualSignature = 0;
handles.rejected = 0;
handles.rejectedReason = '';
handles.rejectedBy = '';
handles.sessionNotes = '';

handles.cancel = false;

set(handles.importPathDisplay, 'String', handles.importPath);
set(handles.imagingDoneByInput, 'String', handles.userName);
set(handles.yesRejected, 'Value', 0);
set(handles.noRejected, 'Value', 1);
set(handles.OK, 'enable', 'off');
set(handles.rejectedReasonInput, 'enable', 'off');
set(handles.rejectedByInput, 'enable', 'off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CSLOSessionMetadataEntry wait for user response (see UIRESUME)
uiwait(handles.CSLOSessionMetadataEntry);
end

% --- Outputs from this function are returned to the command line.
function varargout = CSLOSessionMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.cancel;
varargout{2} = handles.magnification;
varargout{3} = handles.pixelSizeMicrons;
varargout{4} = handles.instrument;
varargout{5} = handles.entrancePinholeSizeMicrons;
varargout{6} = handles.confocalPinholeSizeMicrons;
varargout{7} = handles.lightLevelMicroWatts;
varargout{8} = handles.fieldOfViewDegrees;
varargout{9} = handles.imagingDate;
varargout{10} = handles.imagingDoneBy;
varargout{11} = handles.fluoroSignature;
varargout{12} = handles.crossedSignature;
varargout{13} = handles.visualSignature;
varargout{14} = handles.rejected;
varargout{15} = handles.rejectedReason;
varargout{16} = handles.rejectedBy;
varargout{17} = handles.sessionNotes;

close(handles.CSLOSessionMetadataEntry);
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


function magnificationInput_Callback(hObject, eventdata, handles)
% hObject    handle to magnificationInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of magnificationInput as text
%        str2double(get(hObject,'String')) returns contents of magnificationInput as a double

if isnan(str2double(get(hObject, 'String')))
    
    set(handles.magnificationInput, 'String', '');
    handles.magnification = [];
    
    warndlg('Magnification must be numerical.', 'Magnification Error', 'modal'); 
    
else
    handles.magnification = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function magnificationInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to magnificationInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function pixelSizeInput_Callback(hObject, eventdata, handles)
% hObject    handle to pixelSizeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixelSizeInput as text
%        str2double(get(hObject,'String')) returns contents of pixelSizeInput as a double

if isnan(str2double(get(hObject, 'String')))
    
    set(handles.pixelSizeInput, 'String', '');
    handles.pixelSizeMicrons = [];
    
    warndlg('Pixel size must be numerical.', 'Pixel Size Error', 'modal'); 
    
else
    handles.pixelSizeMicrons = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function pixelSizeInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelSizeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function instrumentInput_Callback(hObject, eventdata, handles)
% hObject    handle to instrumentInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of instrumentInput as text
%        str2double(get(hObject,'String')) returns contents of instrumentInput as a double

handles.instrument = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function instrumentInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to instrumentInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function entrancePinholeInput_Callback(hObject, eventdata, handles)
% hObject    handle to entrancePinholeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of entrancePinholeInput as text
%        str2double(get(hObject,'String')) returns contents of entrancePinholeInput as a double

if isnan(str2double(get(hObject, 'String')))
    
    set(handles.entrancePinholeInput, 'String', '');
    handles.entrancePinholeSizeMicrons = [];
    
    warndlg('Entrance pinhole size must be numerical.', 'Pinhole Size Error', 'modal'); 
    
else
    handles.entrancePinholeSizeMicrons = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function entrancePinholeInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to entrancePinholeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function confocalPinholeSize_Callback(hObject, eventdata, handles)
% hObject    handle to confocalPinholeSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of confocalPinholeSize as text
%        str2double(get(hObject,'String')) returns contents of confocalPinholeSize as a double

if isnan(str2double(get(hObject, 'String')))
    
    set(handles.confocalPinholeInput, 'String', '');
    handles.confocalPinholeSizeMicrons = [];
    
    warndlg('Confocal pinhole size must be numerical.', 'Pinhole Size Error', 'modal'); 
    
else
    handles.confocalPinholeSizeMicrons = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);


end

% --- Executes during object creation, after setting all properties.
function confocalPinholeSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to confocalPinholeSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function lightLevelInput_Callback(hObject, eventdata, handles)
% hObject    handle to lightLevelInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lightLevelInput as text
%        str2double(get(hObject,'String')) returns contents of lightLevelInput as a double

if isnan(str2double(get(hObject, 'String')))
    
    set(handles.lightLevelInput, 'String', '');
    handles.lightLevelMicroWatts = [];
    
    warndlg('Laser Power must be numerical.', 'Laser Power Error', 'modal'); 
    
else
    handles.lightLevelMicroWatts = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function lightLevelInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lightLevelInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function fieldOfViewInput_Callback(hObject, eventdata, handles)
% hObject    handle to fieldOfViewInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldOfViewInput as text
%        str2double(get(hObject,'String')) returns contents of fieldOfViewInput as a double

if isnan(str2double(get(hObject, 'String')))
    
    set(handles.fieldOfViewInput, 'String', '');
    handles.fieldOfViewDegrees = [];
    
    warndlg('Field of view must be numerical.', 'Field of View Error', 'modal'); 
    
else
    handles.fieldOfViewDegrees = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function fieldOfViewInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldOfViewInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function imagingDateDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to imagingDateDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imagingDateDisplay as text
%        str2double(get(hObject,'String')) returns contents of imagingDateDisplay as a double
end

% --- Executes during object creation, after setting all properties.
function imagingDateDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagingDateDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in sessionDatePick.
function sessionDatePick_Callback(hObject, eventdata, handles)
% hObject    handle to sessionDatePick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

justDate = true;

serialDate = guiDatePicker(now, justDate);

handles.imagingDate = serialDate;

setDateInput(handles.imagingDateDisplay, serialDate, justDate);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end


function imagingDoneByInput_Callback(hObject, eventdata, handles)
% hObject    handle to imagingDoneByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imagingDoneByInput as text
%        str2double(get(hObject,'String')) returns contents of imagingDoneByInput as a double

handles.imagingDoneBy = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function imagingDoneByInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagingDoneByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function sessionNotesInput_Callback(hObject, eventdata, handles)
% hObject    handle to sessionNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sessionNotesInput as text
%        str2double(get(hObject,'String')) returns contents of sessionNotesInput as a double

handles.sessionNotes = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function sessionNotesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

end


function rejectedReasonInput_Callback(hObject, eventdata, handles)
% hObject    handle to rejectedReasonInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rejectedReasonInput as text
%        str2double(get(hObject,'String')) returns contents of rejectedReasonInput as a double

handles.rejectedReason = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function rejectedReasonInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rejectedReasonInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

enableLineScrolling(hObject);

end


function rejectedByInput_Callback(hObject, eventdata, handles)
% hObject    handle to rejectedByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rejectedByInput as text
%        str2double(get(hObject,'String')) returns contents of rejectedByInput as a double

handles.rejectedBy = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function rejectedByInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rejectedByInput (see GCBO)
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

exit = questdlg('Are you sure you want to quit?','Quit','Yes','No','No'); 
switch exit
    case 'Yes'
        %Clears variables in the case that they wish to exit the program
        handles.cancel = true;
        
        handles.magnification = [];
        handles.pixelSizeMicrons = [];
        handles.instrument = '';
        handles.entrancePinholeSizeMicrons = [];
        handles.confocalPinholeSizeMicrons = [];
        handles.lightLevelMicroWatts = [];
        handles.fieldOfViewDegrees = [];
        handles.imagingDate = [];
        handles.imagingDoneBy = '';
        handles.fluoroSignature = [];
        handles.crossedSignature = [];
        handles.visualSignature = [];
        handles.rejected = [];
        handles.rejectedReason = '';
        handles.rejectedBy = '';
        handles.sessionNotes = '';
        guidata(hObject, handles);
        uiresume(handles.CSLOSessionMetadataEntry);
    case 'No'
end


end

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
uiresume(handles.CSLOSessionMetadataEntry);

end

% --- Executes on button press in yesRejected.
function yesRejected_Callback(hObject, eventdata, handles)
% hObject    handle to yesRejected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yesRejected

set(handles.noRejected, 'Value', 0);

handles.rejected = true;

set(handles.yesRejected, 'Value', 1);

set(handles.rejectedReasonInput, 'enable', 'on');
set(handles.rejectedByInput, 'enable', 'on');


handles.rejectedBy = handles.userName;
set(handles.rejectedByInput, 'String', handles.userName);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in noRejected.
function noRejected_Callback(hObject, eventdata, handles)
% hObject    handle to noRejected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noRejected

set(handles.noRejected, 'Value', 1);

handles.rejected = false;

set(handles.yesRejected, 'Value', 0);

set(handles.rejectedReasonInput, 'enable', 'off');
set(handles.rejectedReasonInput, 'String', '');
set(handles.rejectedByInput, 'enable', 'off');
set(handles.rejectedByInput, 'String', '');

handles.rejectedReason = '';
handles.rejectedBy = '';

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in fluorescenceBox.
function fluorescenceBox_Callback(hObject, eventdata, handles)
% hObject    handle to fluorescenceBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fluorescenceBox

handles.fluoroSignature = get(hObject, 'Value');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in crossedBox.
function crossedBox_Callback(hObject, eventdata, handles)
% hObject    handle to crossedBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crossedBox

handles.crossedSignature = get(hObject, 'Value');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in visualBox.
function visualBox_Callback(hObject, eventdata, handles)
% hObject    handle to visualBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of visualBox

handles.visualSignature = get(hObject, 'Value');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes when user attempts to close CSLOSessionMetadataEntry.
function CSLOSessionMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to CSLOSessionMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    handles.cancel = true;
    handles.magnification = [];
    handles.pixelSizeMicrons = [];
    handles.instrument = '';
    handles.entrancePinholeSizeMicrons = [];
    handles.confocalPinholeSizeMicrons = [];
    handles.lightLevelMicroWatts = [];
    handles.fieldOfViewDegrees = [];
    handles.imagingDate = [];
    handles.imagingDoneBy = '';
    handles.fluoroSignature = [];
    handles.crossedSignature = [];
    handles.visualSignature = [];
    handles.rejected = [];
    handles.rejectedReason = '';
    handles.rejectedBy = '';
    handles.sessionNotes = '';
    guidata(hObject, handles);
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    handles.cancel = true;
    handles.magnification = [];
    handles.pixelSizeMicrons = [];
    handles.instrument = '';
    handles.entrancePinholeSizeMicrons = [];
    handles.confocalPinholeSizeMicrons = [];
    handles.lightLevelMicroWatts = [];
    handles.fieldOfViewDegrees = [];
    handles.imagingDate = [];
    handles.imagingDoneBy = '';
    handles.fluoroSignature = [];
    handles.crossedSignature = [];
    handles.visualSignature = [];
    handles.rejected = [];
    handles.rejectedReason = '';
    handles.rejectedBy = '';
    handles.sessionNotes = '';
    guidata(hObject, handles);
    delete(hObject);
end
end


%% Local Functions

function checkToEnableOkButton(handles)

%This function will check to see if any of the input variables are empty,
%and if not it will enable the OK button

if ~isempty(handles.magnification) && ~isempty(handles.pixelSizeMicrons) && ~isempty(handles.instrument) && ~isempty(handles.imagingDate) && ~isempty(handles.imagingDoneBy) && ~isempty(handles.rejected) && ~isempty(handles.entrancePinholeSizeMicrons) && ~isempty(handles.confocalPinholeSizeMicrons) && ~isempty(handles.lightLevelMicroWatts) && ~isempty(handles.fieldOfViewDegrees)
    if handles.rejected 
        if ~isempty(handles.rejectedReason) && ~isempty(handles.rejectedBy)
            set(handles.OK, 'enable', 'on');
        else
            set(handles.OK, 'enable', 'off');
        end
    else
        set(handles.OK, 'enable', 'on');
    end
else
    set(handles.OK, 'enable', 'off');
end

end
