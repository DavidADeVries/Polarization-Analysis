function trial = performSensitivityAndSpecificity(trial, selectStructure, userName, analysisReason, analysisTitle, notes, rejected,  rejectedReason, rejectedBy)
% performSubsectionStatistics

selectTrial = trial.applySelections(selectStructure);

% OUTPUT FOR DATA SHEET

% create session

sessionNumber = trial.nextSessionNumber();
dataProcessingSessionNumber = trial.nextDataProcessingSessionNumber();

analysisSession = SensitivityAndSpecificityAnalysisSession(...
    trial,...
    sessionNumber,...
    dataProcessingSessionNumber,...
    userName,...
    analysisReason,...
    analysisTitle,...
    notes,...
    rejected,...
    rejectedReason,...
    rejectedBy);


% set data output

colHeaders = {'UUID', 'Label', 'AD Positive', 'Fluorescence Signal', 'Crossed Polarizers Signal', 'True Positive', 'False Positive', 'False Negative', 'True Negative', '0/1 Retinas +', '1/1 Retinas', '0/2 Retinas +', '1/2 Retinas +', '0/2 Retinas +'};

dataSheetOutput = {};

for i=1:length(colHeaders)
    dataSheetOutput{1,i} = colHeaders{i};
end

startRowIndex = 2;

[dataSheetOutput, subjectRowIndices, eyeRowIndices, endRowIndex] = selectTrial.placeSensitivityAndSpecificityData(dataSheetOutput, startRowIndex);


% set results output


resultsSheetOutput = placeSensitivityAndSpecificityResults(subjectRowIndices, eyeRowIndices, endRowIndex, analysisSession, trial);


% write files

analysisSession.writeSensitivityAndSpecificityFile(dataSheetOutput, resultsSheetOutput);

trial = trial.addSession(analysisSession);




end



function resultsSheetOutput = placeSensitivityAndSpecificityResults(subjectRowIndices, eyeRowIndices, lastIndex, analysisSession, trial)

resultsSheetOutput = {};

% SET HEADER

resultsSheetOutput{1,1} = 'Sensitivity and Specificity Analysis';

resultsSheetOutput{2,1} = 'Trial:';
resultsSheetOutput{2,2} = trial.naviListboxLabel;

resultsSheetOutput{3,1} = 'Analysis Title:';
resultsSheetOutput{3,2} = analysisSession.analysisTitle;

resultsSheetOutput{4,1} = 'Analysis Reason';
resultsSheetOutput{4,2} = analysisSession.analysisReason;

resultsSheetOutput{5,1} = 'Notes:';
resultsSheetOutput{5,2} = analysisSession.notes;

resultsSheetOutput{6,1} = 'Analysis Date:';
resultsSheetOutput{6,2} = displayDateAndTime(analysisSession.sessionDate);

resultsSheetOutput{7,1} = 'Analysis Done By:';
resultsSheetOutput{7,2} = analysisSession.sessionDoneBy;

% common column indices

truePosColIndex = 6;
falsePosColIndex = 7;
falseNegColIndex = 8;
trueNegColIndex = 9;
    
dataSheetName = [SensitivityAndSpecificityAnalysisNamingConventions.DATA_SHEET_NAME, '!'];

% SET BY SUBJECT RESULTS

rowIndices = subjectRowIndices;
subtractRowIndices = [];

subjectPosConditionColIndex = 3; % AD Positive
predictPosConditionColIndex = 4; % Fluoro

subjectStartingRowIndex = 10;

header = 'BY SUBJECT:';

[resultsSheetOutput] = placeResultSection(...
    resultsSheetOutput,...
    header,...
    subjectStartingRowIndex,...
    rowIndices,...
    subjectPosConditionColIndex,...
    predictPosConditionColIndex,...
    truePosColIndex,...
    falsePosColIndex,...
    falseNegColIndex,...
    trueNegColIndex,...
    subtractRowIndices,...
    lastIndex,...
    dataSheetName);

