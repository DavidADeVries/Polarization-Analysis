function [ ] = importData(hObject, eventdata, handles)
%import_data
% raw data taken from an images (CSLO, microscope) is added to the project
% database.
% Steps include:
% - user entering metadata
% - data copied over and organized
% - auto raw data backups made

% prompt user to select folder for a SUBJECT (aka dog, human, or growth
% trial)

start = 'C:\';
title = 'Select Subject Folder';

importDir = uigetdir(start, title);

if importDir ~= 0 %dir successfully selected
    project = handles.localProject;
    
    project = project.importData(handles, importDir);
    
    handles.localProject = project;
end
    

end

