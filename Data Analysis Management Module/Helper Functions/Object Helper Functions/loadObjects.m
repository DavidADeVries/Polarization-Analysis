function [objects, objectIndex] = loadObjects(parentObject, metadataFilename)
% loadObjects

objectDirs = getMetadataFolders(parentObject.getFullPath(), metadataFilename);

numObjects = length(objectDirs);

objects = cell(numObjects, 1);

for i=1:numObjects
    objectDir = objectDirs{i};
    
    % load metadata
    vars = load(makePath(parentObject.getFullPath(), objectDir, metadataFilename), Constants.METADATA_VAR);
    object = vars.metadata;
    
    % load dir name
    object.dirName = objectDir;
    
    % load projectPath
    object.projectPath = parentObject.projectPath;
    
    % load toPath
    object.toPath = parentObject.getToPath();
    
    % load toFilename
    object.toFilename = parentObject.getFilename();
        
    % object specific function
    object = object.loadObject();
    
    objects{i} = object;
end

% find index
if isempty(objects)
    objectIndex = [];
else
    objectIndex = 1;
end


end

