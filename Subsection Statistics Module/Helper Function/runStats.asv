function statsOutput, testsOutput = runStats(dataForStats, dataLocationStrings, dataSessionStrings, comparisonType)
% runStats

metricTypes = enumeration('MetricTypes');

statTypes = enumeration('StatisticTypes');

colHeaders = comparisonType.columnHeaders;
testsColHeaders = comparisonType.getTestColumnHeaders();

statsOutput = {};

template = {};

[template] = setColumnHeaders(template, metricTypes, colHeaders);
[template] = setRowLabels(template, dataLocationStrings, dataSessionStrings);

testsTemplate = {};

[testsTemplate] = setTestColumnHeaders(testsTemplate, metricTypes, testsColHeaders);

for i=1:length(statTypes)
    statType = statTypes(i);
    
    statTypeOutput = template;
    tstOutput = testTemplate;
    
    % prep data: format is cell array for each metric where each index
    % contains non-cell array with columns for pos, neg, etc, and rows for
    % each location
    
    data = prepData(dataForStats, metricTypes, statType);
    
    [statTypeOutput, colSpacer] = placeData(statTypeOutput, data);
    
    % run and get stats for the prepped data, and place in the output    
    
    [dataStats, rowLabels] = generalStatsForData(data, metricTypes);
    
    statTypeOutput = placeGeneralStats(statTypeOutput, dataStats, rowLabels, colSpacer);
    
    
    
    statsOutput{i} = statTypeOutput;
    testsOutput{i} = testOutput;
end

end


% ****************
% HELPER FUNCTIONS
% ****************


% setColumnHeaders

function output = setColumnHeaders(output, metricTypes, colHeaders)

rowLabelHeaders = {'Location', 'Sessions'};
numRowLabelHeaders = length(rowLabelHeaders);

numColHeaders = length(colHeaders);

i = 1;

while i <= numRowLabelHeaders
    output{1,i} = rowLabelHeaders{i};
    
    i = i+1;
end

for j=1:length(metricTypes)
    metricType = metricTypes(j);
    
    metricLabels = metricType.getMetricLabels();
    
    for k=1:length(metricLabels)
        label = metricLabels{k};
        
        output{1,i} = label; % set top headers
        
        for l=1:numColHeaders
            output{2,i+l-1} = colHeaders{l}; %set sub headers
        end
        
        i = i + numColHeaders;
    end
    
end

end

% setTestColumnHeaders
function output = setTestColumnHeaders(output, metricTypes, colHeaders)

rowLabelHeaders = {'Test Metrics'};
numRowLabelHeaders = length(rowLabelHeaders);

numColHeaders = length(colHeaders);

i = 1;

while i <= numRowLabelHeaders
    output{1,i} = rowLabelHeaders{i};
    
    i = i+1;
end

for j=1:length(metricTypes)
    metricType = metricTypes(j);
    
    metricLabels = metricType.getMetricLabels();
    
    for k=1:length(metricLabels)
        label = metricLabels{k};
        
        output{1,i} = label; % set top headers
        
        for l=1:numColHeaders
            output{2,i+l-1} = colHeaders{l}; %set sub headers
        end
        
        i = i + numColHeaders;
    end
    
end

end

% setRowLabels

function output = setRowLabels(output, dataLocationStrings, dataSessionStrings)

headerOffset = 2; %two rows from header and sub headers

for i=1:length(dataLocationStrings)
    output{i + headerOffset, 1} = dataLocationStrings{i};
    output{i + headerOffset, 2} = dataSessionStrings{i};
end

end

% setTestRowLabels

function output = setRowTestLabels(output)

headerOffset = 2; %two rows from header and sub headers

normalityTestsLabel = {'Normality Tests'};

andersonDarlingLabels = {...
    'Anderson-Darling Normality Test',...
    'h - Value',...
    'p - Value',...
    'Test Statistic',...
    'Critical Value'};

shapiroWilkLabels = {...
    'Shapiro-Wilk Normality Test',...
    'h - Value',...
    'p - Value',...
    'Test Statistic'};

pairedTestsLabels = {'Paired Tests'};

pairedTTestLabels = {...
    'h - Value',...
    'p - Value',...
    'Confidence Interval 1',...
    'Confidence Interval 2',...
    'Test Statistic',...
    'Degrees of Freedom',...
    'Standard Deviation'};

wilcoxonSignedRankLabels = {...
    'h - Value',...
    'p - Value',...
    'Test Statistics',...
    'z - Statistic'};

unpairedTestsLabel = {'Unpaired Tests'};

unpairedTTestLabels = {...
    'h - Value',...
    'p - Value',...
    'Confidence Interval 1',...
    'Confidence Interval 2',...
    'Test Statistic',...
    'Degrees of Freedom',...
    'Standard Deviation'};

mannWhitneyRankSumLabels = {...
    'h - Value',...
    'p - Value'};

spacer = {''};

tab = '';

rowLabels = [...
    normalityTestsLabel,...
    indent(andersonDarlingLabels, tab),...
    spacer,...
    indent(shapiroWilkLabels, tab),...
    spacer,...
    pairedTestsLabels,...
    indent(pairedTTestLabels, tab),...
    spacer,...
    indent(wilcoxonSignedRankLabels, tab),...
    spacer,...
    unpairedTestsLabel,...
    indent(unpairedTTestLabels, tab),...
    spacer,...
    indent(mannWhitneyRankSumLabels, tab)];


for i=1:length(dataLocationStrings)
    output{i + headerOffset, 1} = dataLocationStrings{i};
    output{i + headerOffset, 2} = dataSessionStrings{i};
end

end

