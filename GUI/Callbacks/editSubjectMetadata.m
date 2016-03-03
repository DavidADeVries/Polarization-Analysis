function [] = editSubjectMetadata(hObject, eventdata, handles)
% editSubjectMetadata callback

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

project = project.editSelectedSubjectMetadata(projectPath, userName);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);

end

