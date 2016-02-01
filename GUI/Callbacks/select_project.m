function [ ] = select_project(hObject, eventdata, handles)
%select_project
%   allows the user to select the project that they wish to work on
%   a directory is selected, from which appropriate metadata is gathered
%   and data is found

title = 'Select Project Directory (Shared/Backed-up Drive Recommended)';

folderName = uigetdir('C:\', title);

if folderName ~= 0 % folder has been successfully selected
    metadata_path = makePath(folderName, ProjectNamingConventions.METADATA_FILENAME);
    
    if exist(metadata_path, 'file') %check if metadata file exists    
        %load project metadata
        project = Project;
        
        project = project.loadProject(folderName);
        
        handles.project = project;
        
        handles.projectDirectory = folderName;
        
        set(handles.projectDirectoryLabel, 'String', folderName);
         
        guidata(hObject, handles); %update variables
    else %an project directory with no metadata was selected
        error = 'The directory selected is not a valid project directory. Please select a directory that contains a project metadata file or create the appropriate metadata file.';
        error_name = 'Invalid Project Directory';
        
       errordlg(error, error_name, 'modal'); 
    end
    
    
end


end

