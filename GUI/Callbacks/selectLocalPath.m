function [ ] = selectLocalPath(hObject, eventdata, handles)
%selectLocalPath
%   allows the user to select the directory on their local machine to use
%   as a "working directory"
%   the projectDirectory will be used as the end all back-up of all data,
%   but this working directory will be used as a place to copy files down
%   to for faster manipulation/viewing

title = 'Select Local Directory (Sub-Directory of C:\ Recommended)';

localPath = uigetdir('C:\', title);

if localPath ~= 0 % folder has been successfully selected
    metadataPath = makePath(localPath, ProjectNamingConventions.METADATA_FILENAME);
    
    if exist(metadataPath, 'file') %check if metadata file exists    
        %load project metadata
        project = Project;
        
        project = project.loadProject(localPath);
        
        handles.localProject = project;
        
        handles.localPath = localPath;
        
        set(handles.localDirectoryLabel, 'String', localPath);
        
        % update list boxes
        handles.localProject.updateNavigationListboxes(handles);
         
        guidata(hObject, handles); %update variables
    else %an project directory with no metadata was selected
        error = 'The directory selected is not a valid project directory. Please select a directory that contains a project metadata file or create the appropriate metadata file.';
        error_name = 'Invalid Project Directory';
        
       errordlg(error, error_name, 'modal'); 
    end   
    
end


end


