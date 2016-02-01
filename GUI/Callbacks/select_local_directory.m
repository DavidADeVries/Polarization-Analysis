function [ ] = select_local_directory(hObject, eventdata, handles)
%select_local_directory(
%   allows the user to select the directory on their local machine to use
%   as a "working directory"
%   the projectDirectory will be used as the end all back-up of all data,
%   but this working directory will be used as a place to copy files down
%   to for faster manipulation/viewing

title = 'Select Local Directory (Sub-Directory of C:\ Recommended)';

folder_name = uigetdir('C:\', title);

if folder_name ~= 0 % folder has been successfully selected
    set(handles.localDirectoryLabel, 'String', folder_name);
    
    handles.localDirectory = folder_name;
    
    guidata(hObject, handles);
    
    
end


end


