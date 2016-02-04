function filename = getFilename(filePath)
% getFilenanme
% gets the XXXXXXXX.YYY from the end of a file path

slashIndices = strfind(filePath, '\');

lastSlahIndex = slashIndices(length(slashIndices));

filename = filePath(lastSlahIndex+1:length(filePath));


end

