classdef SubsectionStatisticsModuleSelectionEntry
    % SubsectionStatisticsModuleSelectionEntry
    
    properties
        label = '';
        indices = []; %list of indices to get the location
        
        isSelected = false;
        isSession = false;
        
        session = Session.empty;
        
        toPath = '';
    end
    
    methods
        function entry = SubsectionStatisticsModuleSelectionEntry(label, indices, isSession, session)
            entry.label = label;
            entry.indices = indices;
            
            if nargin > 2
                entry.isSession = isSession;
                entry.session = session;
            end
        end
    end
    
end

