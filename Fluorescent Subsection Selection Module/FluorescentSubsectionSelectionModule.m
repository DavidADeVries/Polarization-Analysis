function varargout = FluorescentSubsectionSelectionModule(varargin)
% FLUORESCENTSUBSECTIONSELECTIONMODULE MATLAB code for FluorescentSubsectionSelectionModule.fig
%      FLUORESCENTSUBSECTIONSELECTIONMODULE, by itself, creates a new FLUORESCENTSUBSECTIONSELECTIONMODULE or raises the existing
%      singleton*.
%
%      H = FLUORESCENTSUBSECTIONSELECTIONMODULE returns the handle to a new FLUORESCENTSUBSECTIONSELECTIONMODULE or the handle to
%      the existing singleton*.
%
%      FLUORESCENTSUBSECTIONSELECTIONMODULE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLUORESCENTSUBSECTIONSELECTIONMODULE.M with the given input arguments.
%
%      FLUORESCENTSUBSECTIONSELECTIONMODULE('Property','Value',...) creates a new FLUORESCENTSUBSECTIONSELECTIONMODULE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FluorescentSubsectionSelectionModule_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FluorescentSubsectionSelectionModule_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FluorescentSubsectionSelectionModule

% Last Modified by GUIDE v2.5 02-Jun-2016 09:53:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FluorescentSubsectionSelectionModule_OpeningFcn, ...
                   'gui_OutputFcn',  @FluorescentSubsectionSelectionModule_OutputFcn, ...
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


% --- Executes just before FluorescentSubsectionSelectionModule is made visible.
function FluorescentSubsectionSelectionModule_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FluorescentSubsectionSelectionModule (see VARARGIN)

% *******************************************************
% INPUT: (polarimetryImages, filenames, fluorsecentImage)
% *******************************************************

handles.polarimetryImages = varargin{1};
handles.filenames = varargin{2};
handles.fluorescentImage = varargin{3};

handles.fluorescentMask = createFluorescentMask(handles.fluorescentImage);
handles.showMask = false;

handles.xShift = 0;
handles.yShift = 0;
handles.rotAngle = 0;

handles.zoomOn = false;
handles.panOn = false;

handles.polarimetryImageIndex = 1;
handles.displayFluorescentImage = false;

handles.shiftDelta = 10;
handles.rotationDelta = 0.1;

handles.imageCache = handles.fluorescentImage;

set(handles.shiftInput, 'String', num2str(handles.shiftDelta));
set(handles.rotateInput, 'String', num2str(handles.rotationDelta));

handles.cancel = false;

useCache = false;
handles = updateImageAxes(handles, useCache);

set(handles.polarimetryImageSelect, 'String', handles.filenames);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FluorescentSubsectionSelectionModule wait for user response (see UIRESUME)
uiwait(handles.FluorescentSubsectionSelectionModule);


% --- Outputs from this function are returned to the command line.
function varargout = FluorescentSubsectionSelectionModule_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ********************************************************************************
% OUTPUT: [cancel, transformParams, cropCoords, fluoroImage, fluoroMask, mmImages]
% ********************************************************************************

varargout{1} = handles.cancel;
varargout{2} = [handles.xShift, handles.yShift, handles.rotAngle];

cropCoords = calculateCropCoordinate(handles); %sometimes all images involved may have to be cropped

varargout{3} = cropCoords;

varargout{4} = getFinalFluorescenceImage(handles, cropCoords);

varargout{5} = getFinalFluorescenceMask(handles, cropCoords);

varargout{6} = getFinalPolarimetryImages(handles, cropCoords);

close(handles.FluorescentSubsectionSelectionModule);


% --- Executes on selection change in polarimetryImageSelect.
function polarimetryImageSelect_Callback(hObject, eventdata, handles)
% hObject    handle to polarimetryImageSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns polarimetryImageSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from polarimetryImageSelect

handles.polarimetryImageIndex = get(hObject,'Value');

updateImageAxes(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function polarimetryImageSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polarimetryImageSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.FluorescentSubsectionSelectionModule);

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
        
        guidata(hObject, handles);
        uiresume(handles.FluorescentSubsectionSelectionModule);
    case 'No'
end


% --- Executes on key press with focus on FluorescentSubsectionSelectionModule or any of its controls.
function FluorescentSubsectionSelectionModule_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to FluorescentSubsectionSelectionModule (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = eventdata.Key;

validOp = true;

switch key
    case 'leftarrow'
        handles.xShift = handles.xShift - handles.shiftDelta;  
        useCache = false;
        handles.displayFluorescentImage = true;
    case 'rightarrow'
        handles.xShift = handles.xShift + handles.shiftDelta;
        useCache = false;
        handles.displayFluorescentImage = true;
    case 'uparrow'
        handles.yShift = handles.yShift - handles.shiftDelta;
        useCache = false;
        handles.displayFluorescentImage = true;
    case 'downarrow'
        handles.yShift = handles.yShift + handles.shiftDelta;
        useCache = false;
        handles.displayFluorescentImage = true;
    case 'period' %that is, '>'
        handles.rotAngle = handles.rotAngle - handles.rotationDelta;
        useCache = false;
        handles.displayFluorescentImage = true;
    case 'comma' %that is, '<'
        handles.rotAngle = handles.rotAngle + handles.rotationDelta;
        useCache = false;
        handles.displayFluorescentImage = true;
    case 'space'
        handles.displayFluorescentImage = ~handles.displayFluorescentImage;
        useCache = true;
    otherwise
        validOp = false;
end

if validOp
    handles = updateImageAxes(handles, useCache);

    guidata(hObject, handles);
end
    



function shiftInput_Callback(hObject, eventdata, handles)
% hObject    handle to shiftInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shiftInput as text
%        str2double(get(hObject,'String')) returns contents of shiftInput as a double

handles.shiftDelta = str2double(get(hObject,'String'));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function shiftInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shiftInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotateInput_Callback(hObject, eventdata, handles)
% hObject    handle to rotateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotateInput as text
%        str2double(get(hObject,'String')) returns contents of rotateInput as a double

handles.rotationDelta = str2double(get(hObject,'String'));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rotateInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotateInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when user attempts to close FluorescentSubsectionSelectionModule.
function FluorescentSubsectionSelectionModule_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to FluorescentSubsectionSelectionModule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

handles.cancel = true;
guidata(hObject, handles);

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end



% --------------------------------------------------------------------
function zoomIn_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to zoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pan, 'State', 'off');
handles.panOn = false;

