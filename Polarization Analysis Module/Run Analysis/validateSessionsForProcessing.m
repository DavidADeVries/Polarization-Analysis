function [isValidated, selectionStructure] = validateSessionsForProcessing(selectedTrial, selectionStructure)
% validateSessionsForProcessing

isValidated = true;

numEntries = length(selectionStructure);

for i=1:numEntries
    entry = selectionStructure{i};
    
    if entry.isSession && entry.isSelected && ~entry.isValidated
        entry = selectedTrial.validateSession(entry);
        
        if entry.isValidated
            selectionStructure{i} = entry;
        else
            isValidated = false;
            break;
        end
    end
end


end

