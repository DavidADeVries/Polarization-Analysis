function filenameWithDifferentExtension = findSameFilenameWithDifferentExtension(filenames, matchFilename)
% findSameFilenameWithDifferentExtension
% takes the extension off of matchFilename and tries to find this in the
% filenames list (after taking the extension off those too)
% if no match found, '' is returned

matchPattern = removeFileExtension(matchFilename);

filenameWithDifferentExtension = '';

for i=1:length(filenames)
    if strcmp(matchPattern, removeFileExtension(filenames{i}))
        filenameWithDifferentExtension = filenames{i};
        break;
    end
end


end

