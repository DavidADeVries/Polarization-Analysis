function [namingConvention, index] = getNamingConventionFromImportFilename(filename, namingConventions)
% getNamingConventionFromFilename
% for a given import filename, a match from the import names from a naming
% convention list is attempted to be found.
% If there's a singular match, the naming convention and where it was found
% in the list are kicked back
% multiple/no match kicks back an error

trimmedFilename = removeFileExtension(filename);

numMatches = 0;

index = 0;
namingConvention = [];

for i=1:length(namingConventions)
    searchString = namingConventions{i}.import{1};
    
    indices = strfind(trimmedFilename, searchString);
    
    if ~isempty(indices) %we have a match!
        numMatches = numMatches + 1;
        
        index = i;
        namingConvention = namingConventions{i};
    end
end

if numMatches ~= 1
    error('Singular naming convention match not found!');
end


end