% SET BY EYE RESULTS

rowIndices = eyeRowIndices;
subtractRowIndices = [];

posConditionColIndex = 3; % AD Positive
predictPosConditionColIndex = 4; % Fluoro

eyeStartingRowIndex = 16;

header = 'BY EYE:';

[resultsSheetOutput] = placeResultSection(...
    resultsSheetOutput,...
    header,...
    eyeStartingRowIndex,...
    rowIndices,...
    posConditionColIndex,...
    predictPosConditionColIndex,...
    truePosColIndex,...
    falsePosColIndex,...
    falseNegColIndex,...
    trueNegColIndex,...
    subtractRowIndices,...
    lastIndex,...
    dataSheetName);

% SET BY DEPOSIT RESULTS

rowIndices = [];
subtractRowIndices = [subjectStartingRowIndex, eyeStartingRowIndex];

posConditionColIndex = 4; % Fluoro
predictPosConditionColIndex = 5; % Crossed Polarizers

startingRowIndex = 22;

header = 'BY DEPOSIT:';

[resultsSheetOutput] = placeResultSection(...
    resultsSheetOutput,...
    header,...
    startingRowIndex,...
    rowIndices,...
    posConditionColIndex,...
    predictPosConditionColIndex,...
    truePosColIndex,...
    falsePosColIndex,...
    falseNegColIndex,...
    trueNegColIndex,...
    subtractRowIndices,...
    lastIndex,...
    dataSheetName);

% SET SUBJECT EYE COMPARISON

colHeaders = getExcelColHeaders();

% col headers
resultsSheetOutput{subjectStartingRowIndex + 1, 17} = ['=', dataSheetName, colHeaders{10}, num2str(1)];
resultsSheetOutput{subjectStartingRowIndex + 1, 18} = ['=', dataSheetName, colHeaders{11}, num2str(1)];
resultsSheetOutput{subjectStartingRowIndex + 1, 19} = ['=', dataSheetName, colHeaders{12}, num2str(1)];
resultsSheetOutput{subjectStartingRowIndex + 1, 20} = ['=', dataSheetName, colHeaders{13}, num2str(1)];
resultsSheetOutput{subjectStartingRowIndex + 1, 21} = ['=', dataSheetName, colHeaders{14}, num2str(1)];

% row headers
resultsSheetOutput{subjectStartingRowIndex + 2, 16} = ['=', colHeaders{2}, num2str(subjectStartingRowIndex + 1)];
resultsSheetOutput{subjectStartingRowIndex + 3, 16} = ['=CONCATENATE("NOT ",', colHeaders{2}, num2str(subjectStartingRowIndex + 1),')'];
resultsSheetOutput{subjectStartingRowIndex + 4, 16} = 'SUM';

% formulas
startRowStr = num2str(2);
endRowStr = num2str(lastIndex);
condStr = '"=1"'; % for excel countifs func

positiveCondition = [dataSheetName, colHeaders{subjectPosConditionColIndex}, startRowStr, ':', colHeaders{subjectPosConditionColIndex}, endRowStr, ',', condStr];

resultsSheetOutput{subjectStartingRowIndex + 2, 17} = ['=COUNTIFS(',positiveCondition,',',dataSheetName, colHeaders{10}, startRowStr, ':', colHeaders{10}, endRowStr, ',', condStr, ')'];
resultsSheetOutput{subjectStartingRowIndex + 2, 18} = ['=COUNTIFS(',positiveCondition,',',dataSheetName, colHeaders{11}, startRowStr, ':', colHeaders{11}, endRowStr, ',', condStr, ')'];
resultsSheetOutput{subjectStartingRowIndex + 2, 19} = ['=COUNTIFS(',positiveCondition,',',dataSheetName, colHeaders{12}, startRowStr, ':', colHeaders{12}, endRowStr, ',', condStr, ')'];
resultsSheetOutput{subjectStartingRowIndex + 2, 20} = ['=COUNTIFS(',positiveCondition,',',dataSheetName, colHeaders{13}, startRowStr, ':', colHeaders{13}, endRowStr, ',', condStr, ')'];
resultsSheetOutput{subjectStartingRowIndex + 2, 21} = ['=COUNTIFS(',positiveCondition,',',dataSheetName, colHeaders{14}, startRowStr, ':', colHeaders{14}, endRowStr, ',', condStr, ')'];

