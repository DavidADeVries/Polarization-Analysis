function [] = editLocationMetadata(hObject, eventdata, handles)
% editLocationMetadata callback

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

project = project.editSelectedLocationMetadata(projectPath, userName);

handles.localProject = project;

handles = project.updateMetadataFields(handles);

guidata(hObject, handles);

end

