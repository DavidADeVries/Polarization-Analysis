function [] = editProjectMetadata(hObject, eventdata, handles)
% editProjectMetadata callback

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

project = project.editProjectMetadata(projectPath, userName);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);

end

