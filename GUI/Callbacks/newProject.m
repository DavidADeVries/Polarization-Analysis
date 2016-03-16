function [] = newProject(hObject, eventdata, handles)
% newProject

if isempty(handles.localProject) % can't create a new project if a new isn't loaded
    if ~isempty(handles.localPath)
        handles.localProject = Project(handles.localPath, handles.userName);
        
        guidata(hObject, handles);
    else
        warndlg('No local project directory has been selected. Please select a directory to which to save your project.', 'No Project Directory Selected');
    end
    
else
    warndlg('A project already exists in the selected project directory. Please select a directory without an existing project.', 'Invalid Project Directory');    
end

end

