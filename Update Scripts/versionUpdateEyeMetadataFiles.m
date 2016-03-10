function [] = versionUpdateEyeMetadataFiles(eye, projectPath, toPath)
%updateEye

% ** UPDATE REQUIRED INFORMATION **

eye.uuid = generateUUID();

eye.metadataHistory = versionUpdateMetadataHistoryEntries(eye.metadataHistory, Eye.empty);

% ** SAVE IT **

metadataFilename = EyeNamingConventions.METADATA_FILENAME;
saveToBackup = true;

toPath = makePath(toPath, eye.dirName);

saveObjectMetadata(eye, projectPath, toPath, metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

for i=1:length(eye.quarters)
    versionUpdateQuarterMetadataFiles(eye.quarters{i}, projectPath, toPath);
end

end

