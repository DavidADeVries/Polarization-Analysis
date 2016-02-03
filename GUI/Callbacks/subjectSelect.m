function [] = subjectSelect(hObject, eventdata, handles)
% subjectSelect
% performs updates on naviagation listboxes after a subject is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateSubjectIndex(index);

handles = project.updateNavigationListboxes(handles);

handles.localProject = project;

guidata(hObject, handles);

end

