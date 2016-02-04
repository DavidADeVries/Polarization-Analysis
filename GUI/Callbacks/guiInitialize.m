function handles = guiInitialize(handles)
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

% clear out image axes
imshow([], [], 'Parent', handles.imageAxes);

% prompt user to enter in name

prompt = 'Please enter user''s name (e.g. John Smith):';
title = 'Enter User''s Name';

userName = '';

while isempty(userName)
    response = inputdlg(prompt, title);
    
    if ~isempty(response)
        userName = response{1};
    end
end

handles.userName = userName;

set(handles.userNameTextbox, 'String', userName);

end

