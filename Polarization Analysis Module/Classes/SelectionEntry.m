classdef SelectionEntry
    %SelectionEntry
    
    properties
        label = '';
        indices = {}; %list of indices to get the location
        selected = false;
    end
    
    methods
        function entry = SelectionEntry(label, indices)
            entry.label = label;
            entry.indices = indices;
        end
    end
    
end

