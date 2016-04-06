classdef SelectionEntry
    %SelectionEntry
    
    properties
        label = '';
        indices = {}; %list of indices to get the location
        
        isSelected = false;
        isLocation = false;
        
        isValidated = false;
        sessionsToProcess = []; %list of sessionNumbers
        
        toLocationPath = '';
    end
    
    methods
        function entry = SelectionEntry(label, indices, isLocation)
            entry.label = label;
            entry.indices = indices;
            
            if nargin > 2
                entry.isLocation = isLocation;
            end
        end
    end
    
end

