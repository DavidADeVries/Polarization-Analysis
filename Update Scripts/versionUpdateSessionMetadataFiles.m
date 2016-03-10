function [] = versionUpdateSessionMetadataFiles(session, projectPath, toPath)
%updateSession

% ** UPDATE REQUIRED INFORMATION **

session.uuid = generateUUID();

if isa(session, 'MicroscopeSession')
    session.metadataHistory = versionUpdateMetadataHistoryEntries(session.metadataHistory, MicroscopeSession.empty);
elseif isa(session, 'LegacyRegistrationSession')
    session.metadataHistory = versionUpdateMetadataHistoryEntries(session.metadataHistory, LegacyRegistrationSession.empty);
elseif isa(session, 'LegacySubsectionSelectionSession')
    session.metadataHistory = versionUpdateMetadataHistoryEntries(session.metadataHistory, LegacySubsectionSelectionSession.empty);
else
    error('Unknown Class!');
end

% ** SAVE IT **

metadataFilename = SessionNamingConventions.METADATA_FILENAME;
saveToBackup = true;

toPath = makePath(toPath, session.dirName);

saveObjectMetadata(session, projectPath, toPath, metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

% N/A

end

