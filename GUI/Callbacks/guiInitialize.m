function [handles, quitApp] = guiInitialize(handles)
% guiInitialize 
% initializes handles variables and GUI elements

% default GUI values
handles.networkPath = '';
handles.localPath = '';

handles.networkProject = []; %stores project metadata
handles.localProject = [];

handles.image = [];

% initialize GUI elements

% disable listboxes
disableNavigationListboxes(handles, handles.trialSelect);

% disable metadataFields
disableMetadataFields(handles, handles.trialMetadata);

% clear out image axes
imshow([], [], 'Parent', handles.imageAxes);

% prompt user to enter in name

prompt = 'Please enter user''s name (e.g. John Smith):';
title = 'Enter User''s Name';

userName = '';
quitApp = false;

while isempty(userName)
    response = inputdlg(prompt, title);
    
    if ~isempty(response)
        userName = response{1};
    else
        exit;
    end
end

handles.userName = userName;

set(handles.userNameTextbox, 'String', userName);

end

