function trimmedFilename = getFileExtension(filename)
% getFileExtension
% gets the .XXX from the end of a file

dotIndices = strfind(filename, '.');

lastDotIndex = dotIndices(length(dotIndices));

trimmedFilename = filename(lastDotIndex:length(filename));


end

