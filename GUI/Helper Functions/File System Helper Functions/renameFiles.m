function [] = renameFiles(toPath, projectPath, dataFilename, oldFilenameSection, newFilenameSection, updateBackup)
%renameFiles

if ~strcmp(oldFilenameSection, newFilenameSection)
    
    text = 'Renaming data files. Please wait.';
    title = 'Renaming Files';
    
    waitHandle = popupMessage(text, title);
    
    path = makePath(projectPath, toPath);
    
    renameFilesRecursion(path, dataFilename, oldFilenameSection, newFilenameSection);
    
    if updateBackup
        path = makePath(projectPath, Constants.BACKUP_DIR, toPath);
        
        renameFilesRecursion(path, dataFilename, oldFilenameSection, newFilenameSection);
    end
    
    delete(waitHandle);
    
end

end

