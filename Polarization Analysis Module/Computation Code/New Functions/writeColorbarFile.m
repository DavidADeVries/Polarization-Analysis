function [] = writeColorbarFile(data, path, filename, dataRange)
% writeColorbarFile

filename = [filename, makeFilenameSection(PolarizationNamingConventions.MM_COLORBAR_FILENAME_LABEL), Constants.BMP_EXT];

writePath = makePath(path, filename);

figHandle = figure('Visible', 'off');
imagesc(data);
colormap jet;
axis image;
axis off;
colorbar;
caxis(dataRange);

saveas(figHandle, writePath);


end

