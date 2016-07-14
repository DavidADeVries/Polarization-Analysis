classdef SensitivityAndSpecificityModuleSelectionEntry
    % SensitivityAndSpecificityModuleSelectionEntry
    
    properties
        label = '';
        indices = []; %list of indices to get the location
        
        isSelected = false;
        isLocation = false;
        
        object = [];
        
        toPath = '';
        
        subjectExclusionReason = '';
    end
    
    methods
        function entry = SensitivityAndSpecificityModuleSelectionEntry(label, indices, object, isLocation)
            entry.label = label;
            entry.indices = indices;
            
            if nargin > 2
                entry.isLocation = isLocation;
                entry.object = object;
            end
        end
    end
    
end

