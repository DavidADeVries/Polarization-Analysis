function [] = eyeSelect(hObject, eventdata, handles)
% eyeSelect
% performs updates on naviagation listboxes after a eye is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateEyeIndex(index);

handles = project.updateNavigationListboxes(handles);
handles = project.updateMetadataFields(handles);

handles.localProject = project;

guidata(hObject, handles);

end

