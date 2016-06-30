function [statsOutput, testsOutput] = runStats(dataForStats, dataLocationStrings, dataSessionStrings, comparisonType)
% runStats

metricTypes = enumeration('MetricTypes');

statTypes = enumeration('StatisticTypes');

colHeaders = comparisonType.columnHeaders;
testsColHeaders = comparisonType.getTestColumnHeaders();

statsOutput = {};
testsOutput = {};

template = {};

[template] = setColumnHeaders(template, metricTypes, colHeaders);
[template] = setRowLabels(template, dataLocationStrings, dataSessionStrings);

testsTemplate = {};

[testsTemplate, testRowSpacer] = setTestColumnHeaders(testsTemplate, metricTypes, testsColHeaders);
[testsTemplate, testColSpacer, sectionSpacers] = setTestRowLabels(testsTemplate);
[testsTemplate, cutoffRow] = placeHValueCutoffs(testsTemplate, testColSpacer, testRowSpacer, testsColHeaders, metricTypes);

for i=1:length(statTypes)
    statType = statTypes(i);
    
    statTypeOutput = template;
    testOutput = testsTemplate;
    
    % prep data: format is cell array for each metric where each index
    % contains non-cell array with columns for pos, neg, etc, and rows for
    % each location
    
    data = prepData(dataForStats, metricTypes, statType);
    
    [statTypeOutput, colSpacer] = placeData(statTypeOutput, data);
    
    % run and get stats for the prepped data, and place in the output    
    
    [dataStats, rowLabels] = generalStatsForData(data, metricTypes);
    
    statTypeOutput = placeGeneralStats(statTypeOutput, dataStats, rowLabels, colSpacer);
    
    [headerLabel, testLabels, testResults, passedNormalityResults] = normalityTestsForData(data, metricTypes);
    
    statTypeOutput = placeNormalityTestResults(statTypeOutput, headerLabel, testLabels, testResults, colSpacer);
    
    % run tests for stats
      
    testResults = tTestsForData(data, metricTypes, passedNormalityResults);
    
    testOutput = placeTTestResults(testOutput, testResults, testColSpacer, testRowSpacer, sectionSpacers, cutoffRow);
    
    % put 
    
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
function [output, rowSpacer] = setTestColumnHeaders(output, metricTypes, colHeaders)

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

rowSpacer = 2;

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

function [output, colSpacer, sectionSpacers] = setTestRowLabels(output)

headerOffset = 2; %two rows from header and sub headers

hValueLabels = {'Number of Connections', 'Corrected h - Value Cutoff'};

pairedTestsLabels = {'Paired Tests'};

pairedTTestLabels = {...
    'Paired T-Test',...
    'h - Value',...
    'p - Value',...
    'Confidence Interval 1',...
    'Confidence Interval 2',...
    'Test Statistic',...
    'Degrees of Freedom',...
    'Standard Deviation'};

wilcoxonSignedRankLabels = {...
    'Wilcoxon Signed-Rank Test',...
    'h - Value',...
    'p - Value',...
    'Test Statistics'};

unpairedTestsLabel = {'Unpaired Tests'};

unpairedTTestLabels = {...
    'Unpaired T Test',...
    'h - Value',...
    'p - Value',...
    'Confidence Interval 1',...
    'Confidence Interval 2',...
    'Test Statistic',...
    'Degrees of Freedom',...
    'Standard Deviation'};

mannWhitneyRankSumLabels = {...
    'Mann-Whitney Rank Sum Test',...
    'h - Value',...
    'p - Value (2 Tailed)',...
    'p - Value (1 Tailed)',...
    'Sum of Ranks - 1',...
    'Sum of Ranks - 2',...
    'Mean Rank - 1',...
    'Mean Rank - 2',...
    'Test Variable - 1',...
    'Test Variable - 2',...
    'Test Variable - W'};

spacer = {''};

hasHeader = true;

rowLabels = [...
    hValueLabels,...
    spacer,...
    pairedTestsLabels,...
    indent(pairedTTestLabels, hasHeader),...
    spacer,...
    indent(wilcoxonSignedRankLabels, hasHeader),...
    spacer,...
    unpairedTestsLabel,...
    indent(unpairedTTestLabels, hasHeader),...
    spacer,...
    indent(mannWhitneyRankSumLabels, hasHeader)];

sectionSpacers = [length(hValueLabels)+4, length(pairedTTestLabels) + 1, length(wilcoxonSignedRankLabels) + 2, length(unpairedTTestLabels) + 1];


for i=1:length(rowLabels)
    output{i + headerOffset, 1} = rowLabels{i};
end

colSpacer = 1;

end

% indent
function labels = indent(labels, hasHeader)
    tab = '  ';

    for i=1:length(labels)
        labels{i} = [tab, labels{i}];
        
        if i ~= 1 && hasHeader
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

