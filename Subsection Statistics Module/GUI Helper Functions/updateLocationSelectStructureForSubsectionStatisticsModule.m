function locationSelectStructure = updateLocationSelectStructureForSubsectionStatisticsModule(locationSelectStructure, clickedIndex, comparisonType, skipRejectedSession)
% updateLocationSelectStructureForSubsectionStatisticsModule

startingEntry = locationSelectStructure{clickedIndex};

startingIndexLength = length(startingEntry.indices);

startingIsSelected = ~startingEntry.isSelected;

startingEntry.isSelected = startingIsSelected;

locationSelectStructure{clickedIndex} = startingEntry;

% ripple down change to any structures below the selected (aka selecting
% eye selects all quarters/locations

i = clickedIndex + 1;

while i <= length(locationSelectStructure)
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
            
            checkedUntil = j;
            
            indices = 1:counter;
            
            if skipRejectedSession
                indices = removeRejectedSessions(indices, sessions);
            end
            
            
            if comparisonType == SubsectionComparisonTypes.subsectionComparison
                % need to find pos and neg crop areas
                posSubsectionIndices = [];
                posCount = 1;
                
                negSubsectionIndices = [];
                negCount = 1;
                
                for j=1:length(indices)
                    index = indices(j);
                    session = sessions{index};
                    
                    if session.isSubsectionSelectionSession()
                        if session.croppingType == CroppingTypes.positiveArea
                            posSubsectionIndices(posCount) = index;
                            posCount = posCount + 1;
                        elseif session.croppingType == CroppingTypes.negativeArea
                            negSubsectionIndices(negCount) = index;
                            negCount = negCount + 1;                            
                        end
                    end
                end
                
                if length(posSubsectionIndices) == 1 && length(negSubsectionIndices) == 1
                    posIndex = posSubsectionIndices(1);
                    negIndex = negSubsectionIndices(1);
                    
                    locationSelectStructure{i+posIndex-1}.isSelected = startingIsSelected;
                    locationSelectStructure{i+negIndex-1}.isSelected = startingIsSelected;
                end
            elseif comparisonType == SubsectionComparisonTypes.fluorescentSubsectionComparison
                fluoroSubsectionIndices = [];
                counter = 1;
                
                for j=1:length(indices)
                    index = indices(j);
                    session = sessions{index};
                    
                    if session.isFluorescentSubsectionSelectionSession()
                        fluoroSubsectionIndices(counter) = index;
                        counter = counter + 1;
                    end
                end
                
                if length(fluoroSubsectionIndices) == 1
                    index = fluoroSubsectionIndices(1);
                    
                    locationSelectStructure{i+index-1}.isSelected = startingIsSelected;
                end
            end
            
            
            % update the counter to adjust for this
            i = checkedUntil - 1;
        else
            entry.isSelected = startingIsSelected;
            
            locationSelectStructure{i} = entry;
        end
    else
        break;
    end
    
    i = i + 1; % increment
end


end



function newIndices = removeRejectedSessions(indices, sessions)
    newIndices = [];
    counter = 1;
        
    for i=1:length(sessions)
        if ~sessions{i}.rejected
            newIndices(counter) = indices(i);
            counter = counter + 1;
        end
    end
end