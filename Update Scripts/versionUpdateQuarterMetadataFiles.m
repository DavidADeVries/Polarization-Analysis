function [] = versionUpdateQuarterMetadataFiles(quarter, projectPath, toPath)
%updateQuarter

% ** UPDATE REQUIRED INFORMATION **

quarter.uuid = generateUUID();

quarter.metadataHistory = versionUpdateMetadataHistoryEntries(quarter.metadataHistory, Quarter.empty);

% ** SAVE IT **

metadataFilename = QuarterNamingConventions.METADATA_FILENAME;
saveToBackup = true;

toPath = makePath(toPath, quarter.dirName);

saveObjectMetadata(quarter, projectPath, toPath, metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

for i=1:length(quarter.locations)
    versionUpdateLocationMetadataFiles(quarter.locations{i}, projectPath, toPath);
end

end

