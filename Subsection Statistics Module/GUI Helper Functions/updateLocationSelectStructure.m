function locationSelectStructure = updateLocationSelectStructure(locationSelectStructure, clickedIndex, comparisonType, skipRejectedSession)
% updateLocationSelectStructure

startingEntry = locationSelectStructure{clickedIndex};

startingIndexLength = length(startingEntry.indices);

startingIsSelected = ~startingEntry.isSelected;

startingEntry.isSelected = startingIsSelected;

locationSelectStructure{clickedIndex} = startingEntry;

% ripple down change to any structures below the selected (aka selecting
% eye selects all quarters/locations
for i=clickedIndex+1:length(locationSelectStructure)
    entry = locationSelectStructure{i};
    
    if length(entry.indices) > startingIndexLength %is below starting level
        if entry.isSession
            sessions = {entry.session};
            counter = 2;
            
            sessionIndexLength = length(entry.indices);
            
            for j=i+1:length(locationSelectStructure)
                sessionEntry = locationSelectStructure{j};
                
                if length(sessionEntry.indices) == sessionIndexLength
                    sessions{counter} = sessionEntry.session;
                    counter = counter + 1;
                else
                    break;
                end
            end
            
            indices = 1:counter;
            
            if skipRejectedSession
                indices = removeRejectedSessions(indices, sessions);
            end
            
            % YOU"RE HERE!
            
            % update the counter to adjust for this
            i = j-1;
        else
            entry.isSelected = startingIsSelected;
            
            locationSelectStructure{i} = entry;
        end
    else
        break;
    end
end


end



function newIndices = removeRejectedSessions(indices, sessions)
    newIndices = [];
    counter = 1;
        
    for i=1:length(sessions)
        if ~sessions{i}.isRejected
            newIndices(counter) = indices(i);
            counter = counter + 1;
        end
    end
end