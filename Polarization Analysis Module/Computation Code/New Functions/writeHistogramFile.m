function [] = writeHistogramFile(data, path, filename, dataRange)
% writeHistogramFile

filename = [filename, makeFilenameSection(PolarizationNamingConventions.HISTOGRAM_FILENAME_LABEL), Constants.BMP_EXT];

writePath = makePath(path, filename);

figHandle = figure('Visible', 'off');

dims = size(data);

height = dims(1)*dims(2);

range = abs(dataRange(2) - dataRange(1));

if range <= 10;
    numBins = range * 100;
elseif range <= 50
    numBins = range * 10;
else
    numBins = range;
end

hist(reshape(data, 1, height), numBins);

saveas(figHandle, writePath);

close(figHandle);


end

