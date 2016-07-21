function [] = writeMetricFiles(path, fileName, metricResults)
% writeMetricFiles

% create group directories

metricGroupTypes = enumeration('MetricGroupTypes');

for i=1:length(metricGroupTypes)
    metricGroupType = metricGroupTypes(i);

    mkdir(path, metricGroupType.dirName);
end

% write metric files

metricTypes = enumeration('MetricTypes');

for i=1:length(metricTypes)
    metricType = metricTypes(i);
    
    metricGroupType = metricType.metricGroupType;

    groupFileNameSection = createFilenameSection(metricGroupType.filenameTag, []);
    metricFileNameSection = createFilenameSection(metricType.filenameTag, []);
    
    groupDir = metricGroupType.dirName;
    
    writeFilename = [fileName, groupFileNameSection, metricFileNameSection];
    
    writePath = makePath(path, groupDir);
    
    data = metricResults(:,:,i);
    
    % write colorbar image
    writeColorbarFile(data, writePath, writeFilename, metricType.dataRange, metricType.colormapTickSpacing, metricType);
    
    % write MATLAB file
    writeMatlabFile(data, writePath, writeFilename);
    
    % write histogram file
    writeHistogramFile(data, writePath, writeFilename, metricType.dataRange);
end

end

