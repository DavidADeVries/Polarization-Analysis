function [] = versionUpdateLocationMetadataFiles(location, projectPath, toPath)
%updateLocation

% ** UPDATE REQUIRED INFORMATION **

location.uuid = generateUUID();

location.metadataHistory = versionUpdateMetadataHistoryEntries(location.metadataHistory, Location.empty);

% ** SAVE IT **

metadataFilename = LocationNamingConventions.METADATA_FILENAME;
saveToBackup = true;

toPath = makePath(toPath, location.dirName);

saveObjectMetadata(location, projectPath, toPath, metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

for i=1:length(location.sessions)
    versionUpdateSessionMetadataFiles(location.sessions{i}, projectPath, toPath);
end

end

