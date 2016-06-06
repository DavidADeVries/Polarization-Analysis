function [transformedImageBlackFill, fillMap] = applyTransforms(image, xShift, yShift, rotAngle, refImage)
% applyTransforms
% (0,0) is top left corner

shiftMatrix = [...
    1 0 0;
    0 1 0;
    xShift yShift 1];

rotationMatrix = [....
    cosd(rotAngle) sind(rotAngle) 0;
    -sind(rotAngle) cosd(rotAngle) 0;
    0 0 1];

transformMatrix = rotationMatrix * shiftMatrix;

transform = affine2d(transformMatrix);

outputView = imref2d(size(refImage));

transformedImageBlackFill = imwarp(image, transform, 'FillValues', 0, 'OutputView', outputView);
transformedImageWhiteFill = imwarp(image, transform, 'FillValues', 1, 'OutputView', outputView);

% get the fill map

isBlack = (transformedImageBlackFill == 0);
isWhite = (transformedImageWhiteFill == 1);

fillMap = isBlack & isWhite;

end

