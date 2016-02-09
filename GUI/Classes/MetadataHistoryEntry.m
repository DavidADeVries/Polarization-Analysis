classdef MetadataHistoryEntry
    % MetadataHistoryEntry
    % used for recording changes done to metadata
    
    properties
        userName
        timestamp % stored in matlab serial time (# seconds since Jan 0, 0000)
    end
    
    methods
        function dateString = getDateString(entry)
            dateString = datestr(entry.timestamp);
        end
    end
    
end

