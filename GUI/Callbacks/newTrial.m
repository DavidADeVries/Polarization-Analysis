function [] = newTrial(hObject, eventdata, handles)
%newTrial

project = handles.localProject;

if ~isempty(project)
    project = project.createNewTrial(handles.localPath, handles.userName);
    
    handles.localProject = project;
    
    handles = project.updateMetadataFields(handles);
    handles = project.updateNavigationListboxes(handles);
    
    guidata(hObject, handles);
else
    warndlg('No project currently open. Please open or create a new project before adding a new trial.', 'No Project Open');
end



end

