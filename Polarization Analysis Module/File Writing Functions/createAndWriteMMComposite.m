function [] = createAndWriteMMComposite(MM, compositeFileName)
% createAndWriteMMComposite

refImage = MM(:,:,1,1);

dims = size(refImage);

spacing = 3; %pixels

imageHeight = dims(1);
imageWidth = dims(2);

colorbarWidth = 100;

figureHeight = 1000;

proposedImageHeight = (figureHeight - (3*spacing)) / 4;

scaleVal = proposedImageHeight / imageHeight;

colorbarHeight = figureHeight / 2;

scaledImageHeight = imageHeight * scaleVal;
scaledImageWidth = imageWidth * scaleVal;

figureWidth = (4*scaledImageWidth) + (4*spacing) + colorbarWidth;

position = [1, 1, figureWidth, figureHeight];
figHandle = figure('Visible', 'off', 'Position', position);

imageColorscale = [-1, 1];

imageHeightProp = scaledImageHeight / figureHeight;
spacingWidthProp = spacing / figureWidth;

imageWidthProp = scaledImageWidth / figureWidth;
spacingHeightProp = spacing / figureHeight;

colorbarHeightProp = colorbarHeight / figureHeight;
colorbarWidthProp = colorbarWidth / figureWidth;


for x=1:4
    for y=1:4
        subplotLeft = ((x-1)*imageWidthProp) + ((x-1)*spacingWidthProp);
        subplotBottom = ((4-y)*imageHeightProp) + ((4-y)*spacingHeightProp);
        
        subplotPosition = [subplotLeft, subplotBottom, imageWidthProp, imageHeightProp];
        
        subplot('Position', subplotPosition);
        imshow(MM(:,:,x,y), imageColorscale);
    end
end

colorbarLeft = (4*imageWidthProp) + (4*spacingWidthProp);
colorbarBottom = imageHeightProp + spacingHeightProp;

colorbarSubplotPosition = [colorbarLeft, colorbarBottom, colorbarWidthProp, colorbarHeightProp];

axesHandle = subplot('Position', colorbarSubplotPosition);

axesPos = get(axesHandle, 'Position');
axesPos(3) = 0.000001; % small enough, can't be 0

set(axesHandle, 'Position', axesPos);

axis off;

colormap gray;
colorbarHandle = colorbar;

colorbarPosition = get(colorbarHandle, 'Position');

colorbarPosition(3) = 0.025; %make it wider

set(colorbarHandle, 'Position', colorbarPosition);

savefig(figHandle, compositeFileName);

close(figHandle);


end

