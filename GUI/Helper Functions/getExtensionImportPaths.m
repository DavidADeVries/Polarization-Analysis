function extensionImportPaths = getExtensionImportPaths(importPath, filenameExtensions, title)
% getExtensionImportPaths
% gets all the import paths good to go

% import files
allFilenames = getAllFiles(importPath);

numExt = length(filenameExtensions);

filenames = cell(numExt, 1);
numFiles = cell(numExt, 1);
extensionImportPaths = cell(numExt, 1);

for i=1:numExt
    extensionImportPaths{i} = importPath;
    filenames{i} = getFilesByExtension(allFilenames, filenameExtensions{i});
    numFiles{i} = length(filenames{i});
    
    if numFiles{i} == 0 % give the user a chance to select individual directories for the different file locations
        prompt = ['No ', title, ' ', filenameExtensions{i}, ' files were found at: ', extensionImportPaths{i}, '. Please select where the ', filenameExtensions{i}, ' files are stored.'];
        title = ['No ', filenameExtensions{i}, ' Files Found'];
        uiwait(msgbox(prompt, title));
        
        extensionImportPaths{i} = uigetdir(extensionImportPaths{i}, ['Select ', filenameExtensions{i}, ' Files Location']);
        
        extensionFilenames = getAllFiles(extensionImportPaths{i});
        
        filenames{i} = getFilesByExtension(extensionFilenames, filenameExtensions{i});
        numFiles{i} = length(filenames{i});
    end
end



end

