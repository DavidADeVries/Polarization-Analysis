function [] = versionUpdateQuarterMetadataFiles(projectPath, toPath)
%updateQuarter

% % ** READ IN METADATA FILE **
% 
% vars = load(makePath(projectPath, toPath, 'quarter_metadata.mat'), Constants.METADATA_VAR);
% metadata = vars.metadata;
% 
% 
% % ** UPDATE REQUIRED INFORMATION **
% 
% 
% 
% % ** SAVE IT **
% 
% metadataFilename = QuarterNamingConventions.METADATA_FILENAME;
% saveToBackup = true;
% 
% saveObjectMetadata(metadata, projectPath, toPath, metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

folders = getAllFolders(makePath(projectPath, toPath));

for i=1:length(folders)
    versionUpdateLocationMetadataFiles(projectPath, makePath(toPath, folders{i}));
end

end



