function trimmedFilename = removeFileExtension(filename)
%removeFileExtension
% removes the .XXX from the end of a file

dotIndices = strfind(filename, '.');

lastDotIndex = dotIndices(length(dotIndices));

trimmedFilename = filename(1:lastDotIndex-1);


end

