classdef SelectionEntry
    %SelectionEntry
    
    properties
        label = '';
        indices = []; %list of indices to get the location
        
        isSelected = false;
        isSession = false;
        
        isValidated = false;
        isProcessing = false;
        
        statusType = [];
        
        toPath = '';
        completedAnalysisPath = '';
    end
    
    methods
        function entry = SelectionEntry(label, indices, isSession)
            entry.label = label;
            entry.indices = indices;
            
            if nargin > 2
                entry.isSession = isSession;
            end
        end
    end
    
end

