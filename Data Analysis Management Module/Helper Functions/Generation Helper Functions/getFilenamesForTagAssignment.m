function [filenames, pathIndices] = getFilenamesForTagAssignment(paths)
% getFilenamesForTagAssignment
% in the path given, all the filenames are trawled, extensions are removed
% and duplicates chopped out
% pathIndices keep track of where the filename was found

filenames = {};
pathIndices = {};
    
counter = 1;

for i=1:length(paths)
    
    files = getAllFiles(paths{i});
    
    for j=1:length(files)
        filename = removeFileExtension(files{j});
        
        indices = containsString(filenames, filename);
        
        if isempty(indices)
            filenames{counter} = filename;
            pathIndices{counter} = (i);
            
            counter = counter + 1;
        else
            %update exensions
            pathIndicesEntry = pathIndices{indices(1)};
            
            pathIndicesEntry(length(pathIndicesEntry)+1) = i;
            
            pathIndices{indices(1)} = pathIndicesEntry;
        end
    end
end


end

