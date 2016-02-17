function [] = locationSelect(hObject, eventdata, handles)
% locationSelect
% performs updates on naviagation listboxes after a location is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateLocationIndex(index);

handles = project.updateNavigationListboxes(handles);

handles = project.updateMetadataFields(handles);

handles.localProject = project;

guidata(hObject, handles);

end

