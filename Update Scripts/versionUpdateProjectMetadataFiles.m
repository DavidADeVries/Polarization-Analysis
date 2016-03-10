function [] = versionUpdateProjectMetadataFiles(project, projectPath)
%updateProject

% ** UPDATE REQUIRED INFORMATION **

project.uuid = generateUUID();

project.metadataHistory = versionUpdateMetadataHistoryEntries(project.metadataHistory, Project.empty);

% ** SAVE IT **

metadataFilename = ProjectNamingConventions.METADATA_FILENAME;
saveToBackup = false;

saveObjectMetadata(project, projectPath, '', metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

for i=1:length(project.trials)
    versionUpdateTrialMetadataFiles(project.trials{i}, projectPath);
end

end

