function [] = versionUpdateProjectMetadataFiles(projectPath)
%updateProject

% % ** READ IN METADATA FILE **
% 
% vars = load(makePath(projectPath, 'project_metadata.mat'), Constants.METADATA_VAR);
% metadata = vars.metadata;
% 
% 
% % ** UPDATE REQUIRED INFORMATION **
% 
% 
% 
% % ** SAVE IT **
% 
% metadataFilename = ProjectNamingConventions.METADATA_FILENAME;
% saveToBackup = false;
% 
% saveObjectMetadata(metadata, projectPath, '', metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

folders = getAllFolders(projectPath);

for i=1:length(folders)
    if ~strcmp(folders{i}, Constants.BACKUP_DIR)
        versionUpdateTrialMetadataFiles(projectPath, folders{i});
    end
end

end

