function bool = isOpenableFileExtension(fileExtension)
% isOpenableFileExtension

allowableFiles = {Constants.BMP_EXT, Constants.PNG_EXT};

bool = ~isempty(containsString(allowableFiles, fileExtension)); 


end

