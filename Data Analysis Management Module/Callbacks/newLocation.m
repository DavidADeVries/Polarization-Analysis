function [] = newLocation(hObject, eventdata, handles)
%newLocation

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

project = project.createNewLocation(projectPath, userName);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);


end

