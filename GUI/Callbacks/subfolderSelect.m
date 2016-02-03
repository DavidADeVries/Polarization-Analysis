function [] = subfolderSelect(hObject, eventdata, handles)
% subfolderSelect
% performs updates on naviagation listboxes after a subfolder is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateSubfolderIndex(index);

handles = project.updateNavigationListboxes(handles);

handles.localProject = project;

guidata(hObject, handles);


end

