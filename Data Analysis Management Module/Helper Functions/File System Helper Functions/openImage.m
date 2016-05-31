function image = openImage(path)
% openImage

rawData = imread(path);

dims = size(rawData);


if length(dims) == 3 % got 3D data, check if colour or BW that's just duplicated data for all 3 channels
    R = rawData(:,:,1);
    G = rawData(:,:,2);
    B = rawData(:,:,3);
    
    if all(R==G) && all(G==B) % all three channels are identical, make it one dimesional
        image = rgb2gray(rawData);
        
        dataMin = min(min(image));
        dataMax = max(max(image));
    else
        image = data;
        
        dataMin = min(min(min(image)));
        dataMax = max(max(max(image)));
    end
elseif length(dims) == 1
    image = data;
    
    dataMin = min(min(image));
    dataMax = max(max(image));
end

if dataMin >= 0 && dataMax <= 1 %scaled between 0 and 1
    image = image ./ 1;
elseif dataMin >= 0 && dataMax <= 255 %scaled between 0 and 255, so normalize it to 0 to 1
    image = image ./ 255;
else
    error(['Invalid image data range at: ' path]);
end    



end

