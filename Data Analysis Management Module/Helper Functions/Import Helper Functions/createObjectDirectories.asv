function [ ] = createObjectDirectories(projectDirectory, toPath, newDirectory, createBackup)
% createObjectDirectories
% creates needed directories for an object (subject, eye, location, etc.)


% create project directories
parentPath = makePath(projectDirectory, toPath);
mkdir(parentPath, newDirectory);

if createBackup
    % create backup directories
    parentPath = makePath(projectDirectory, Constants.BACKUP_DIR, toPath);
    mkdir(parentPath, newDirectory);
end


end

