function [ ] = saveObjectMetadata(object, projectDir, localDir, toPath, metadataFilename, saveToBackup)
% saveObjectMetadata
% saves metadata file

metadata = object;

% wipe-out fields linked to other classes (these are restored
% when project is reopened by reading in metadata files)
metadata = metadata.wipeoutMetadataFields();

% save to project directory
filename = makePath(projectDir, toPath, metadataFilename);
save(filename, Constants.METADATA_VAR);

% save to local directory
filename = makePath(localDir, toPath, metadataFilename);
save(filename, Constants.METADATA_VAR);

% save to backup directory (if selected)
if saveToBackup
    filename = makePath(projectDir, Constants.BACKUP_DIR, toPath, metadataFilename);
    save(filename, Constants.METADATA_VAR);
end

end

