classdef SessionNamingConventions
    %SessionNamingConventions
    
    properties (Constant)
        DATA_COLLECTION_DIR_PREFIX = 'CS';
        DATA_PROCESSING_DIR_PREFIX = 'PS';
                
        DIR_NUM_DIGITS = 3;
        
        DATA_COLLECTION_NAVI_LISTBOX_PREFIX = 'Collection Session';
        DATA_PROCESSING_NAVI_LISTBOX_PREFIX = 'Processing Session';
        
        METADATA_FILENAME = 'session_metadata.mat';
        
        DATA_COLLECTION_DATA_FILENAME_LABEL = 'CS';
        DATA_PROCESSING_DATA_FILENAME_LABEL = 'PS';
    end
    
end

