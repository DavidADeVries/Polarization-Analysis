classdef QuarterNamingConventions
    %QuarterNamingConventions
    
    properties (Constant)
        DIR_PREFIX = 'Q';
        DIR_NUM_DIGITS = 2;
        
        NAVI_LISTBOX_PREFIX = 'Quarter';
        
        METADATA_FILENAME = 'quarter_metadata.mat';
        
        DATA_FILENAME_LABEL = 'Q';
                
        % Metadata Defaults
        DEFAULT_METADATA_GUI_STAIN = 'Thioflavin S and Dapi';        
        DEFAULT_METADATA_GUI_SLIDE_MATERIAL = 'Glass';
    end
    
    
end

