function [] = versionUpdateSessionMetadataFiles(projectPath, toPath)
%updateLocation

% ** READ IN METADATA FILE **

vars = load(makePath(projectPath, toPath, 'session_metadata.mat'), Constants.METADATA_VAR);
metadata = vars.metadata;


% ** UPDATE REQUIRED INFORMATION **

metadata.uuid = generateUUID();

entry = MetadataHistoryEntry;

entry.userName = metadata.metadataHistory{1}.userName;
entry.timestamp = metadata.metadataHistory{1}.timestamp;

if isa(metadata, 'MicroscopeSession')
    emptyObject = MicroscopeSession.empty;
elseif isa(metadata, 'LegacyRegistrationSession')
    emptyObject = LegacyRegistrationSession.empty;
elseif isa(metadata, 'LegacySubsectionSelectionSession')
    emptyObject = LegacySubsectionSelectionSession.empty;
else
    error('Unknown Class!');
end

entry.cachedObject = emptyObject;

metadata.metadataHistory = entry;

% ** SAVE IT **

metadataFilename = SessionNamingConventions.METADATA_FILENAME;
saveToBackup = true;

saveObjectMetadata(metadata, projectPath, toPath, metadataFilename, saveToBackup);


end