pan off;

if handles.zoomOn
    zoom off;
    handles.zoomOn = false;
else
    zoom on;
    handles.zoomOn = true;
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function pan_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.zoomIn, 'State', 'off');
handles.zoomOn = false;

zoom off;

if handles.panOn
    pan off;
    handles.panOn = false;
else
    pan on;
    handles.panOn = true;
end

guidata(hObject, handles);


% --- Executes on button press in showMask.
function showMask_Callback(hObject, eventdata, handles)
% hObject    handle to showMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showMask

handles.showMask = get(hObject,'Value');

useCache = false;
handles = updateImageAxes(handles, useCache);

guidata(hObject, handles);



% *** HELPER FUNCTIONS ***


function handles = updateImageAxes(handles, useCache)

if handles.displayFluorescentImage
    if handles.showMask
        image = handles.fluorescentMask;
    else
        image = handles.fluorescentImage;
    end
    
    refImage = handles.polarimetryImages{handles.polarimetryImageIndex};
    
    if useCache
        image = handles.imageCache;
    else
        [image, ~] = applyTransforms(image, handles.xShift, handles.yShift, handles.rotAngle, refImage);
        
        handles.imageCache = image;
    end
else
    image = handles.polarimetryImages{handles.polarimetryImageIndex};
end

imshow(image, [0,1], 'Parent', handles.imageAxes);


function cropCoords = calculateCropCoordinate(handles)

refImage = handles.polarimetryImages{handles.polarimetryImageIndex};

[~, fillMap] = applyTransforms(handles.fluorescentImage, handles.xShift, handles.yShift, handles.rotAngle, refImage);

colDoesNotHaveFill = any(~fillMap, 1);
rowDoesNotHaveFill = any(~fillMap, 2);

dims = size(fillMap);

for i=1:dims(2)
    if colDoesNotHaveFill(i)
        leftBound = i;
        break;
    end
end

for i=dims(2):-1:1
    if colDoesNotHaveFill(i)
        rightBound = i;
        break;
    end
end

for i=1:dims(1)
    if rowDoesNotHaveFill(i)
        topBound = i;
        break;
    end
end

for i=dims(1):-1:1
    if rowDoesNotHaveFill(i)
        bottomBound = i;
        break;
    end
end

cropCoords = [leftBound, topBound, rightBound - leftBound, bottomBound - topBound];

% now need to account for rotation

if handles.rotAngle ~= 0
    tempFillMapCrop = imcrop(fillMap, cropCoords);
    
    if handles.rotAngle > 0
        % left bound
        for i=1:cropCoords(3)
            if ~tempFillMapCrop(1,i)
                newLeftBound = leftBound + i;
                break;
            end
        end
        % right bound
        for i=cropCoords(3):-1:1
            if ~tempFillMapCrop(cropCoords(4),i)
                newRightBound = leftBound + i;
                break;
            end
        end
        % top bound
        for i=1:cropCoords(4)
            if ~tempFillMapCrop(i,cropCoords(3))
                newTopBound = topBound + i;
                break;
            end
        end
        % bottom bound
        for i=cropCoords(4):-1:1
            if ~tempFillMapCrop(i,1)
                newBottomBound = bottomBound + i;
                break;
            end
        end
        
    elseif handles.rotAngle < 0
        % left bound
        for i=1:cropCoords(3)
            if ~tempFillMapCrop(cropCoords(4),i)
                newLeftBound = leftBound + i;
                break;
            end
        end
        % right bound
        for i=cropCoords(3):-1:1
            if ~tempFillMapCrop(1,i)
                newRightBound = leftBound + i;
                break;
            end
        end
        % top bound
        for i=1:cropCoords(4)
            if ~tempFillMapCrop(i,1)
                newTopBound = topBound + i;
                break;
            end
        end
        % bottom bound
        for i=cropCoords(4):-1:1
            if ~tempFillMapCrop(i,cropCoords(3))
                newBottomBound = bottomBound + i;
                break;
            end
        end
        
    end
    
    cropCoords = [newLeftBound, newTopBound, newRightBound - newLeftBound, newBottomBound - newTopBound];
end


function finalImage = getFinalFluorescenceImage(handles, cropCoords)

image = handles.fluorescentImage;
refImage = handles.polarimetryImages{handles.polarimetryImageIndex};

[transformedImage, ~] = applyTransforms(image, handles.xShift, handles.yShift, handles.rotAngle, refImage);

finalImage = imcrop(transformedImage, cropCoords);


function finalImage = getFinalFluorescenceMask(handles, cropCoords)

image = handles.fluorescentMask;
refImage = handles.polarimetryImages{handles.polarimetryImageIndex};

[transformedImage, ~] = applyTransforms(image, handles.xShift, handles.yShift, handles.rotAngle, refImage);

finalImage = imcrop(transformedImage, cropCoords);


function finalImages = getFinalPolarimetryImages(handles, cropCoords)

images = handles.polarimetryImages;

for i=1:length(images)
    finalImages{i} = imcrop(images{i}, cropCoords);
end


