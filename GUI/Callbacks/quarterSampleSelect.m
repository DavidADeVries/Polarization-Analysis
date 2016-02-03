function [] = quarterSampleSelect(hObject, eventdata, handles)
% quarterSampleSelect
% performs updates on naviagation listboxes after a quarter/sample is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateQuarterSampleIndex(index);

handles = project.updateNavigationListboxes(handles);

handles.localProject = project;

guidata(hObject, handles);

end

