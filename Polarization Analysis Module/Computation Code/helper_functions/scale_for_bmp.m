function [ rescaled_image ] = scale_for_bmp(image, min, max)
%need to take the given range and rescale the image to have values fall
%between 0..255

rescaled_image = image - min;

rescaled_image = rescaled_image .* (1/(max - min));

end

