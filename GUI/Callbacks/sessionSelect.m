function [] = sessionSelect(hObject, eventdata, handles)
% sessionSelect
% performs updates on naviagation listboxes after a session is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateSessionIndex(index);

handles = project.updateNavigationListboxes(handles);

handles.localProject = project;

guidata(hObject, handles);

end

