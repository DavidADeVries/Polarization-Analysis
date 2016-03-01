function [] = editSessionMetadata(hObject, eventdata, handles)
% editSessionMetadata callback

project = handles.localProject;

userName = handles.userName;
updateBackupFiles = true;
projectPath = handles.localPath;

project = project.editSelectedSessionMetadata(projectPath, userName, updateBackupFiles);

handles.localProject = project;

guidata(hObject, handles);

end

