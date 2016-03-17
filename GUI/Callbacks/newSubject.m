function [] = newSubject(hObject, eventdata, handles)
%newSubject

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

project = project.createNewSubject(projectPath, userName);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);

end

