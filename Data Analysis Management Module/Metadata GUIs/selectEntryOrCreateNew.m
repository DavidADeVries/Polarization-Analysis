function varargout = selectEntryOrCreateNew(varargin)
% SELECTENTRYORCREATENEW MATLAB code for selectEntryOrCreateNew.fig
%      SELECTENTRYORCREATENEW by itself, creates a new SELECTENTRYORCREATENEW or raises the
%      existing singleton*.
%
%      H = SELECTENTRYORCREATENEW returns the handle to a new SELECTENTRYORCREATENEW or the handle to
%      the existing singleton*.
%
%      SELECTENTRYORCREATENEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTENTRYORCREATENEW.M with the given input arguments.
%
%      SELECTENTRYORCREATENEW('Property','Value',...) creates a new SELECTENTRYORCREATENEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selectEntryOrCreateNew_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selectEntryOrCreateNew_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectEntryOrCreateNew

% Last Modified by GUIDE v2.5 09-Feb-2016 10:54:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selectEntryOrCreateNew_OpeningFcn, ...
                   'gui_OutputFcn',  @selectEntryOrCreateNew_OutputFcn, ...
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

% --- Executes just before selectEntryOrCreateNew is made visible.
function selectEntryOrCreateNew_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectEntryOrCreateNew (see VARARGIN)

% read in varargin
promptString = varargin{1};
titleString = varargin{2};
choices = varargin{3};

% pop those into the handles
set(handles.selectEntryOrCreateNew, 'Name', titleString);
set(handles.promptString, 'String', promptString);

if isempty(choices)
    set(handles.choiceListbox, 'String', 'None Available', 'Enable', 'inactive');
    set(handles.useSelected, 'Enable', 'off');
    
    handles.choiceOutput = 0;
else
    set(handles.choiceListbox, 'String', choices);
    
    handles.choiceOutput = 1;
end

% set defaults for output
handles.cancelOutput = false;
handles.createNewOutput = false;

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.selectEntryOrCreateNew,'WindowStyle','modal')

% UIWAIT makes selectEntryOrCreateNew wait for user response (see UIRESUME)
uiwait(handles.selectEntryOrCreateNew);

% --- Outputs from this function are returned to the command line.
function varargout = selectEntryOrCreateNew_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% output: [choice, cancel, createNew]

varargout{1} = handles.choiceOutput;
varargout{2} = handles.cancelOutput;
varargout{3} = handles.createNewOutput;

% The figure can be deleted now
delete(handles.selectEntryOrCreateNew);


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.choiceOutput = 0;
handles.cancelOutput = true;
handles.createNewOutput = false;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.selectEntryOrCreateNew);


% --- Executes when user attempts to close selectEntryOrCreateNew.
function selectEntryOrCreateNew_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to selectEntryOrCreateNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on selection change in choiceListbox.
function choiceListbox_Callback(hObject, eventdata, handles)
% hObject    handle to choiceListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choiceListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choiceListbox


% --- Executes during object creation, after setting all properties.
function choiceListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choiceListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in createNew.
function createNew_Callback(hObject, eventdata, handles)
% hObject    handle to createNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.choiceOutput = 0;
handles.cancelOutput = false;
handles.createNewOutput = true;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.selectEntryOrCreateNew);


% --- Executes on button press in useSelected.
function useSelected_Callback(hObject, eventdata, handles)
% hObject    handle to useSelected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.choiceOutput = get(handles.choiceListbox, 'Value');
handles.cancelOutput = false;
handles.createNewOutput = false;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.selectEntryOrCreateNew);
