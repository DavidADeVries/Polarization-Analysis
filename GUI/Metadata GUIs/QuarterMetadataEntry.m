function varargout = QuarterMetadataEntry(varargin)
% QUARTERMETADATAENTRY MATLAB code for QuarterMetadataEntry.fig
%      QUARTERMETADATAENTRY, by itself, creates a new QUARTERMETADATAENTRY or raises the existing
%      singleton*.
%
%      H = QUARTERMETADATAENTRY returns the handle to a new QUARTERMETADATAENTRY or the handle to
%      the existing singleton*.
%
%      QUARTERMETADATAENTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUARTERMETADATAENTRY.M with the given input arguments.
%
%      QUARTERMETADATAENTRY('Property','Value',...) creates a new QUARTERMETADATAENTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QuarterMetadataEntry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QuarterMetadataEntry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QuarterMetadataEntry

% Last Modified by GUIDE v2.5 16-Feb-2016 12:20:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QuarterMetadataEntry_OpeningFcn, ...
                   'gui_OutputFcn',  @QuarterMetadataEntry_OutputFcn, ...
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

% --- Executes just before QuarterMetadataEntry is made visible.
function QuarterMetadataEntry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QuarterMetadataEntry (see VARARGIN)

% Choose default command line output for QuarterMetadataEntry
handles.output = hObject;

% *****************************************************************************
% INPUT: (suggestedQuarterNumber, existingQuarterNumbers, importPath, userName)
% *****************************************************************************

if isa(varargin{1},'numeric');
    handles.suggestedQuarterNumber = num2str(varargin{1}); %Parameter name is 'suggestedQuarterNumber' from Quarter class function
else
    handles.suggestedQuarterNumber = '';
end

handles.existingQuarterNumbers = varargin{2};
handles.importPath = varargin{3};
handles.userName = varargin{4};

handles.cancel = false;

%Defining the default input variables, awaiting user input
handles.stain = '';
handles.slideMaterial = '';
handles.quarterType = [];
handles.quarterArbitrary = 0;
handles.quarterNumber = str2double(handles.suggestedQuarterNumber);
handles.fixingDate = '';
handles.fixingDoneBy = handles.userName;
handles.quarterNotes = '';

%Get choice strings from EyeTypes class
[~, choiceStrings] = choicesFromEnum('QuarterTypes');

%Default choice list setting
handles.choiceListDefault = 'Select a Quarter Type';

%Setting the list values for the Quarter Type pop up menu
choiceList = {handles.choiceListDefault};
for i = 1:size(choiceStrings)
    choiceList{i+1} = choiceStrings{i};
end

set(handles.quarterTypeMenu, 'String', choiceList);


%Setting default values for input boxes and radio buttons on GUI
set(handles.importPathDisplay, 'String', handles.importPath);
set(handles.fixingDoneByInput, 'String', handles.userName);
set(handles.arbitraryLabelsButton, 'Value', 0);
set(handles.trueLabelsButton, 'Value', 1);
set(handles.OK, 'enable', 'off');
set(handles.quarterNumberInput, 'String', handles.suggestedQuarterNumber);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QuarterMetadataEntry wait for user response (see UIRESUME)
uiwait(handles.quarterMetadataEntry);
end

% --- Outputs from this function are returned to the command line.
function varargout = QuarterMetadataEntry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% *********************************************************************************************************************
% OUTPUT: [cancel, stain, slideMaterial, quarterType, quarterArbitrary, quarterNumber, fixingDate, fixingDoneBy, notes]
% *********************************************************************************************************************

% Outputting the different quarter Metadata values
varargout{1} = handles.cancel;
varargout{2} = handles.stain;
varargout{3} = handles.slideMaterial;
varargout{4} = handles.quarterType;
varargout{5} = handles.quarterArbitrary;
varargout{6} = handles.quarterNumber;
varargout{7} = handles.fixingDate;
varargout{8} = handles.fixingDoneBy;
varargout{9} = handles.quarterNotes;

close(handles.quarterMetadataEntry);
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



function quarterStainInput_Callback(hObject, eventdata, handles)
% hObject    handle to quarterStainInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quarterStainInput as text
%        str2double(get(hObject,'String')) returns contents of quarterStainInput as a double

handles.stain = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function quarterStainInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quarterStainInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function slideMaterialInput_Callback(hObject, eventdata, handles)
% hObject    handle to slideMaterialInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slideMaterialInput as text
%        str2double(get(hObject,'String')) returns contents of slideMaterialInput as a double

handles.slideMaterial = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);


end

% --- Executes during object creation, after setting all properties.
function slideMaterialInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slideMaterialInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in quarterTypeMenu.
function quarterTypeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to quarterTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns quarterTypeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from quarterTypeMenu

[choices, ~] = choicesFromEnum('QuarterTypes');


% Check if value is default value
if get(hObject, 'Value') == 1 
    handles.quarterType = [];
