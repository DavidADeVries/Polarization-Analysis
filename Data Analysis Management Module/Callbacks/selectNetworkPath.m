function [ ] = selectNetworkPath(hObject, eventdata, handles)
%selectNetworkPath
%   allows the user to select the project that they wish to work on
%   a directory is selected, from which appropriate metadata is gathered
%   and data is found

title = 'Select Network Directory (Sub-Directory of Y:\ Recommended)';

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
    else %a project directory with no metadata was selected
        prompt = 'The network project directory selected did not contain any project data. Would you like to still use this directory as your network project directory? You will have to uplink a local project in order to setup a project in this network directory.';
        title = 'Network Project Directory';
        yes = 'Yes';
        no = 'No';
        default = yes;
        
        button = questdlg(prompt, title, yes, no, default);
        
        if strcmp(button, yes)
            handles.networkPath = networkPath;
            handles.networkProject = Project; %empty project
            
            set(handles.networkDirectoryLabel, 'String', networkPath);
            
            guidata(hObject, handles);
        end     
        
    end   
    
end


end

