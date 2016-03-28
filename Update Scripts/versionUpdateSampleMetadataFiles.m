function [] = versionUpdateSampleMetadataFiles(projectPath, toPath)
%updateSample

% ** READ IN METADATA FILE **

vars = load(makePath(projectPath, toPath, 'eye_metadata.mat'), Constants.METADATA_VAR);
metadata = vars.metadata;

if isa(metadata, 'Eye')
    
    % ** UPDATE REQUIRED INFORMATION **
    
    metadata.uuid = generateUUID();
    
    entry = MetadataHistoryEntry;
    
    entry.userName = metadata.metadataHistory{1}.userName;
    entry.timestamp = metadata.metadataHistory{1}.timestamp;
    entry.cachedObject = Eye.empty;
    
    metadata.metadataHistory = entry;
    
    metadata.initialFixativePercent = [];
    metadata.initialFixingTime = [];
    
    metadata.secondaryFixativePercent = [];
    metadata.secondaryFixingTime = [];
    
    metadata.timeOfRemoval = [];
    metadata.timeOfProcessing = [];
    metadata.dateReceived = [];
    
    metadata.sampleNumber = metadata.eyeNumber;
    
    % ** SAVE IT **
    
    metadataFilename = SampleNamingConventions.METADATA_FILENAME;
    saveToBackup = true;
    
    saveObjectMetadata(metadata, projectPath, toPath, metadataFilename, saveToBackup);
    
    delete(makePath(projectPath, toPath, 'eye_metadata.mat'));
    delete(makePath(projectPath, Constants.BACKUP_DIR, toPath, 'eye_metadata.mat'));
    
    % ** RECURSE ON NEXT LEVEL **
    
    folders = getAllFolders(makePath(projectPath, toPath));
    
    for i=1:length(folders)
        versionUpdateQuarterMetadataFiles(projectPath, makePath(toPath, folders{i}));
    end
else
    error(['Unknown class at: ', toPath]);
end

end