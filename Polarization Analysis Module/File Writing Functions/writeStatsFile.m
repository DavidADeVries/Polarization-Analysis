function [] = writeStatsFile(path, fileName, metricResults)
% writeStatsFile

fileNameSection = createFilenameSection(PolarizationAnalysisNamingConventions.STAT_FILENAME_LABEL, []);

writeFileName = [fileName, fileNameSection, Constants.XLSX_EXT];

writePath = makePath(path, MetricGroupTypes.Stats.dirName, writeFileName);

writeData = {};

headers = {'Metric', 'Min', 'Max', 'Mean', 'Std Dev', 'Median', 'Skewness'};

writeData(1,:) = headers;

metricTypes = enumeration('MetricTypes');

counter = 2;

for i=1:length(metricTypes)
    metricType = metricTypes(i);
    
    data = metricResults(:,:,i);
    
    dims = size(data);
    
    dataCol = reshape(data, dims(1)*dims(2), 1);
    
    dataMin = min(dataCol);
    dataMax = max(dataCol);
    dataMean = mean(dataCol);
    dataStdev = std(dataCol);
    dataMedian = median(dataCol);
    dataSkew = skewness(dataCol);
    
    rowLabel = metricType.displayString;
    
    if metricType.isCircularData
        circRowLabel = [rowLabel, ' ', Constants.CIRC_STATS_LABEL];
        rowLabel = [rowLabel, ' ', Constants.NON_CIRC_STATS_LABEL];
        
        circDataCol = convertCircData(dataCol, metricType.dataRange);
        
        circularMean = unconvertCircData(circ_mean(circDataCol), metricType.dataRange);
        circularStdev = unconvertCircData(circ_std(circDataCol), metricType.dataRange);
        circularMedian = [];%unconvertCircData(circ_median(circDataCol), metricType.dataRange); % CAN'T DO! CRASHES MATLAB, Requires too much memory?!
        circularSkew = unconvertCircData(circ_skewness(circDataCol), metricType.dataRange);
        
        row = {circRowLabel, dataMin, dataMax, circularMean, circularStdev, circularMedian, circularSkew};
        
        writeData(counter,:) = row;
        counter = counter + 1;
    end
    
    row = {rowLabel, dataMin, dataMax, dataMean, dataStdev, dataMedian, dataSkew};
    
    writeData(counter,:) = row;
    counter = counter + 1;
            
end

xlswrite(writePath, writeData);


end

