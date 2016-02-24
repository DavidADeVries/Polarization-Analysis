function matchedNamingConventions = getNamingConventionFromImportFilename(filename, namingConventions)
% getNamingConventionFromFilename
% for a given import filename, a match from the import names from a naming
% convention list is attempted to be found.

trimmedFilename = removeFileExtension(filename);

matchedNamingConventions = {};

counter = 1;

for i=1:length(namingConventions)
    searchStrings = namingConventions{i}.import;
    
    hitFound = false;
    
    for j=1:length(searchStrings)
        if ~isempty(strfind(trimmedFilename, searchStrings{j}))
            hitFound = true;
            break;
        end
    end
    
    if hitFound
        matchedNamingConventions{counter} = namingConventions{i};
        counter = counter + 1;
    end
end


end

