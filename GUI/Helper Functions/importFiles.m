function [ ] = importFiles(sessionProjectPath, importPaths, projectPath, dataFilename, filenames, pathIndicesForFilenames, filenameExtensions, filenameTags, newDir)
% importFiles
% takes the files from importPath of the given fileExtensions and transfers
% them to the newDir

% create folder to hold data to be imported
createObjectDirectories(projectPath, sessionProjectPath, newDir);
projectToPath = makePath(sessionProjectPath, newDir);


for i=1:length(filenames)
    importFilename = filenames{i};
    filenameTag = filenameTags{i};
    pathIndicesForFilename = pathIndicesForFilenames{i};
    
    % split up filename tag (comma seperated)
    splitupTags = strsplit(filenameTag, ',');
    
    finalFilename = dataFilename;
    
    for j=1:length(splitupTags)
        tag = strtrim(splitupTags{j});
        
        filenameSection = createFilenameSection(tag, '');
        finalFilename = strcat(finalFilename, filenameSection); %just needs extension
    end
        
    for j=1:length(pathIndicesForFilename)
        index = pathIndicesForFilename(j);
        
        % import file
        fileExtension = filenameExtensions{index};
        importPath = importPaths{index};        
        
        projectFilename = strcat(finalFilename, fileExtension);
        
        finalImportFilename = strcat(importFilename, fileExtension);
        
        importFile(projectToPath, importPath, projectPath, finalImportFilename, projectFilename);
    end
    
end

end

