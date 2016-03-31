function [] = polarizationAnalysisModule(hObject, eventdata, handles)
% polarizationAnalysisModule

project = handles.localProject;

if ~isempty(project) % can't create a new project if a new isn't loaded
    selectedTrial = project.getSelectedTrial();
    
    if ~isempty(selectedTrial)
        [cancel, project] = PolarizationAnalysisModule(handles.localProject, handles.localPath, handles.userName);
        
        if ~cancel
            handles.localProjcet = project;
            
            handles = project.updateMetadataFields(handles);
            handles = project.updateNavigationListboxes(handles);
            
            guidata(hObject, handles);
        end
    else
        warndlg('No trial selected for which to run polarization analysis on.', 'No Trial Selected');
    end
    
else
    warndlg('Please open a project to run analysis upon.', 'No Project Open');    
end

end

