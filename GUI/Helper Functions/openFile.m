function fileData = openFile(filePath)
% openFile
% opens a file, according to the file extension

fileExtension = getFileExtension(filePath);

if strcmp(fileExtension, Constants.BMP_EXT)
    fileData = imread(filePath);
else
    fileData = [];
end


end

