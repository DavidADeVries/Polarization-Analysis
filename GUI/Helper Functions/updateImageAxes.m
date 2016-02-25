function handles = updateImageAxes(handles, imageSelection)
% updateImageAxes
% updates the image axes with the provided image selection

imageData = [];

if ~isempty(imageSelection)
    imagePath = imageSelection.toPath;
    
    imageData = openFile(imagePath);    
end

if isempty(imageData)
    bounds = [];
else    
    % figure out high low so that auto contrasting doesn't happen
    dims = size(imageData);
    
    if length(dims) == 2
        imMax = max(max(imageData));
    elseif length(dims) == 3
        imMax = max(max(max(imageData)));
    else
        error('Invalid image dimensions!');
    end
    
    
    if imMax <= 1
        bounds = [0,1];
    elseif imMax <= 255
        bounds = [0,255];
    else
        error('Invalid image value');
    end
end

% update image axes

handles.image = imshow(imageData, bounds, 'Parent', handles.imageAxes);


end

