function [] = renameFilesRecursion(path, dataFilename, oldFilenameSection, newFilenameSection)
% renameFilesRecursion

folders = getAllFolders(path);

for i=1:length(folders)
    renameFilesRecursion(makePath(path, folders{i}), dataFilename, oldFilenameSection, newFilenameSection);
end

files = getAllFiles(path);

for i=1:length(files)
    filename = files{i};
    
    filenameLength = length(filename);
    leadingDataFilenameLength = length(dataFilename);
    filenameSectionLength = length(oldFilenameSection);
    
    cutoff = leadingDataFilenameLength+filenameSectionLength;
    
    if cutoff <= filenameLength
        
        filenameCompare = filename(1:cutoff);
        dataFilenameCompare = [dataFilename, oldFilenameSection];
        
        if strcmp(filenameCompare, dataFilenameCompare)
            oldFilename = filename;
            newFilename = [dataFilename, newFilenameSection, filename(cutoff+1:filenameLength)];
            
            movefile(makePath(path, oldFilename), makePath(path, newFilename));
        end
    
    end
end


end

