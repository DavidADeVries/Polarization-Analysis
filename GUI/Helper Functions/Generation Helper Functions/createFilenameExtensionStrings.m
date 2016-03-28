function extensionStrings = createFilenameExtensionStrings(filenameExtensions)
% createFilenameExtensionStrings

numFilenames = length(filenameExtensions);

extensionStrings = cell(numFilenames, 1);

for i=1:numFilenames
    extensionStrings{i} = createFilenameExtensionString(filenameExtensions{i});
end


end

function string = createFilenameExtensionString(extensions)
    string = '';

    for i=1:length(extensions)
        if i ~= 1
            string = [string, ', '];
        end
        
        string = [string, extensions{i}];
    end
end