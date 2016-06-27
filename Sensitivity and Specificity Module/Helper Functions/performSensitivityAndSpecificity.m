function trial = performSensitivityAndSpecificity(trial, selectStructure, analysisType, projectPath, userName, notes, rejected,  rejectedReason, rejectedBy)
% performSubsectionStatistics

subjectIndices = [];
locationIndicesForSubjects = {};

subjectCounter = 1;

locationIndices = [];
subjectIndex = 0;

for i=1:length(selectStructure)
    entry = selectStructure{i};
       
    if length(entry.indices) == 1
        
        if ~isempty(locationIndices)
            subjectIndices(subjectCounter) = subjectIndex;
            locationIndicesForSubjects{subjectCounter} = locationIndices;
            
            subjectCounter = subjectCounter + 1;            
        end
        
        subjectIndex = i;
        
    elseif entry.isLocation
        
        locationIndices(length(locationIndices)+1) = i;
        
    end
end

% set output

colHeaders = {'', 'AD Positive', 'Fluorescence Signal', 'Crossed Polarizers Signal', 'True Positive', 'True Negative', 'False Positive', 'False Negative'};

output = {};

for i=1:length(colHeaders)
    output{1,i} = colHeaders{i};
end


rowIndex = 2;

labelColIndex = 'A';

adPositiveIndex = 'B';
fluoroSignalIndex = 'C';
polarSignalIndex = 'D';

truePosIndex = 'E';
trueNegIndex = 'F';
falsePosIndex = 'G';
falseNegIndex = 'H';

subjectRowIndices = '';

for i=1:length(subjectIndices)
    subjectEntry = selectStructure{subjectIndices(i)};
    
    locationIndices = locationIndicesForSubject{i};
    
    subject = trial.getSubject(subjectEntry.indices);
    
    output{rowIndex,1} = subject.generateFilenameSection;
    output{rowIndex,2} = subject.isADPositive();
    
    numLocations = length(locationIndices);
    
    output{rowIndex,3} = ['OR(', fluoroSignalIndex, num2str(rowIndex+1), ':', fluoroSignalIndex, num2str(rowIndex+numLocations), ')'];
    output{rowIndex,4} = ['OR(', polarSignalIndex, num2str(rowIndex+1), ':', polarSignalIndex, num2str(rowIndex+numLocations), ')'];
    
    rowString = num2str(rowIndex);
    
    output{rowIndex,5} = ['AND(', adPositiveIndex, rowString, ',', fluoroSignalIndex, rowString, ')'];
    output{rowIndex,6} = ['AND(', 'NOT(', adPositiveIndex, rowString, '),', fluoroSignalIndex, rowString, ')'];
    output{rowIndex,7} = ['AND(', adPositiveIndex, rowString, ',NOT(', fluoroSignalIndex, rowString, '))'];    
    output{rowIndex,6} = ['AND(', 'NOT(', adPositiveIndex, rowString, ')NOT(,', fluoroSignalIndex, rowString, '))'];
    
    subjectRowIndices(i) = rowIndex;
    
    rowIndex = rowIndex + 1;
    
    % location rows
    for j=1:numLocations
        rowString = num2str(rowIndex);
        
        output{rowIndex,1} = '';
        
        output{rowIndex,3} = location.hasFluorescenceSignal();
        output{rowIndex,4} = location.hasCrossedPolarizerSginal();
        
        output{rowIndex,5} = ['AND(', fluoroSignalIndex, rowString, ',', polarSignalIndex, rowString, ')'];
        output{rowIndex,6} = ['AND(', 'NOT(', fluoroSignalIndex, rowString, '),', polarSignalIndex, rowString, ')'];
        output{rowIndex,7} = ['AND(', fluoroSignalIndex, rowString, ',NOT(', polarSignalIndex, rowString, '))'];
        output{rowIndex,6} = ['AND(', 'NOT(', fluoroSignalIndex, rowString, ')NOT(,', polarSignalIndex, rowString, '))'];
        
        rowIndex = rowIndex + 1;
    end
    
    startRowString = num2str(2);
    endRowString = num2str(rowIndex - 1);
    
    % sensitivity and specificity calculations
    
    
    
    
    colIndex = length(colHeaders) + 2;
    sumColAlphaIndex = 'K';
    
    rowIndex = 1;    
    header = 'By Subject';
            
    output = setCalcLabels(output, header, rowIndex, colIndex, sumColAlphaIndex);
    
    rowIndex = 7;    
    header = 'By Deposit';
            
    output = setCalcLabels(output, header, rowIndex, colIndex, sumColAlphaIndex);
    
    % set by subject sum formulae
    
    output{2, colIndex + 1} = createSubjectSumString(subjectRowIndices, truePosIndex);
    output{3, colIndex + 1} = createSubjectSumString(subjectRowIndices, trueNegIndex);
    output{4, colIndex + 1} = createSubjectSumString(subjectRowIndices, falsePosIndex);
    output{5, colIndex + 1} = createSubjectSumString(subjectRowIndices, falseNegIndex);
    
    % set by
    
    output{8, colIndex + 1} = ['=SUM(', truePosIndex, startRowString, ':', truePosIndex, endRowString, ') - ', colIndex + 1, num2str(2)];
    output{9, colIndex + 1} = ['=SUM(', trueNegIndex, startRowString, ':', trueNegIndex, endRowString, ') - ', colIndex + 1, num2str(3)];
    output{10, colIndex + 1} = ['=SUM(', falsePosIndex, startRowString, ':', trueNegIndex, endRowString, ') - ', colIndex + 1, num2str(4)];
    output{11, colIndex + 1} = ['=SUM(', falseNegIndex, startRowString, ':', trueNegIndex, endRowString, ') - ', colIndex + 1, num2str(5)];
