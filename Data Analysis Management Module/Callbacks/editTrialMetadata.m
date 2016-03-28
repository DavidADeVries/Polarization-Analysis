function [] = editTrialMetadata(hObject, eventdata, handles)
% editTrialMetadata callback

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

project = project.editSelectedTrialMetadata(projectPath, userName);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);

end

