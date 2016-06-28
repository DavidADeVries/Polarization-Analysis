classdef SensitivityAndSpecificityModuleSelectionEntry
    % SensitivityAndSpecificityModuleSelectionEntry
    
    properties
        label = '';
        indices = []; %list of indices to get the location
        
        isSelected = false;
        isLocation = false;
        
        location = Location.empty;
        
        toPath = '';
    end
    
    methods
        function entry = SensitivityAndSpecificityModuleSelectionEntry(label, indices, isLocation, location)
            entry.label = label;
            entry.indices = indices;
            
            if nargin > 2
                entry.isLocation = isLocation;
                entry.location = location;
            end
        end
    end
    
end

