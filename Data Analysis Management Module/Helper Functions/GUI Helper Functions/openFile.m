function fileData = openFile(filePath)
% openFile
% opens a file, according to the file extension

fileExtension = getFileExtension(filePath);

if isOpenableFileExtension(fileExtension)
    fileData = imread(filePath);
else
    fileData = [];
end


end