% indent
function labels = indent(labels, tab)
    for i=1:length(labels)
        labels{i} = [tab, labels{i}];
        
        if i ~= 1
            labels{i} = [tab, labels{i}];
        end
    end
end

% prep data

function preppedData = prepData(data, metricTypes, statFile)

preppedData = {};

numLocations = length(data);

metricCounter = 1;

subPreppedMetricData = [];

for i=1:length(metricTypes)
    metricType = metricTypes(i);
    
    useCircStats = metricType.getUseCircStats();
    
    numStats = length(useCircStats);
    
    preppedMetricData = cell(numStats,1);
    
    for j=1:numLocations
        locationData = data{j};
        
        numCols = length(locationData);
        
        k = 1;
        
        while k <= numCols
            colLocationData = locationData{k};
            
            metricData = colLocationData{i};
            
            for l=1:numStats
                subPreppedMetricData(j,k) = prepMetricData(metricData, useCircStats{l}, statFile);
                
                preppedMetricData{l} = subPreppedMetricData;
                
                k = k + 1;
            end
        end
    end
    
    for l=1:numStats
        preppedData{metricCounter} = preppedMetricData{l};
        metricCounter = metricCounter + 1;
    end
end
end


% prepMetricData
function preppedData = prepMetricData(metricData, useCircStats, statType)

dims = size(metricData);

metricData = reshape(metricData, dims(1)*dims(2), 1);

switch statType
    case StatisticTypes.mean
        if useCircStats
            preppedData = mean(metricData);
        else
            preppedData = circ_mean(metricData);
        end
        
    case StatisticTypes.median
        if useCircStats
            preppedData = median(metricData);
        else
            preppedData = median(metricData); %can't do circ_median, way too resource intensive
        end
        
    case StatisticTypes.stdev
        if useCircStats
            preppedData = std(metricData);
        else
            preppedData = circ_std(metricData);
        end
        
    case StatisticTypes.skewness
        if useCircStats
            preppedData = skewness(metricData);
        else
            preppedData = circ_skewness(metricData);
        end
end

end

% place data
function [output, colSpacerOutput] = placeData(output, data)
%first find starting points to start placeing the data
dims = size(output);

endRow = dims(1);

spacerColIndex = 0;

for i=1:dims(1)
    if isempty(output{endRow,i});
        spacerColIndex = i;
        break;
    end
end

colSpacerOutput = spacerColIndex;

spacerRowIndex = 0;

for i=1:dims(1)
    if isempty(output{i,spacerColIndex});
        spacerRowIndex = i;
        break;
    end
end

for i=1:length(data)
    dataFromMetric = data{i};
    
    dims = size(dataFromMetric);
    
    rowIndex = spacerRowIndex;
    
    for j=1:dims(1)
        
        colIndex = spacerColIndex;
        
        for k=1:dims(2)
            output{rowIndex, colIndex} = dataFromMetric(j,k);
            
            colIndex = colIndex + 1;
        end
        
        rowIndex = rowIndex + 1;
    end
    
    spacerColIndex = spacerColIndex + dims(2);
end


end

% generalStatsForData
function [dataStats, rowLabels] = generalStatsForData(data, metricTypes)

dataIndex = 1;

dataStats = {};
rowLabels = {};

for i=1:length(metricTypes)
    metricType = metricTypes(i);
    
    useCircStats = metricType.getUseCircStats();
    
    for j=1:length(useCircStats)
        dataForMetric = data{dataIndex};
        
        [rowLabels, generalStats] = computeGeneralStats(dataForMetric, useCircStats{j});
        
        dataStats{dataIndex} = generalStats;
        
        dataIndex = dataIndex + 1;
    end
end


end

% computeGeneralStats
function [rowLabels, generalStats] = computeGeneralStats(dataForMetric, useCircStats)

rowLabels = {'Min', 'Max', 'Mean', 'Std Dev', 'Median', 'Skewness'};

numStats = length(rowLabels);

dims = size(dataForMetric);

generalStats = zeros(numStats, dims(2));


for i=1:dims(2)
    dataCol = dataForMetric(:,i);
    
    generalStats(1,i) = min(dataCol);
    generalStats(2,i) = max(dataCol);
    
    if useCircStats
        generalStats(3,i) = circ_mean(dataCol);
        generalStats(4,i) = circ_std(dataCol);
        generalStats(5,i) = median(dataCol);
        generalStats(6,i) = circ_skewness(dataCol);
    else
        generalStats(3,i) = mean(dataCol);
        generalStats(4,i) = std(dataCol);
        generalStats(5,i) = median(dataCol);
        generalStats(6,i) = skewness(dataCol);
    end
end

end

% placeGeneralStats
function statTypeOutput = placeGeneralStats(statTypeOutput, dataStats, rowLabels, colSpacer)

dims = size(statTypeOutput);

rowIndex = dims(1) + 1;

%1 line spacing
rowIndex = rowIndex + 1;

%stats title
title = 'General Stats';

statTypeOutput{rowIndex, 1} = title;

rowIndexStart = rowIndex + 1;

%stats labels
for i=1:length(rowLabels)
    statTypeOutput{rowIndexStart + (i-1),1} = rowLabels{i};
end

% write stats
colIndex = colSpacer;

for i=1:length(dataStats)
    data = dataStats{i};
    
    dims = size(data);
    
    for j=1:dims(2)
        rowIndex = rowIndexStart;
        
        for k=1:dims(1)
            statTypeOutput{rowIndex, colIndex} = data(k,j);
            
            rowIndex = rowIndex + 1;
        end
        
        colIndex = colIndex + 1;
    end
end

end


