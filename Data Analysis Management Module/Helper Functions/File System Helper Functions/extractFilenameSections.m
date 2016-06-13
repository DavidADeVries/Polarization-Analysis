function filenameSections = extractFilenameSections(filename)
% extractFilenameSections

%remove filename extension

trimmedFilename = removeFileExtension(filename);

% extract filenameSections

leftBracket = Constants.FILENAME_SECTION_LEFT_BRACKET;
rightBracket = Constants.FILENAME_SECTION_RIGHT_BRACKET;

leftBracketIndices = strfind(trimmedFilename, leftBracket);
rightBracketIndices = strfind(trimmedFilename, rightBracket);


filenameSections = {};

for i=1:length(leftBracketIndices)
    left = leftBracketIndices(i);
    right = rightBracketIndices(i);
    
    filenameSections{i} = trimmedFilename(left+1 : right-1);
end

end

