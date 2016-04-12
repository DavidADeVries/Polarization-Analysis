function progressStrings = getProgressStrings(locationSelectStructure)
%getProgressStrings

numEntries = length(locationSelectStructure);

progressStrings = cell(numEntries, 1);

for i=1:numEntries
    entry = locationSelectStructure{i};
    
    if entry.isLocation
        if entry.isSelected
            progressStrings{i} = 'Selected';
        else
            progressStrings{i} = 'Not Selected';
        end
        
        if entry.isValidated
            progressStrings{i} = 'Validated';
        end
    else        
        progressStrings{i} = ' '; %display nothing
    end
end


end

