function [] = editSessionMetadata(hObject, eventdata, handles)
% editSessionMetadata callback

project = handles.localProject;

userName = handles.userName;
updateBackupFiles = true;
projectPath = handles.localPath;

project = project.editSelectedSessionMetadata(projectPath, userName, updateBackupFiles);

handles.localProject = project;

handles = project.updateMetadataFields(handles);

guidata(hObject, handles);

end

