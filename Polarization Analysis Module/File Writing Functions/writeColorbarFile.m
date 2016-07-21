function [] = writeColorbarFile(data, path, filename, dataRange, tickSpacing, metricType)
% writeColorbarFile

filename = [filename, createFilenameSection(PolarizationAnalysisNamingConventions.MM_COLORBAR_FILENAME_LABEL,[]), Constants.PNG_EXT];

writePath = makePath(path, filename);

figHandle = figure('Visible', 'off');
imagesc(data);

if metricType.isCircularData
    colormap(getCircularColormap(dataRange));
else
    colormap jet;
end
    
axis image;
axis off;

caxis(dataRange);

[ticks, tickLabels] = getTicksAndLabels(dataRange, tickSpacing);

colorbarHandle = colorbar();

set(colorbarHandle, 'FontSize', 15, 'YTick', ticks, 'YTickLabel', tickLabels);

saveas(figHandle, writePath);

close(figHandle);


end

function [ticks, tickLabels] = getTicksAndLabels(dataRange, tickSpacing)
    bot = dataRange(1);
    top = dataRange(2);
    
    counter = 1;
    
    ticks = [];
    tickLabels = {};
    
    for i=bot:tickSpacing:top
        ticks(counter) = i;
        tickLabels{counter} = num2str(i);
        
        counter = counter + 1;
    end
    
    tickLabels = char(tickLabels); % convert to char array
end