% normalityTestsForData
function [headerLabel, testLabels, testResults, passedNormalityResults] = normalityTestsForData(data, metricTypes)

dataIndex = 1;

testResults = {};
passedNormalityResults = {};

for i=1:length(metricTypes)
    metricType = metricTypes(i);
    
    useCircStats = metricType.getUseCircStats();
    
    for j=1:length(useCircStats)
        dataForMetric = data{dataIndex};
        
        [headerLabel, testLabels, testResult, passedNormality] = computeNormalityTests(dataForMetric);
        
        testResults{dataIndex} = testResult;
        passedNormalityResults{dataIndex} = passedNormality;
        
        dataIndex = dataIndex + 1;
    end
end


end

% computeGeneralStats
function [rowLabels, generalStats] = computeGeneralStats(dataForMetric, useCircStats)

rowLabels = {'Min', 'Max', 'Mean', 'Std Dev', 'Median', 'Skewness'};

hasHeader = false;

rowLabels = indent(rowLabels, hasHeader);

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

% computeNormalityTests
function [headerLabel, testLabels, testResult, passedNormality] = computeNormalityTests(dataForMetric)

hasHeader = true;

headerLabel = 'Normality Tests';

andersonDarlingLabels = {...
    'Anderson-Darling Normality Test',...
    'h - Value',...
    'p - Value',...
    'Test Statistic',...
    'Critical Value'};

andersonDarlingLabels = indent(andersonDarlingLabels, hasHeader);

shapiroWilkLabels = {...
    'Shapiro-Wilk Normality Test',...
    'h - Value',...
    'p - Value',...
    'Test Statistic'};

shapiroWilkLabels = indent(shapiroWilkLabels, hasHeader);

testLabels = {andersonDarlingLabels, shapiroWilkLabels};

dims = size(dataForMetric);

testResult = {};

for i=1:length(testLabels)
    testResult{i} = [];
end

passedNormality = [];

for i=1:dims(2)
    dataCol = dataForMetric(:,i);
    
    % Anderson-Darling Normality Test
    output = testResult{1};
    
    [h, p, stat, cv] = adtest(dataCol);
    
    output(1,i) = h;
    output(2,i) = p;
    output(3,i) = stat;
    output(4,i) = cv;
    
    testResult{1} = output;
    
    passedNormality(i) = ~h;
    
    % Shapiro-Wilk Normality Test
    output = testResult{2};
    
    [h, p, stat] = swtest(dataCol);
    
    output(1,i) = h;
    output(2,i) = p;
    output(3,i) = stat;
    
    testResult{2} = output;
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

% placeNormalityTestResults
function testOutput = placeNormalityTestResults(testOutput, headerLabel, testLabels, testResults, colSpacer)

dims = size(testOutput);

rowIndex = dims(1) + 2; %put space between test results
labelColIndex = 1;

% place labels

testOutput{rowIndex, labelColIndex} = headerLabel;

rowIndex = rowIndex + 1;

startingRowIndex = rowIndex + 1; %stash this index we'll need it for dropping the test results in

numLabels = length(testLabels);

for i=1:numLabels
    labels = testLabels{i};
    
    for j=1:length(labels)
        testOutput{rowIndex, labelColIndex} = labels{j};
        
        rowIndex = rowIndex + 1;
    end
    
    if i ~= numLabels
        rowIndex = rowIndex + 1;
    end
end

% place results

colIndex = colSpacer;

for i=1:length(testResults) % go through metric types
    rowIndex = startingRowIndex;
    
    results = testResults{i};
    
    colIncrement = 0;
    
    for j=1:length(results) % going through different tests
        singleTestResults = results{j};
        
        dims = size(singleTestResults);
        colIncrement = dims(2);
        
        for k=1:dims(2) % go through cols            
            for l=1:dims(1) % go through rows
                testOutput{rowIndex + (l-1), colIndex + (k - 1)} = singleTestResults(l,k);
            end
        end
        
        rowIndex = rowIndex + dims(1) + 2;
    end
    
    colIndex = colIndex + colIncrement;
end

end


% tTestsForData
function testResults = tTestsForData(data, metricTypes, passedNormalityResults)

dataIndex = 1;

testResults = {};

for i=1:length(metricTypes)
    metricType = metricTypes(i);
    
    useCircStats = metricType.getUseCircStats();
    
    for j=1:length(useCircStats)
        metricData = data{dataIndex};
        metricNormalityResults = passedNormalityResults{dataIndex};
        
        metricTestResults = tTestsForMetric(metricData, metricNormalityResults);
        
        testResults{dataIndex} = metricTestResults;        
        
        dataIndex = dataIndex + 1;
    end
    
end

end

