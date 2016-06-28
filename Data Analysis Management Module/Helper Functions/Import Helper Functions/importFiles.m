function [ ] = importFiles(sessionProjectPath, projectPath, dataFilename, filenames, filenamePaths, filenameExtensions, filenameTags, newDir)
% importFiles
% takes the files from importPath of the given fileExtensions and transfers
% them to the newDir

% create folder to hold data to be imported
createBackup = true;

createObjectDirectories(projectPath, sessionProjectPath, newDir, createBackup);
projectToPath = makePath(sessionProjectPath, newDir);

for i=1:length(filenameTags)
    importFilename = filenames{i};
    filenameTag = filenameTags{i};
    
    if ~isempty(filenameTag) % if empty, no import        
        % split up filename tag (comma seperated)
        splitupTags = strsplit(filenameTag, ',');
        
        finalFilename = dataFilename;
        
        for j=1:length(splitupTags)
            tag = strtrim(splitupTags{j});
            
            filenameSection = createFilenameSection(tag, '');
            finalFilename = strcat(finalFilename, filenameSection); %just needs extension
        end
        
        importPaths = filenamePaths{i};
        importExtensions = filenameExtensions{i};
        
        numPaths = length(importPaths);
        numExtensions = length(importExtensions);
        
        if numPaths == numExtensions            
            for j=1:numPaths               
                % import file
                fileExtension = importExtensions{j};
                importPath = importPaths{j};
                
                projectFilename = strcat(finalFilename, fileExtension);
                
                finalImportFilename = strcat(importFilename, fileExtension);
                
                importFile(projectToPath, importPath, projectPath, finalImportFilename, projectFilename);
            end
        else
            error('Auto-import failure: Number of path and extension mismatch');
        end
    end
    
end

end

