function [ ] = selectNetworkPath(hObject, eventdata, handles)
%selectNetworkPath
%   allows the user to select the project that they wish to work on
%   a directory is selected, from which appropriate metadata is gathered
%   and data is found

title = 'Select Network Directory (Shared/Backed-up Drive Recommended)';

networkPath = uigetdir('C:\', title);

if networkPath ~= 0 % folder has been successfully selected
    metadataPath = makePath(networkPath, ProjectNamingConventions.METADATA_FILENAME);
    
    if exist(metadataPath, 'file') %check if metadata file exists    
        %load project metadata
        project = Project;
        
        project = project.loadProject(networkPath);
        
        handles.networkProject = project;
        
        handles.networkPath = networkPath;
        
        set(handles.networkDirectoryLabel, 'String', networkPath);
         
        guidata(hObject, handles); %update variables
    else %an project directory with no metadata was selected
        error = 'The directory selected is not a valid project directory. Please select a directory that contains a project metadata file or create the appropriate metadata file.';
        error_name = 'Invalid Project Directory';
        
       errordlg(error, error_name, 'modal'); 
    end   
    
end


end

