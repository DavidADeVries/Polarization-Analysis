function namingConventions = createNamingConventionsFromFilenameTags(filenames, filenameTags)
% createNamingConventionsFromFilenameTags

namingConventions = {};

numFilenames = length(filenames);
numFilenameTags = length(filenameTags);

if numFilenames == numFilenameTags
    for i=1:numFilenames
        namingConventions{i} = NamingConvention({filenames{i}}, filenameTags{i});
    end
else
    error('Number of filenames and filename tags mismatch');
end


end