end


end


function output = setCalcLabels(output, header, rowIndex, colIndex, sumColAlphaIndex)
    sumLabels = {'Num True Positives', 'Num False Positives', 'Num False Negatives', 'Num True Negatives'};    
    calcLabels = {'Sensitivity', 'Specificity', 'Negative Predicitive Power', 'Positive Predicitive Power'};
    
    output{rowIndex,colIndex} = header;
    
    for i=1:length(sumLabels)
        output{rowIndex+i,colIndex} = sumLabels{i};
    end
    
    for i=1:length(calcLabels)
        output{rowIndex+i,colIndex+3} = calcLabels{i};        
    end
    
    truePosIndex = [sumColAlphaIndex, num2str(rowIndex + 1)];
    falsePosIndex = [sumColAlphaIndex, num2str(rowIndex + 2)];
    falseNegIndex = [sumColAlphaIndex, num2str(rowIndex + 3)];
    trueNegIndex = [sumColAlphaIndex, num2str(rowIndex + 4)];
    
    % SENSITIVITY
    output{rowIndex+1,colIndex+4} = ['=100*(', truePosIndex, '/(', truePosIndex, '+', falseNegIndex, '))'];
    output{rowIndex+2,colIndex+4} = ['=100*(', trueNegIndex, '/(', trueNegIndex, '+', falsePosIndex, '))'];
    output{rowIndex+3,colIndex+4} = ['=100*(', trueNegIndex, '/(', trueNegIndex, '+', falseNegIndex, '))'];
    output{rowIndex+4,colIndex+4} = ['=100*(', truePosIndex, '/(', truePosIndex, '+', falsePosIndex, '))'];
end

function string = createSubjectSumString(subjectRowIndices, colAlphaIndex)
    string = '=SUM(';
    
    numSubjects = length(subjectRowIndices);
    
    for i=1:numSubjects
        newString = ['IF(', colAlphaIndex, num2str(subjectRowIndices(i)), ',1,0)'];
        
        if i ~= numSubjects
            newString = [newString, ','];
        end
        
        string = [string, newString];
    end
    
    string = [string, ')'];
end