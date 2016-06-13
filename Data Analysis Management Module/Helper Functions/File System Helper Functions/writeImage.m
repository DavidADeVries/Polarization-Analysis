function [] = writeImage(image, path)
% writeImage

image = double(image); % make sure it's a double

% according to the MATLAB imwrite documentation, when writing a double, a
% range of [0,1] is expected, so scale appropriately

dims = size(image);

if length(dims) == 2
    dataMin = min(min(image));
    dataMax = max(max(image));
elseif length(dims) == 3
    dataMin = min(min(min(image)));
    dataMax = max(max(max(image)));
else
    error(['Invalid image dimensions. Could not write image at: ', path]);
end

if dataMin >= 0 && dataMax <= 1 %scaled between 0 and 1
    image = image ./ 1;
elseif dataMin >= 0 && dataMax <= 255 %scaled between 0 and 255, get to between 0 to 1
    image = image ./ 255;
else
    error(['Invalid image data range. Could not write image at: ' path]);
end  


imwrite(image, path);

end

