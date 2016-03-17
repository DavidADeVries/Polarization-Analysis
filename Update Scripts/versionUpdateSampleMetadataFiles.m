function [] = versionUpdateSampleMetadataFiles(projectPath, toPath)
%updateSample

% ** READ IN METADATA FILE **

% vars = load(makePath(projectPath, toPath, 'sample_metadata.mat'), Constants.METADATA_VAR);
% metadata = vars.metadata;
%     
% % ** UPDATE REQUIRED INFORMATION **
% 
% 
% 
% % ** SAVE IT **
% 
% metadataFilename = SampleNamingConventions.METADATA_FILENAME;
% saveToBackup = true;
% 
% saveObjectMetadata(metadata, projectPath, toPath, metadataFilename, saveToBackup);

% ** RECURSE ON NEXT LEVEL **

folders = getAllFolders(makePath(projectPath, toPath));

for i=1:length(folders)
    versionUpdateQuarterMetadataFiles(projectPath, makePath(toPath, folders{i}));
end

end