function [] = versionUpdateTrialMetadataFiles(trial, projectPath)
%updateTrial

% ** UPDATE REQUIRED INFORMATION **

trial.uuid = generateUUID();

trial.metadataHistory = versionUpdateMetadataHistoryEntries(trial.metadataHistory, Trial.empty);

% ** SAVE IT **

metadataFilename = TrialNamingConventions.METADATA_FILENAME;
saveToBackup = true;

toTrialPath = trial.dirName;

saveObjectMetadata(trial, projectPath, toTrialPath, metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

for i=1:length(trial.subjects)
    versionUpdateSubjectMetadataFiles(trial.subjects{i}, projectPath, toTrialPath);
end

end

