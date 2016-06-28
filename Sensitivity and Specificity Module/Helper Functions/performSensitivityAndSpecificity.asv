function trial = performSensitivityAndSpecificity(trial, selectStructure, projectPath, userName, notes, rejected,  rejectedReason, rejectedBy)
% performSubsectionStatistics

subjectIndices = [];
locationIndicesForSubjects = {};

subjectCounter = 1;

locationIndices = [];
subjectIndex = 0;

for i=1:length(selectStructure)
    entry = selectStructure{i};
            
    if entry.isLocation && entry.isSelected
        
        locationIndices(length(locationIndices)+1) = i;
        
    end
           
    if length(entry.indices) == 1 || i == length(selectStructure)% must be subject
        
        if ~isempty(locationIndices)
            subjectIndices(subjectCounter) = subjectIndex;
            locationIndicesForSubjects{subjectCounter} = locationIndices;
            
            locationIndices = [];
            
            subjectCounter = subjectCounter + 1;
        end
        
        subjectIndex = i;
    end
end



% set output

colHeaders = {'UUID', 'Label', 'AD Positive', 'Fluorescence Signal', 'Crossed Polarizers Signal', 'True Positive', 'False Positive', 'False Negative', 'True Negative'};

output = {};

for i=1:length(colHeaders)
    output{1,i} = colHeaders{i};
end


rowIndex = 2;

adPositiveIndex = 'C';
fluoroSignalIndex = 'D';
polarSignalIndex = 'E';

truePosIndex = 'F';
trueNegIndex = 'G';
falsePosIndex = 'H';
falseNegIndex = 'I';

subjectRowIndices = [];

for i=1:length(subjectIndices)
    subjectEntry = selectStructure{subjectIndices(i)};
    
    locationIndices = locationIndicesForSubjects{i};
    
    subject = trial.subjects{subjectEntry.indices(1)};
    
    output{rowIndex,1} = subject.uuid;
    output{rowIndex,2} = trial.getFilenameSections(subjectEntry.indices);
    output{rowIndex,3} = convertBoolToExcelBool(subject.isADPositive());
    
    numLocations = length(locationIndices);
    
    output{rowIndex,4} = ['=OR(', fluoroSignalIndex, num2str(rowIndex+1), ':', fluoroSignalIndex, num2str(rowIndex+numLocations), ')'];
    output{rowIndex,5} = ['=OR(', polarSignalIndex, num2str(rowIndex+1), ':', polarSignalIndex, num2str(rowIndex+numLocations), ')'];
    
    rowString = num2str(rowIndex);
    
    output{rowIndex,6} = ['=AND(', adPositiveIndex, rowString, ',', fluoroSignalIndex, rowString, ')'];
    output{rowIndex,7} = ['=AND(', 'NOT(', adPositiveIndex, rowString, '),', fluoroSignalIndex, rowString, ')'];
    output{rowIndex,8} = ['=AND(', adPositiveIndex, rowString, ',NOT(', fluoroSignalIndex, rowString, '))'];    
    output{rowIndex,9} = ['=AND(', 'NOT(', adPositiveIndex, rowString, '),NOT(', fluoroSignalIndex, rowString, '))'];
    
    subjectRowIndices(i) = rowIndex;
    
    rowIndex = rowIndex + 1;
    
    % location rows
    for j=1:numLocations
        entry = selectStructure{locationIndices(j)};
        
        location = entry.location;
        
        rowString = num2str(rowIndex);
        
        microscopeSession = location.getMicroscopeSession();
        
        output{rowIndex,1} = microscopeSession.uuid;
        
        filenameSections = trial.getFilenameSections(entry.indices);
        filenameSections = [filenameSections, microscopeSession.generateFilenameSection()];
        
        output{rowIndex,2} = filenameSections;
        output{rowIndex,3} = ' ';
        
        output{rowIndex,4} = convertBoolToExcelBool(microscopeSession.fluoroSignature());
        output{rowIndex,5} = convertBoolToExcelBool(microscopeSession.crossedSignature());
        
        output{rowIndex,6} = ['=AND(', fluoroSignalIndex, rowString, ',', polarSignalIndex, rowString, ')'];
        output{rowIndex,7} = ['=AND(', 'NOT(', fluoroSignalIndex, rowString, '),', polarSignalIndex, rowString, ')'];
        output{rowIndex,8} = ['=AND(', fluoroSignalIndex, rowString, ',NOT(', polarSignalIndex, rowString, '))'];
        output{rowIndex,9} = ['=AND(', 'NOT(', fluoroSignalIndex, rowString, '),NOT(', polarSignalIndex, rowString, '))'];
        
        rowIndex = rowIndex + 1;
    end
    
end


startRowString = num2str(2);
endRowString = num2str(rowIndex - 1);

% sensitivity and specificity calculations

colIndex = length(colHeaders) + 2;
sumColAlphaIndex = 'L';

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

% set by deposit formulae

output{8, colIndex + 1} = ['=COUNTIF(', truePosIndex, startRowString, ':', truePosIndex, endRowString, ',TRUE) - ', sumColAlphaIndex, num2str(2)];
output{9, colIndex + 1} = ['=COUNTIF(', trueNegIndex, startRowString, ':', trueNegIndex, endRowString, ',TRUE) - ', sumColAlphaIndex, num2str(3)];
output{10, colIndex + 1} = ['=COUNTIF(', falsePosIndex, startRowString, ':', falsePosIndex, endRowString, ',TRUE) - ', sumColAlphaIndex, num2str(4)];
output{11, colIndex + 1} = ['=COUNTIF(', falseNegIndex, startRowString, ':', falseNegIndex, endRowString, ',TRUE) - ', sumColAlphaIndex, num2str(5)];


% create session

sessionNumber = trial.nextSessionNumber();
dataProcessingSessionNumber = trial.nextDataProcessingSessionNumber();

toTrialPath = trial.dirName;

analysisSession = SensitivityAndSpecificityAnalysisSession(sessionNumber, dataProcessingSessionNumber, toTrialPath, projectPath, userName, notes, rejected, rejectedReason, rejectedBy);

toTrialFilename = trial.generateFilenameSection();

analysisSession.writeSensitivityAndSpecificityFile(toTrialFilename, toTrialPath, projectPath, output);

trial = trial.addSession(analysisSession);

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

function string = convertBoolToExcelBool(bool)
    if bool
        string = 'TRUE';
    else
        string = 'FALSE';
    end
end