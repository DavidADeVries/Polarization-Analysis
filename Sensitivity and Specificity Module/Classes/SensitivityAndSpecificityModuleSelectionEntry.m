classdef SensitivityAndSpecificityModuleSelectionEntry
    % SensitivityAndSpecificityModuleSelectionEntry
    
    properties
        label = '';
        indices = []; %list of indices to get the location
        
        isSelected = false;
        isLocation = false;
        
        object = [];
        
        toPath = '';
        
        exclusionReason = '';
    end
    
    methods
        function entry = SensitivityAndSpecificityModuleSelectionEntry(label, indices, object, isLocation)
            entry.label = label;
            entry.indices = indices;
            entry.object = object;
            
            if nargin == 4
                entry.isLocation = isLocation;
            end
        end
        
        function fields = getAdditionalFields(entry)
            fields = struct('exclusionReason', entry.exclusionReason);
        end
    end
    
end

