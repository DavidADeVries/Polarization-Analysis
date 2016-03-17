function [] = newLegacyRegistrationSession(hObject, eventdata, handles)
%newLegacyRegistrationSession

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

sessionType = SessionTypes.LegacyRegistration;

project = project.createNewSession(projectPath, userName, sessionType);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);


end

