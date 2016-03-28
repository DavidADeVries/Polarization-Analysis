function [filenames, paths, extensions] = generateImportFilenames(importPath, recurse)
% generateImportFilenames

filenames = {};
paths = {};
extensions = {};

[filenames, paths, extensions] = generateImportFilenamesRecursion(importPath, filenames, paths, extensions, recurse);

end

function [filenames, paths, extensions] = generateImportFilenamesRecursion(importPath, filenames, paths, extensions, recurse)

newFilenames = getAllFiles(importPath);

counter = length(filenames) + 1;

% handle files first
for i=1:length(newFilenames)
    [newFilename, newExtension] = splitFileExtension(newFilenames{i});
    
    indices = containsString(filenames, newFilename);
    
    if isempty(indices) % newFilename not yet in filenames
        filenames{counter} = newFilename;
        paths{counter} = {importPath};
        extensions{counter} = {newExtension};
        
        counter = counter + 1;
    else
        index = indices(1); %location of newFilename in filenames
        
        % update paths
        existingPaths = paths{index};
        existingPaths = [existingPaths, importPath];
        paths{index} = existingPaths;
        
        % update extensions
        existingExtensions = extensions{index};
        existingExtensions = [existingExtensions, newExtension];
        extensions{index} = existingExtensions;
        
    end
end

% recurse in folders

if recurse
    folderNames = getAllFolders(importPath);
    
    for i=1:length(folderNames)
        folderName = folderNames{i};
        
        nextImportPath = makePath(importPath, folderName);
        
        [filenames, paths, extensions] = generateImportFilenamesRecursion(nextImportPath, filenames, paths, extensions, recurse);
    end
end

end