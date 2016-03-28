function [] = newQuarter(hObject, eventdata, handles)
%newQuarter

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

project = project.createNewQuarter(projectPath, userName);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);


end