negativeCondition = [dataSheetName, colHeaders{subjectPosConditionColIndex}, startRowStr, ':', colHeaders{subjectPosConditionColIndex}, endRowStr, ',', '"=0"'];

resultsSheetOutput{subjectStartingRowIndex + 3, 17} = ['=COUNTIFS(',negativeCondition,',',dataSheetName, colHeaders{10}, startRowStr, ':', colHeaders{10}, endRowStr, ',', condStr, ')'];
resultsSheetOutput{subjectStartingRowIndex + 3, 18} = ['=COUNTIFS(',negativeCondition,',',dataSheetName, colHeaders{11}, startRowStr, ':', colHeaders{11}, endRowStr, ',', condStr, ')'];
resultsSheetOutput{subjectStartingRowIndex + 3, 19} = ['=COUNTIFS(',negativeCondition,',',dataSheetName, colHeaders{12}, startRowStr, ':', colHeaders{12}, endRowStr, ',', condStr, ')'];
resultsSheetOutput{subjectStartingRowIndex + 3, 20} = ['=COUNTIFS(',negativeCondition,',',dataSheetName, colHeaders{13}, startRowStr, ':', colHeaders{13}, endRowStr, ',', condStr, ')'];
resultsSheetOutput{subjectStartingRowIndex + 3, 21} = ['=COUNTIFS(',negativeCondition,',',dataSheetName, colHeaders{14}, startRowStr, ':', colHeaders{14}, endRowStr, ',', condStr, ')'];

% sums

resultsSheetOutput{subjectStartingRowIndex + 4, 17} = ['=SUM(', colHeaders{17}, num2str(subjectStartingRowIndex + 2), ':', colHeaders{17}, num2str(subjectStartingRowIndex + 3), ')'];
resultsSheetOutput{subjectStartingRowIndex + 4, 18} = ['=SUM(', colHeaders{18}, num2str(subjectStartingRowIndex + 2), ':', colHeaders{18}, num2str(subjectStartingRowIndex + 3), ')'];
resultsSheetOutput{subjectStartingRowIndex + 4, 19} = ['=SUM(', colHeaders{19}, num2str(subjectStartingRowIndex + 2), ':', colHeaders{19}, num2str(subjectStartingRowIndex + 3), ')'];
resultsSheetOutput{subjectStartingRowIndex + 4, 20} = ['=SUM(', colHeaders{20}, num2str(subjectStartingRowIndex + 2), ':', colHeaders{20}, num2str(subjectStartingRowIndex + 3), ')'];
resultsSheetOutput{subjectStartingRowIndex + 4, 21} = ['=SUM(', colHeaders{21}, num2str(subjectStartingRowIndex + 2), ':', colHeaders{21}, num2str(subjectStartingRowIndex + 3), ')'];

end


