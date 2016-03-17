function [] = newCsloSession(hObject, eventdata, handles)
%newCsloSession

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

sessionType = SessionTypes.CSLO;

project = project.createNewSession(projectPath, userName, sessionType);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);


end

