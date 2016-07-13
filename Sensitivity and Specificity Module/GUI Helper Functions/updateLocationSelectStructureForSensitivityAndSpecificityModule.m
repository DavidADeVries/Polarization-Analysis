function locationSelectStructure = updateLocationSelectStructureForSensitivityAndSpecificityModule(locationSelectStructure, clickedIndex)
% updateLocationSelectStructureForSubsectionStatisticsModule

startingEntry = locationSelectStructure{clickedIndex};

startingIndexLength = length(startingEntry.indices);

startingIsSelected = ~startingEntry.isSelected;

startingEntry.isSelected = startingIsSelected;

cancel = false;

if length(startingEntry.indices) == 1 %is top level (aka a subject)
    prompt = ['Enter exclusion reason for ', startingEntry.label, ':'];
    title = 'Exclusion Reason';
    
    answer = inputdlg(prompt, title);
    
    if isempty(answer)
        cancel = true;
    else
        startingEntry.subjectExclusionReason = answer;
    end
end

if ~cancel
    
    locationSelectStructure{clickedIndex} = startingEntry;
    
    % ripple down change to any structures below the selected (aka selecting
    % eye selects all quarters/locations
    
    for i=clickedIndex+1:length(locationSelectStructure)
        entry = locationSelectStructure{i};
        
        if length(entry.indices) > startingIndexLength %is below starting level
            entry.isSelected = startingIsSelected;
            
            locationSelectStructure{i} = entry;
        else
            break;
        end
    end
end


end
