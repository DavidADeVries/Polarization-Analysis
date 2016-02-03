function [] = updateImageAxes(handles, imageSelection)
% updateImageAxes
% updates the image axes with the provided image selection

imageData = [];

if ~isempty(imageSelection)
    imagePath = imageSelection.toPath;
    
    fileExtension = getFileExtension(imagePath);
    
    if strcmp(fileExtension, Constants.BMP_EXT)
        imageData = imread(imagePath);
    else
        imageData = [];
    end
end

% update image axes

imshow(imageData, [], 'Parent', handles.imageAxes);


end

