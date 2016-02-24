classdef SessionNamingConventions
    %SessionNamingConventions
    
    properties (Constant)
        DATA_COLLECTION_DIR_PREFIX = 'Collection Session';
        DATA_PROCESSING_DIR_PREFIX = 'Processing Session';
                
        DIR_NUM_DIGITS = 3;
        
        METADATA_FILENAME = 'session_metadata.mat';
        DATA_FILENAME_LABEL = 'S';
        
        MICROSCOPE_DIR_SUBTITLE = 'Microscope';
        LEGACY_SUBSECTION_SELECTION_DIR_SUBTITLE = 'Legacy Subsection -';
        LEGACY_REGISTRATION_DIR_SUBTITLE = 'Legacy Registration';
    end
    
end

