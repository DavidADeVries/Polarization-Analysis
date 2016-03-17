function [] = versionUpdateTrialMetadataFiles(projectPath, toPath)
%updateTrial

% ** READ IN METADATA FILE **

vars = load(makePath(projectPath, toPath, 'trial_metadata.mat'), Constants.METADATA_VAR);
metadata = vars.metadata;


% ** UPDATE REQUIRED INFORMATION **

metadata.uuid = generateUUID();

entry = MetadataHistoryEntry;

entry.userName = metadata.metadataHistory{1}.userName;
entry.timestamp = metadata.metadataHistory{1}.timestamp;
entry.cachedObject = Trial.empty;

metadata.metadataHistory = entry;

% ** SAVE IT **

metadataFilename = TrialNamingConventions.METADATA_FILENAME;
saveToBackup = true;

saveObjectMetadata(metadata, projectPath, toPath, metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

folders = getAllFolders(makePath(projectPath, toPath));

for i=1:length(folders)
    versionUpdateSubjectMetadataFiles(projectPath, makePath(toPath, folders{i}));
end

end