% tTestsForMetric
function metricTestResults = tTestsForMetric(metricData, metricNormalityResults)

dims = size(metricData);

metricTestResults = {};
numTests = 4;

for i=1:numTests
    metricTestResults{i} = [];
end

index = 1;

for i=1:dims(2)
    for j=i+1:dims(2)
        dataCol1 = metricData(:,i);
        dataCol2 = metricData(:,j);
        
        dataCol1IsNormal = metricNormalityResults(i);
        dataCol2IsNormal = metricNormalityResults(j);
        
        bothNormal = dataCol1IsNormal && dataCol2IsNormal;
        
        
        
        % Paired T Test
        output = metricTestResults{1};
        
        if bothNormal        
            [h, p, ci, stats] = ttest(dataCol1, dataCol2);
            
            output(1,index) = h;
            output(2,index) = p;
            output(3,index) = ci(1);
            output(4,index) = ci(2);
            output(5,index) = stats.tstat;
            output(6,index) = stats.df;
            output(7,index) = stats.sd;
        else
            for k=1:7
                output(k,index) = NaN;
            end
        end
        
        metricTestResults{1} = output;
        
        
        
        % Wilcoxon Signed-Rank Test
        output = metricTestResults{2};
        
        [p,h,stats] = signrank(dataCol1, dataCol2);
        
        output(1,index) = h;
        output(2,index) = p;
        output(3,index) = stats.signedrank;
                
        metricTestResults{2} = output;
        
        
        
        % Unpaired T Test
        output = metricTestResults{3};
        
        if bothNormal        
            [h, p, ci, stats] = ttest2(dataCol1, dataCol2);
            
            output(1,index) = h;
            output(2,index) = p;
            output(3,index) = ci(1);
            output(4,index) = ci(2);
            output(5,index) = stats.tstat;
            output(6,index) = stats.df;
            output(7,index) = stats.sd;
        else
            for k=1:7
                output(k,index) = NaN;
            end
        end
        
        metricTestResults{3} = output;
        
        
        
        % Mann-Whitney Rank Sum Test
        output = metricTestResults{4};
        
        stats = mwwtest(dataCol1, dataCol2);
        
        output(1,index) = NaN; % h-value not given, but will use formula anyways
        output(2,index) = stats.p(2);
        output(3,index) = stats.p(1);
        output(4,index) = stats.W(1);
        output(5,index) = stats.W(2);
        output(6,index) = stats.mr(1);
        output(7,index) = stats.mr(2);
        output(8,index) = stats.U(1);
        output(9,index) = stats.U(2);
        output(10,index) = stats.T;
                
        metricTestResults{4} = output;
        
        
        % increment
        index = index + 1;
    end
end

end

% placeTTestResults
function testOutput = placeTTestResults(testOutput, testResults, colSpacer, rowSpacer, sectionSpacers, cutoffRow)
    startRowIndex = rowSpacer;
    colIndex = colSpacer + 1;
    
    excelColHeaders = getExcelColHeaders();
    
    for i=1:length(testResults)
        metricTestResults = testResults{i};
    
        sectionRowIndex = startRowIndex;
        
        excelColHeader = excelColHeaders{colIndex + (i-1)};
                
        for j=1:length(metricTestResults) % num tests
            sectionRowIndex = sectionRowIndex + sectionSpacers(j);
            
            singleTestResults = metricTestResults{j};
            
            for k=1:length(singleTestResults) % go through results from test
                if k == 1
                    pValRow = sectionRowIndex + (k-1) + 1;
                    
                    output = ['=', excelColHeader, num2str(pValRow), '<=', excelColHeader, num2str(cutoffRow)];
                else
                    output = singleTestResults(k);
                end
                
                testOutput{sectionRowIndex + (k-1), colIndex + (i-1)} = output;
            end
        end
    end

end

% placeHValueCutoffs
function [testOutput, cutoffRow] = placeHValueCutoffs(testOutput, colSpacer, rowSpacer, colHeaders, metricTypes)

excelColNames = getExcelColHeaders();

rowIndex = rowSpacer + 1;
colIndex = colSpacer + 1;

cutoffRow = rowIndex+1;

numComparisons = length(colHeaders);

for i=1:length(metricTypes)
    metricType = metricTypes(i);
    
    numConnections = metricType.numConnections;
    useCircStats = metricType.getUseCircStats();
    
    for j=1:length(useCircStats)
        testOutput{rowIndex, colIndex} = numConnections;
        
        excelColName = excelColNames{colIndex};
        
        for k=1:numComparisons
            testOutput{cutoffRow, colIndex} = [...
                '=',...
                num2str(Constants.P_VALUE_CUTOFF),...
                '/',...
                excelColName,...
                num2str(rowIndex)];
            
            colIndex = colIndex + 1;
        end        
    end
end
    

end



