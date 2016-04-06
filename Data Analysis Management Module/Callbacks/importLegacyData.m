function [] = importLegacyData(hObject, eventdata, handles)
% importLegacyData
% starts workflow for user to import legacy data

start = 'C:\';
title = 'Select Legacy Subject Directory';

subjectImportDir = uigetdir(start, title);

if subjectImportDir ~= 0 %dir successfully selected
    project = handles.localProject;
    
    handles = project.importLegacyData(subjectImportDir, handles);    
    
    % need to get the updated version of the project from within the
    % handles object
    project = handles.localProject;
    
    % update gui
    handles = project.updateNavigationListboxes(handles);
    handles = project.updateMetadataFields(handles);
    
    guidata(hObject, handles);
end


end

