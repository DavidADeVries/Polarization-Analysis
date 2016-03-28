function [] = importLegacyData(hObject, eventdata, handles)
% importLegacyData
% starts workflow for user to import legacy data

start = 'C:\';
title = 'Select Legacy Subject Directory';

subjectImportDir = uigetdir(start, title);

if subjectImportDir ~= 0 %dir successfully selected
    project = handles.localProject;
    
    project = project.importLegacyData(subjectImportDir, handles.localPath, handles.userName);
    
    handles.localProject = project;
    
    % update gui
    handles = project.updateNavigationListboxes(handles);
    handles = project.updateMetadataFields(handles);
    
    guidata(hObject, handles);
end


end

