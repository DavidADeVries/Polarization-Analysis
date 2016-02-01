function [] = importFile(toFilePath, importPath, projectPath, localPath, importFilename, projectFilename)
% importFile
% imports a file, saving to project, local, and back-up directories

source = makePath(importPath, importFilename);

% import to project directory

dest = makePath(projectPath, toFilePath, projectFilename);
copyfile(source, dest);

% import to local directory

dest = makePath(localPath, toFilePath, projectFilename);
copyfile(source, dest);

% import to back-up directory

dest = makePath(projectPath, Constants.BACKUP_DIR, toFilePath, projectFilename);
copyfile(source, dest);


end

