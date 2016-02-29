function [] = guiInitialize(hObject, eventdata, handles, varargin)
% guiInitialize
% gets the GUI and handles ready for action

% *****************************************
% INPUT: (location, locationDescriptorText)
% *****************************************

handles.location = varargin{1};
set(handles.locationDescriptorText, 'String', varargin{2});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SubsectionSelectionGui wait for user response (see UIRESUME)
uiwait(handles.subsectionSelectionGui);

end

