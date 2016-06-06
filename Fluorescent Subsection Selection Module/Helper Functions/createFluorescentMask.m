function mask = createFluorescentMask(fluorescentImage)
% createFluorescentMask

dims = size(fluorescentImage);

colVec = reshape(fluorescentImage, dims(1)*dims(2), 1);

rng default; %reproducability

colClustering = kmeans(colVec, 2, 'Replicates', 5);

clustering = reshape(colClustering, dims(1), dims(2));

% find what the background is labelled as by taking the most common pixel
% value along the border

topRow = clustering(1,:);
bottomRow = clustering(dims(1),:);

leftCol = clustering(:,1);
rightCol = clustering(:,dims(2));

combined = [topRow, bottomRow, leftCol', rightCol']; %yeah, I know the corner pixels are repeated, shouldn't make a difference

num1Pixels = sum(combined == 1);
num2Pixels = sum(combined == 2);

if num1Pixels > num2Pixels
    backgroundCluster = 1;
else
    backgroundCluster = 2;
end

mask = (clustering ~= backgroundCluster);

end

