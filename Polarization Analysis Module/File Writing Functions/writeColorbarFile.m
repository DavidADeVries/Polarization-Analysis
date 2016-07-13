function [] = writeColorbarFile(data, path, filename, dataRange, metricType)
% writeColorbarFile

filename = [filename, createFilenameSection(PolarizationAnalysisNamingConventions.MM_COLORBAR_FILENAME_LABEL,[]), Constants.PNG_EXT];

writePath = makePath(path, filename);

figHandle = figure('Visible', 'off');
imagesc(data);

if metricType.isCircularData
    colormap hsv;
else
    colormap jet;
end
    
axis image;
axis off;

h = colorbar;
set(h, 'FontSize', 15);

caxis(dataRange);

saveas(figHandle, writePath);

close(figHandle);


end

