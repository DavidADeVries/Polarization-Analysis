function trimmedFilename = removeFileExtension(filename)
%removeFileExtension
% removes the .XXX from the end of a file

[trimmedFilename, ~] = splitFileExtension(filename);

end

