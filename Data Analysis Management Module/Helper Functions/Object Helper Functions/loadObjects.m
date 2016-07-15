function [objects, objectIndex] = loadObjects(parentObject, metadataFilename)
% loadObjects

objectDirs = getMetadataFolders(parentObject.getFullPath(), metadataFilename);

numObjects = length(objectDirs);

objects = cell(numObjects, 1);

for i=1:numObjects
    % load metadata
    vars = load(makePath(parentObject.getFullPath(), objectDirs{i}, metadataFilename), Constants.METADATA_VAR);
    object = vars.metadata;
    
    object = object.loadObject(parentObject, objectDirs{i});
    
    objects{i} = object;
end

% find index
if isempty(objects)
    objectIndex = [];
else
    objectIndex = 1;
end


end

