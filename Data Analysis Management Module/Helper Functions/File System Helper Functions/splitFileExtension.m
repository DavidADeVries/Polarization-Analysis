function [trimmedFilename, extension] = splitFileExtension(filename)
%removeFileExtension
% removes the .XXX from the end of a file

dotIndices = strfind(filename, '.');

numIndices = length(dotIndices);

if numIndices == 0
    trimmedFilename = filename;
    extension = '';
else
    lastDotIndex = dotIndices(length(dotIndices));
    
    trimmedFilename = filename(1:lastDotIndex-1);
    extension = filename(lastDotIndex:length(filename));
end


end

