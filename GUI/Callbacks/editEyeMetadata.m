function [] = editEyeMetadata(hObject, eventdata, handles)
% editEyeMetadata callback

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

project = project.editSelectedEyeMetadata(projectPath, userName);

handles.localProject = project;

handles = project.updateMetadataFields(handles);

guidata(hObject, handles);

end

