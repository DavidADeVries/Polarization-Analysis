classdef Constants
    %Constants
    %holds constants for polarization anaylsis application
    
    properties (Constant)
        BACKUP_DIR = 'Raw Data Backup';
        
        METADATA_VAR = 'metadata';
        
        TAB = '    '; % used for spacing out folder directory lists
        SLASH = '\';
        
        BMP_EXT = '.bmp';
        ND2_EXT = '.nd2';
        MATLAB_EXT = '.mat';
        CSV_EXT = '.csv';
        XLSX_EXT = '.xlsx';
        PNG_EXT = '.png';
        
        FILENAME_SECTION_LEFT_BRACKET = '(';
        FILENAME_SECTION_RIGHT_BRACKET = ')';
        
        CIRC_STATS_LABEL = '(Circ)';
        NON_CIRC_STATS_LABEL = '(Non-Circ)';
                
        FIGURE_INIT_SIZE_WARNING_ID = 'images:initSize:adjustingMag';
        
        DEFAULT_EYE_TYPE = EyeTypes.Right;
        
    end
    
    methods
    end
    
end

