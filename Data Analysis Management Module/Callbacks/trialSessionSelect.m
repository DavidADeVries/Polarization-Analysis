function [] = trialSessionSelect(hObject, eventdata, handles)
% trialSessionSelect
% performs updates on naviagation listboxes after a trial session is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateTrialSessionIndex(index);

handles = project.updateNavigationListboxes(handles);

handles = project.updateMetadataFields(handles);

handles.localProject = project;

guidata(hObject, handles);

end

