function filenameTags = createSuggestedFilenameTags(filenames, namingConventions)
% createdSuggestedFilenameTags
% by leveraging the given namingConventions, suggested filename tags can be
% generated

numFiles = length(filenames);

filenameTags = cell(numFiles, 1);

for i=1:numFiles
    matchedNamingConventions = getNamingConventionFromImportFilename(filenames{i}, namingConventions);
    
    if isempty(matchedNamingConventions)
        filenameTags{i} = '';
    else
        filenameTags{i} = matchedNamingConventions{1}.generateProjectTagString(); %default to the first
    end
end


end

