function [] = renameDirectory(toPath, projectPath, oldDirName, newDirName, updateBackup)
%renameDirectory

if ~strcmp(oldDirName, newDirName)
    
    oldPath = makePath(projectPath, toPath, oldDirName);
    newPath = makePath(projectPath, toPath, newDirName);
    
    movefile(oldPath, newPath);
    
    if updateBackup
        oldPath = makePath(projectPath, Constants.BACKUP_DIR, toPath, oldDirName);
        newPath = makePath(projectPath, Constants.BACKUP_DIR, toPath, newDirName);
        
        movefile(oldPath, newPath);
    end
    
end

end

