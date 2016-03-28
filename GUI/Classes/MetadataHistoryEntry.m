classdef MetadataHistoryEntry
    % MetadataHistoryEntry
    % used for recording changes done to metadata
    
    properties
        userName
        timestamp % stored in matlab serial time (# seconds since Jan 0, 0000)
        
        cachedObject % a version of the metadata object, with some fields wiped to preserve memory (e.g. for project object cached, trials would be cleaned out)
    end
    
    methods
        function entry = MetadataHistoryEntry(userName, cachedObject)
            if nargin > 0
                entry.userName = userName;
                entry.timestamp = now; % current serial date stamp
                
                entry.cachedObject = cachedObject;
            end
        end
        
        function dateString = getDateString(entry)
            dateString = displayDate(entry.timestamp);
        end
    end
    
end

