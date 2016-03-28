function [] = versionUpdateTrialMetadataFiles(projectPath, toPath)
%updateTrial

% % ** READ IN METADATA FILE **
% 
% vars = load(makePath(projectPath, toPath, 'trial_metadata.mat'), Constants.METADATA_VAR);
% metadata = vars.metadata;
% 
% 
% % ** UPDATE REQUIRED INFORMATION **
% 
% 
% 
% % ** SAVE IT **
% 
% metadataFilename = TrialNamingConventions.METADATA_FILENAME;
% saveToBackup = true;
% 
% saveObjectMetadata(metadata, projectPath, toPath, metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

folders = getAllFolders(makePath(projectPath, toPath));

for i=1:length(folders)
    versionUpdateSubjectMetadataFiles(projectPath, makePath(toPath, folders{i}));
end

end



