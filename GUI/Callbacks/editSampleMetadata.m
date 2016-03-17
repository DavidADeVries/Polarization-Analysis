function [] = editSampleMetadata(hObject, eventdata, handles)
% editSampleMetadata callback

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

project = project.editSelectedSampleMetadata(projectPath, userName);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);

end

