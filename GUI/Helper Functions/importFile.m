function [] = importFile(toFilePath, importPath, projectPath, importFilename, projectFilename)
% importFile
% imports a file, saving to project and back-up directories

source = makePath(importPath, importFilename);

% import to project directory

dest = makePath(projectPath, toFilePath, projectFilename);

try
    copyfile(source, dest);
catch
    error(['copyfile error: From "', source, '" to "', dest, '"']);
end

% import to back-up directory

dest = makePath(projectPath, Constants.BACKUP_DIR, toFilePath, projectFilename);

try
    copyfile(source, dest);
catch
    error(['copyfile error: From "', source, '" to "', dest, '"']);
end



end

