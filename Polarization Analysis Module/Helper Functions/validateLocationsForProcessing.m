function [isValidated, selectionStructure] = validateLocationsForProcessing(selectedTrial, selectionStructure, useOnlyRegisteredData, autoUseMostRecentData, autoIgnoreRejectedSessions, doNotRerunDataAboveCutoff, versionCutoff, processFullFieldData, subsectionChoices, rawDataSources)
% validateLocationsForProcessing

isValidated = true;

numEntries = length(selectionStructure);

for i=1:numEntries
    entry = selectionStructure{i};
    
    if entry.isLocation && entry.isSelected && ~entry.isValidated
        entry = selectedTrial.validateLocation(entry, useOnlyRegisteredData, autoUseMostRecentData, autoIgnoreRejectedSessions, doNotRerunDataAboveCutoff, versionCutoff, processFullFieldData, subsectionChoices, rawDataSources);
        
        if entry.isValidated
            selectionStructure{i} = entry;
        else
            isValidated = false;
            break;
        end
    end
end


end

