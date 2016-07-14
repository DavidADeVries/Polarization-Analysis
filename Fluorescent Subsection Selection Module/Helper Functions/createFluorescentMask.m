function mask = createFluorescentMask(fluorescentImage)
% createFluorescentMask

dims = size(fluorescentImage);

thres = graythresh(fluorescentImage);

mask = im2bw(fluorescentImage, thres);

% now have mask, but make sure background is false and deposit is true

% find what the background is labelled as by taking the most common pixel
% value along the border

topRow = mask(1,:);
bottomRow = mask(dims(1),:);

leftCol = mask(:,1);
rightCol = mask(:,dims(2));

combined = [topRow, bottomRow, leftCol', rightCol']; %yeah, I know the corner pixels are repeated, shouldn't make a difference

numTruePixels = sum(sum(combined));
numFalsePixels = sum(sum(~combined));

if numTruePixels > numFalsePixels
    mask = ~mask;
end


end

