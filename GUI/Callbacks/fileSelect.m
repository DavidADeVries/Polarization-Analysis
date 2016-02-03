function [] = fileSelect(hObject, eventdata, handles)
% fileSelect
% performs updates on naviagation listboxes after an image is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateFileIndex(index);

handles = project.updateNavigationListboxes(handles); % still do this (image axes update is at the end of this)

handles.localProject = project;

guidata(hObject, handles);


end