function [resultsSheetOutput] = placeResultSection(resultsSheetOutput, header, startingRowIndex, rowIndices,  posConditionColIndex, predictPosConditionColIndex, truePosColIndex, falsePosColIndex, falseNegColIndex, trueNegColIndex, subtractRowIndices, lastIndex, dataSheetName)
    colHeaders = getExcelColHeaders();
    
    % set header
    resultsSheetOutput{startingRowIndex, 1} = header;
    
    % set positive conditions
    resultsSheetOutput{startingRowIndex + 1, 1} = 'Positive Condition:';
    resultsSheetOutput{startingRowIndex + 1, 2} = ['=', dataSheetName,colHeaders{posConditionColIndex}, num2str(1)];
    
    resultsSheetOutput{startingRowIndex + 2, 1} = 'Predicted Positive Condition:';
    resultsSheetOutput{startingRowIndex + 2, 2} = ['=', dataSheetName, colHeaders{predictPosConditionColIndex}, num2str(1)];
    
    % set num of true pos, false neg, etc.
    
    subtractColHeader = colHeaders{6};
    
    resultsSheetOutput{startingRowIndex + 1, 5} = '# True Positives:';
    resultsSheetOutput{startingRowIndex + 1, 6} = getSumEquation(rowIndices, colHeaders{truePosColIndex}, subtractRowIndices+1, lastIndex, subtractColHeader, dataSheetName);
    
    resultsSheetOutput{startingRowIndex + 2, 5} = '# False Positives:';
    resultsSheetOutput{startingRowIndex + 2, 6} = getSumEquation(rowIndices, colHeaders{falsePosColIndex}, subtractRowIndices+2, lastIndex, subtractColHeader, dataSheetName);
    
    resultsSheetOutput{startingRowIndex + 3, 5} = '# False Negatives:';
    resultsSheetOutput{startingRowIndex + 3, 6} = getSumEquation(rowIndices, colHeaders{falseNegColIndex}, subtractRowIndices+3, lastIndex, subtractColHeader, dataSheetName);
    
    resultsSheetOutput{startingRowIndex + 4, 5} = '# True Negatives:';
    resultsSheetOutput{startingRowIndex + 4, 6} = getSumEquation(rowIndices, colHeaders{trueNegColIndex}, subtractRowIndices+4, lastIndex, subtractColHeader, dataSheetName);
    
    % set sensitivity, specificity, etc.
    
    truePosCell = [colHeaders{6}, num2str(startingRowIndex + 1)];
    falsePosCell = [colHeaders{6}, num2str(startingRowIndex + 2)];
    falseNegCell = [colHeaders{6}, num2str(startingRowIndex + 3)];
    trueNegCell = [colHeaders{6}, num2str(startingRowIndex + 4)];
    
    resultsSheetOutput{startingRowIndex + 1, 8} = 'Sensitivity:';
    resultsSheetOutput{startingRowIndex + 1, 9} = ['=100*(',truePosCell,'/(',truePosCell,'+',falseNegCell,'))'];
    
    resultsSheetOutput{startingRowIndex + 2, 8} = 'Specificity:';
    resultsSheetOutput{startingRowIndex + 2, 9} = ['=100*(',trueNegCell,'/(',trueNegCell,'+',falsePosCell,'))'];
    
    resultsSheetOutput{startingRowIndex + 3, 8} = 'Negative Predictive Power:';
    resultsSheetOutput{startingRowIndex + 3, 9} = ['=100*(',trueNegCell,'/(',trueNegCell,'+',falseNegCell,'))'];
    
    resultsSheetOutput{startingRowIndex + 4, 8} = 'Positive Predictive Power:';
    resultsSheetOutput{startingRowIndex + 4, 9} = ['=100*(',truePosCell,'/(',truePosCell,'+',falsePosCell,'))'];
    
    % set number break downs
    
    posCondCell = [dataSheetName, colHeaders{2}, num2str(startingRowIndex + 1)];
    prePosCondCell = [dataSheetName, colHeaders{2}, num2str(startingRowIndex + 2)];
    
    resultsSheetOutput{startingRowIndex + 1, 12} = ['=', posCondCell];
    resultsSheetOutput{startingRowIndex + 1, 13} = ['=CONCATENATE("NOT ",', posCondCell,')'];
    resultsSheetOutput{startingRowIndex + 1, 14} = 'Sum';
    
    resultsSheetOutput{startingRowIndex + 2, 11} = ['=', prePosCondCell];
    resultsSheetOutput{startingRowIndex + 3, 11} = ['=CONCATENATE("NOT ",', prePosCondCell,')'];
    resultsSheetOutput{startingRowIndex + 4, 11} = 'Sum';
    
    resultsSheetOutput{startingRowIndex + 2, 12} = ['=', colHeaders{6}, num2str(startingRowIndex + 1)];
    resultsSheetOutput{startingRowIndex + 2, 13} = ['=', colHeaders{6}, num2str(startingRowIndex + 2)];
    resultsSheetOutput{startingRowIndex + 3, 12} = ['=', colHeaders{6}, num2str(startingRowIndex + 3)];
    resultsSheetOutput{startingRowIndex + 3, 13} = ['=', colHeaders{6}, num2str(startingRowIndex + 4)];
        
    resultsSheetOutput{startingRowIndex + 4, 12} = ['=SUM(',colHeaders{12}, num2str(startingRowIndex + 2),':',colHeaders{12}, num2str(startingRowIndex + 3),')']; % sum col 1
    resultsSheetOutput{startingRowIndex + 4, 13} = ['=SUM(',colHeaders{13}, num2str(startingRowIndex + 2),':',colHeaders{13}, num2str(startingRowIndex + 3),')']; % sum col 2
    
    resultsSheetOutput{startingRowIndex + 2, 14} = ['=SUM(',colHeaders{12}, num2str(startingRowIndex + 2),':',colHeaders{13}, num2str(startingRowIndex + 2),')']; % sum row 1
    resultsSheetOutput{startingRowIndex + 3, 14} = ['=SUM(',colHeaders{12}, num2str(startingRowIndex + 3),':',colHeaders{13}, num2str(startingRowIndex + 3),')']; % sum row 2
        
    resultsSheetOutput{startingRowIndex + 4, 14} = ['=SUM(',colHeaders{14}, num2str(startingRowIndex + 2),':',colHeaders{14}, num2str(startingRowIndex + 3),')']; % sum grand total
    
    
