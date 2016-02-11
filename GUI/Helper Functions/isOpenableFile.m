function bool = isOpenableFile(file)
% isOpenableFile
% returns true is the file extension is one that may be opened by this
% application

fileExtension = getFileExtension(file.toPath);

bool = strcmp(fileExtension, Constants.BMP_EXT); % just Bitmaps for now



end

