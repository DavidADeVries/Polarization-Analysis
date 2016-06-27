function [] = sensitivityAndSpecificityAnalysisModule(hObject, eventdata, handles)
% sensitivityAndSpecificityAnalysisModule

project = handles.localProject;

if ~isempty(project) % can't create a new project if a new isn't loaded
    selectedTrial = project.getSelectedTrial();
    
    if ~isempty(selectedTrial)
        [cancel, project] = SensitivityAndSpecificityModule(handles.localProject, handles.localPath, handles.userName);
        
        if ~cancel
            handles.localProject = project;
            
            handles = project.updateMetadataFields(handles);
            handles = project.updateNavigationListboxes(handles);
            
            guidata(hObject, handles);
        end
    else
        warndlg('No trial selected for which to run analysis on.', 'No Trial Selected');
    end
    
else
    warndlg('Please open a project to run analysis upon.', 'No Project Open');    
end

end

