function [ ] = importFiles(sessionProjectPath, importPath, projectPath, dataFilename, namingConventions, newDir, filenameExtensions)
% importFiles
% takes the files from importPath of the given fileExtensions and transfers
% them to the newDir

% create folder to hold data to be imported
createObjectDirectories(projectPath, sessionProjectPath, newDir);
projectToPath = makePath(sessionProjectPath, newDir);

% import files
allFilenames = getAllFiles(importPath);

numExt = length(filenameExtensions);

filenames = cell(numExt, 1);
numFiles = cell(numExt, 1);
importPaths = cell(numExt, 1);

for i=1:numExt
    importPaths{i} = importPath;
    filenames{i} = getFilesByExtension(allFilenames, filenameExtensions{i});
    numFiles{i} = length(filenames{i});
    
    if numFiles{i} == 0 % give the user a chance to select individual directories for the different file locations
        prompt = ['No ', filenameExtensions{i}, ' files were found at: ', importPaths{i}, '. Please select where the ', filenameExtensions{i}, ' files are stored'];
        title = ['No ', filenameExtensions{i}, ' Files Found'];
        msgbox(prompt, title);
        
        importPaths{i} = uigetdir(importPaths{i}, ['Select ', filenameExtensions{i}, ' Files Location']);
        
        extensionFilenames = getAllFiles(importPaths{i});
        
        filenames{i} = getFilesByExtension(extensionFilenames, filenameExtensions{i});
        numFiles{i} = length(filenames{i});
    end
end

allNumFilesEqual = true;

if numExt ~= 0
    unifiedNumFiles = numFiles{1};
    
    for i=2:numExt
        if unifiedNumFiles ~= numFiles{i}
            allNumFilesEqual = false;
            break;
        end
    end
end

if allNumFilesEqual   
    counts = zeros(length(namingConventions), 1); % this will keep track of the number of each type of image we get (easy check for duplicate)
        
    for i=1:unifiedNumFiles
        importReferenceFilename = filenames{1}{i};
        
        [namingConvention, index] = getNamingConventionFromImportFilename(importReferenceFilename, namingConventions);
        
        filenameSection = createFilenameSection(namingConvention.project, '');
        finalFilename = strcat(dataFilename, filenameSection); %just needs extension
        
        if counts(index) ~= 0 % in case there are multiple images of the same series
            filenameSection = createFilenameSection('', num2str(counts(index)+1));
            finalFilename = strcat(finalFilename, filenameSection);
        end
        
        for j=1:numExt        
            % import file
            projectFilename = strcat(finalFilename, filenameExtensions{j});
            importFilename = findSameFilenameWithDifferentExtension(filenames{j}, importReferenceFilename);
            
            importFile(projectToPath, importPaths{j}, projectPath, importFilename, projectFilename);
        end
        
        counts(index) = counts(index) + 1;
        
    end
else
    error('Unequal number of files for differing file extensions.');
end

end

