function [] = trialSelect(hObject, eventdata, handles)
% trialSelect
% performs updates on naviagation listboxes after a trial is selected

index = get(hObject, 'Value');

project = handles.localProject;

project = project.updateTrialIndex(index);

handles = project.updateNavigationListboxes(handles);

handles.localProject = project;

guidata(hObject, handles);

end