else
    handles.quarterType = choices(get(hObject, 'Value')-1); 
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function quarterTypeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quarterTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function quarterNumberInput_Callback(hObject, eventdata, handles)
% hObject    handle to quarterNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quarterNumberInput as text
%        str2double(get(hObject,'String')) returns contents of quarterNumberInput as a double

%Get value from input box
if isnan(str2double(get(hObject, 'String')))
    
    set(handles.quarterNumberInput, 'String', '');
    handles.quarterNumber = [];
    
    warndlg('Quarter Number must be numerical.', 'Quarter Number Error', 'modal'); 
    
else
    handles.quarterNumber = str2double(get(hObject, 'String'));
end

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function quarterNumberInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quarterNumberInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function fixingDateInput_Callback(hObject, eventdata, handles)
% hObject    handle to fixingDateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixingDateInput as text
%        str2double(get(hObject,'String')) returns contents of fixingDateInput as a double

end

% --- Executes during object creation, after setting all properties.
function fixingDateInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixingDateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function fixingDoneByInput_Callback(hObject, eventdata, handles)
% hObject    handle to fixingDoneByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixingDoneByInput as text
%        str2double(get(hObject,'String')) returns contents of fixingDoneByInput as a double

handles.fixingDoneBy = get(hObject, 'String');

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function fixingDoneByInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixingDoneByInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function quarterNotesInput_Callback(hObject, eventdata, handles)
% hObject    handle to quarterNotesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quarterNotesInput as text
%        str2double(get(hObject,'String')) returns contents of quarterNotesInput as a double

%Get value from input box
handles.quarterNotes = strjoin(rot90(cellstr(get(hObject, 'String'))));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function quarterNotesInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quarterNotesInput (see GCBO)
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
        
        handles.stain = '';
        handles.slideMaterial = '';
        handles.quarterType = [];
        handles.quarterArbitrary = [];
        handles.quarterNumber = [];
        handles.fixingDate = '';
        handles.fixingDoneBy = '';
        handles.quarterNotes = '';
        guidata(hObject, handles);
        uiresume(handles.quarterMetadataEntry);
    case 'No'
end

end

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
uiresume(handles.quarterMetadataEntry);

end

% --- Executes on button press in trueLabelsButton.
function trueLabelsButton_Callback(hObject, eventdata, handles)
% hObject    handle to trueLabelsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trueLabelsButton

set(handles.trueLabelsButton, 'Value', 1);

handles.quarterArbitrary = false;

set(handles.arbitraryLabelsButton, 'Value', 0);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes on button press in arbitraryLabelsButton.
function arbitraryLabelsButton_Callback(hObject, eventdata, handles)
% hObject    handle to arbitraryLabelsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of arbitraryLabelsButton

set(handles.trueLabelsButton, 'Value', 0);

handles.quarterArbitrary = true;

set(handles.arbitraryLabelsButton, 'Value', 1);

checkToEnableOkButton(handles);

guidata(hObject, handles);

end

% --- Executes when user attempts to close quarterMetadataEntry.
function quarterMetadataEntry_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to quarterMetadataEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    %Clears variables in the case that they wish to exit the program
    handles.cancel = true;
    handles.stain = '';
    handles.slideMaterial = '';
    handles.quarterType = [];
    handles.quarterArbitrary = [];
    handles.quarterNumber = [];
    handles.fixingDate = '';
    handles.fixingDoneBy = '';
    handles.quarterNotes = '';
    guidata(hObject, handles);
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    %Clears variables in the case that they wish to exit the program
    handles.cancel = true;
    handles.stain = '';
    handles.slideMaterial = '';
    handles.quarterType = [];
    handles.quarterArbitrary = [];
    handles.quarterNumber = [];
    handles.fixingDate = '';
    handles.fixingDoneBy = '';
    handles.quarterNotes = '';
    guidata(hObject, handles);
    delete(hObject);
end

end

% --- Executes on button press in pickFixingDate.
function pickFixingDate_Callback(hObject, eventdata, handles)
% hObject    handle to pickFixingDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

serialDate = guiDatePicker(now);

handles.fixingDate = serialDate;
set(handles.fixingDateInput, 'String', displayDate(serialDate));

checkToEnableOkButton(handles);

guidata(hObject, handles);

end
%% Local Functions

function checkToEnableOkButton(handles)

%This function will check to see if any of the input variables are empty,
%and if not it will enable the OK button

if ~isempty(handles.stain) && ~isempty(handles.slideMaterial) && ~isempty(handles.quarterType) && ~isempty(handles.quarterArbitrary) && ~isempty(handles.quarterNumber) && ~isempty(handles.fixingDate) && ~isempty(handles.fixingDoneBy)
    set(handles.OK, 'enable', 'on');
else
    set(handles.OK, 'enable', 'off');
end

end





