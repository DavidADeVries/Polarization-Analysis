function handles = updateImageAxes(handles, imageSelection)
% updateImageAxes
% updates the image axes with the provided image selection

imageData = [];

if ~isempty(imageSelection)
    imagePath = imageSelection.toPath;
    
    imageData = openFile(imagePath);    
end

% update image axes

handles.image = imshow(imageData, [], 'Parent', handles.imageAxes);


end