end


function sumEquation = getSumEquation(rowIndices, colHeader, subtractRowIndices, lastIndex, subtractColHeader, dataSheetName)

if ~isempty(rowIndices) && isempty(subtractRowIndices)
    sumEquation = '=SUM(';
    
    numIndices = length(rowIndices);
    
    for i=1:numIndices
        index = num2str(rowIndices(i));
        
        if i == numIndices
            comma = '';
        else
            comma = ',';
        end
        
        sumEquation = [sumEquation, dataSheetName, colHeader, index, comma];
    end
    
    sumEquation = [sumEquation,')'];
elseif isempty(rowIndices) && ~isempty(subtractRowIndices)
    sumEquation = ['=SUM(',dataSheetName,colHeader,num2str(2),':',colHeader,num2str(lastIndex),')'];
    
    for i=1:length(subtractRowIndices)
        index = num2str(subtractRowIndices(i));
        
        sumEquation = [sumEquation, ' - ', subtractColHeader, index ];
    end
else
    error('Either only one of rowIndices or subtractRowIndices');
end

end








% % OLD
% 
% subjectIndices = [];
% 
% eyeIndicesForSubjects = {};
% 
% locationIndicesForEyes = {};
% 
% subjectCounter = 1;
% 
% eyeIndices = [];
% locationIndices = [];
% subjectIndex = 0;
% 
% excludedSubjectUUIDs = {};
% excludedSubjectLabels = {};
% excludedSubjectReasons = {};
% 
% excludedCounter = 1;
% 
% for i=1:length(selectStructure)
%     entry = selectStructure{i};
%             
%     if entry.isLocation && entry.isSelected
%         
%         locationIndices(length(locationIndices)+1) = i;
%         
%     elseif length(entry.indices) == 2 %must be eye
%         
%         if ~isempty(locationIndices)
%             eyeIndicesForSubject(eyeCounter) = eyeIndex;
%             
%             
%             subjectIndices(subjectCounter) = subjectIndex;
%             locationIndicesForSubjects{subjectCounter} = locationIndices;
%             
%             locationIndices = [];
%             
%             subjectCounter = subjectCounter + 1;
%         end
%         
%         eyeIndex = i;
%     end
%            
%     if length(entry.indices) == 1 || i == length(selectStructure)% must be subject
%         
%         if ~isSelected % record why excluded
%             index = entry.indices(1);
%             
%             subject = trial.subjects{index};
%             
%             excludedSubjectUUIDs{excludedCounter} = subject.UUID;
%             excludedSubjectLabels{excludedCounter} = subject.naviListboxLabel;
%             excludedSubjectReasons{excludedCounter} = entry.subjectExclusionReason;
%             
%             excludedCounter = excludedCounter + 1;
%         else
%             
%             if ~isempty(locationIndices)
%             subjectIndices(subjectCounter) = subjectIndex;
%             locationIndicesForSubjects{subjectCounter} = eyeIndices;
%             
%             locationIndices = [];
%             
%             subjectCounter = subjectCounter + 1;
%         end
%         
%         subjectIndex = i;
%     end
% end
% 
% 
% 
% % set data output
% 
% colHeaders = {'UUID', 'Label', 'AD Positive', 'Fluorescence Signal', 'Crossed Polarizers Signal', 'True Positive', 'False Positive', 'False Negative', 'True Negative', '0/1 Retinas +', '1/1 Retinas +', '0/2 Retinas +', '1/2 Retinas +', '0/2 Retinas +'};
% 
% dataSheetOutput = {};
% 
% for i=1:length(colHeaders)
%     dataSheetOutput{1,i} = colHeaders{i};
% end
% 
% 
% rowIndex = 2;
% 
% adPositiveIndex = 'C';
% fluoroSignalIndex = 'D';
% polarSignalIndex = 'E';
% 
% truePosIndex = 'F';
% trueNegIndex = 'G';
% falsePosIndex = 'H';
% falseNegIndex = 'I';
% 
% subjectRowIndices = [];
% 
% for i=1:length(subjectIndices)
%     subjectEntry = selectStructure{subjectIndices(i)};
%     
%     locationIndices = locationIndicesForSubjects{i};
%     
%     subject = trial.subjects{subjectEntry.indices(1)};
%     
%     dataSheetOutput{rowIndex,1} = subject.uuid;
%     dataSheetOutput{rowIndex,2} = trial.getFilenameSections(subjectEntry.indices);
%     dataSheetOutput{rowIndex,3} = convertBoolToExcelBool(subject.isADPositive(trial));
%     
%     numLocations = length(locationIndices);
%     
%     dataSheetOutput{rowIndex,4} = ['=OR(', fluoroSignalIndex, num2str(rowIndex+1), ':', fluoroSignalIndex, num2str(rowIndex+numLocations), ')'];
%     dataSheetOutput{rowIndex,5} = ['=OR(', polarSignalIndex, num2str(rowIndex+1), ':', polarSignalIndex, num2str(rowIndex+numLocations), ')'];
%     
%     rowString = num2str(rowIndex);
%     
%     dataSheetOutput{rowIndex,6} = ['=AND(', adPositiveIndex, rowString, ',', fluoroSignalIndex, rowString, ')'];
%     dataSheetOutput{rowIndex,7} = ['=AND(', 'NOT(', adPositiveIndex, rowString, '),', fluoroSignalIndex, rowString, ')'];
%     dataSheetOutput{rowIndex,8} = ['=AND(', adPositiveIndex, rowString, ',NOT(', fluoroSignalIndex, rowString, '))'];    
%     dataSheetOutput{rowIndex,9} = ['=AND(', 'NOT(', adPositiveIndex, rowString, '),NOT(', fluoroSignalIndex, rowString, '))'];
%     
%     subjectRowIndices(i) = rowIndex;
%     
%     rowIndex = rowIndex + 1;
%     
%     % location rows
%     for j=1:numLocations
%         entry = selectStructure{locationIndices(j)};
%         
%         location = entry.location;
%         
%         rowString = num2str(rowIndex);
%         
%         microscopeSession = location.getMicroscopeSession();
%         
%         dataSheetOutput{rowIndex,1} = microscopeSession.uuid;
%         
%         filenameSections = trial.getFilenameSections(entry.indices);
%         filenameSections = [filenameSections, microscopeSession.generateFilenameSection()];
%         
%         dataSheetOutput{rowIndex,2} = filenameSections;
%         dataSheetOutput{rowIndex,3} = ' ';
%         
%         dataSheetOutput{rowIndex,4} = convertBoolToExcelBool(microscopeSession.fluoroSignature());
%         dataSheetOutput{rowIndex,5} = convertBoolToExcelBool(microscopeSession.crossedSignature());
%         
%         dataSheetOutput{rowIndex,6} = ['=AND(', fluoroSignalIndex, rowString, ',', polarSignalIndex, rowString, ')'];
%         dataSheetOutput{rowIndex,7} = ['=AND(', 'NOT(', fluoroSignalIndex, rowString, '),', polarSignalIndex, rowString, ')'];
%         dataSheetOutput{rowIndex,8} = ['=AND(', fluoroSignalIndex, rowString, ',NOT(', polarSignalIndex, rowString, '))'];
%         dataSheetOutput{rowIndex,9} = ['=AND(', 'NOT(', fluoroSignalIndex, rowString, '),NOT(', polarSignalIndex, rowString, '))'];
%         
%         rowIndex = rowIndex + 1;
%     end
%     
% end
% 
% 
% startRowString = num2str(2);
% endRowString = num2str(rowIndex - 1);
% 
% % sensitivity and specificity calculations
% 
% colIndex = length(colHeaders) + 2;
% sumColAlphaIndex = 'L';
% 
% rowIndex = 1;
% header = 'By Subject';
% 
% dataSheetOutput = setCalcLabels(dataSheetOutput, header, rowIndex, colIndex, sumColAlphaIndex);
% 
% rowIndex = 7;
% header = 'By Deposit';
% 
% dataSheetOutput = setCalcLabels(dataSheetOutput, header, rowIndex, colIndex, sumColAlphaIndex);
% 
% % set by subject sum formulae
% 
% dataSheetOutput{2, colIndex + 1} = createSubjectSumString(subjectRowIndices, truePosIndex);
% dataSheetOutput{3, colIndex + 1} = createSubjectSumString(subjectRowIndices, trueNegIndex);
% dataSheetOutput{4, colIndex + 1} = createSubjectSumString(subjectRowIndices, falsePosIndex);
% dataSheetOutput{5, colIndex + 1} = createSubjectSumString(subjectRowIndices, falseNegIndex);
% 
% % set by deposit formulae
% 
% dataSheetOutput{8, colIndex + 1} = ['=COUNTIF(', truePosIndex, startRowString, ':', truePosIndex, endRowString, ',TRUE) - ', sumColAlphaIndex, num2str(2)];
% dataSheetOutput{9, colIndex + 1} = ['=COUNTIF(', trueNegIndex, startRowString, ':', trueNegIndex, endRowString, ',TRUE) - ', sumColAlphaIndex, num2str(3)];
% dataSheetOutput{10, colIndex + 1} = ['=COUNTIF(', falsePosIndex, startRowString, ':', falsePosIndex, endRowString, ',TRUE) - ', sumColAlphaIndex, num2str(4)];
% dataSheetOutput{11, colIndex + 1} = ['=COUNTIF(', falseNegIndex, startRowString, ':', falseNegIndex, endRowString, ',TRUE) - ', sumColAlphaIndex, num2str(5)];
% 
% 
% 
% 
% end


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

