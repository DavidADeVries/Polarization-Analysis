function [] = sampleSelect(hObject, eventdata, handles)
% sampleSelect
% performs updates on naviagation listboxes after a sample is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateSampleIndex(index);

handles = project.updateNavigationListboxes(handles);

handles = project.updateMetadataFields(handles);

handles.localProject = project;

guidata(hObject, handles);

end

