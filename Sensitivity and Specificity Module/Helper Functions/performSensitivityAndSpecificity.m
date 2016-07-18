function trial = performSensitivityAndSpecificity(trial, selectStructure, userName, analysisReason, analysisTitle, notes, rejected,  rejectedReason, rejectedBy)
% performSubsectionStatistics

trial = trial.applySelections(selectStructure);

% OUTPUT FOR DATA SHEET

% set data output

colHeaders = {'UUID', 'Label', 'AD Positive', 'Fluorescence Signal', 'Crossed Polarizers Signal', 'True Positive', 'False Positive', 'False Negative', 'True Negative', '0/1 Retinas +', '1/1 Retinas', '0/2 Retinas +', '1/2 Retinas +', '0/2 Retinas +'};

dataSheetOutput = {};

for i=1:length(colHeaders)
    dataSheetOutput{1,i} = colHeaders{i};
end

startRowIndex = 2;

dataSheetOutput = trial.placeSensitivityAndSpecificityData(dataSheetOutput, startRowIndex);



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

analysisSession.writeSensitivityAndSpecificityFile(dataSheetOutput);

trial = trial.addSession(analysisSession);




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

