function [] = newCsfSample(hObject, eventdata, handles)
%newCsfSample

project = handles.localProject;

userName = handles.userName;
projectPath = handles.localPath;

sampleType = SampleTypes.CsfSample;

project = project.createNewSample(projectPath, userName, sampleType);

handles.localProject = project;

handles = project.updateMetadataFields(handles);
handles = project.updateNavigationListboxes(handles);

guidata(hObject, handles);


end

