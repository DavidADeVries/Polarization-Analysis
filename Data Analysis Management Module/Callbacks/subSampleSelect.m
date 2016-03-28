function [] = subSampleSelect(hObject, eventdata, handles)
% subSampleSelect
% performs updates on naviagation listboxes after a subsample is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateSubSampleIndex(index);

handles = project.updateNavigationListboxes(handles);

handles = project.updateMetadataFields(handles);

handles.localProject = project;

guidata(hObject, handles);

end

