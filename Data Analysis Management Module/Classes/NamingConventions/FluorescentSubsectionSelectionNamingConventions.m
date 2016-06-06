classdef FluorescentSubsectionSelectionNamingConventions
    % FluorescentSubsectionSelectionNamingConventions
    % naming constants for fluorescent subsection selection
    
    properties (Constant)       
        % directories
        SESSION_DIR_SUBTITLE = 'Fluorescent Subsection';
        
        FLUORO_DIR = NamingConvention({''}, {'FL'});
        MM_DIR = NamingConvention({''}, {'MM'}); % the import directory is not divided into subdirectory, but in the project database, let's subdivide it
        
        % image series
        MM_IMAGES_PSA = {NamingConvention({'45'}, {'45'}), NamingConvention({'00'}, {'00'}), NamingConvention({'30'}, {'30'}), NamingConvention({'60'}, {'60'})};
        MM_IMAGES_PSG = {NamingConvention({'45'}, {'45'}), NamingConvention({'00'}, {'00'}), NamingConvention({'30'}, {'30'}), NamingConvention({'60'}, {'60'})};        
        
        % image filename suffixes        
        FLUORO_FILENAME_LABEL = 'FL';
        FLUORO_GREYSCALE = NamingConvention({''}, {'BW'});
        FLUORO_MASK = NamingConvention({''}, {'Mask'});
        
        MM_FILENAME_LABEL = 'MM';
        
                
    end
    
    methods (Static)
        
        function namingConventions = getMMNamingConventions()
            namingConventions = {};
            counter = 1;
            
            for i=1:length(FluorescentSubsectionSelectionNamingConventions.MM_IMAGES_PSG)
                for j=1:length(FluorescentSubsectionSelectionNamingConventions.MM_IMAGES_PSA)
                    import = strcat(FluorescentSubsectionSelectionNamingConventions.MM_IMAGES_PSG{i}.import{1}, FluorescentSubsectionSelectionNamingConventions.MM_IMAGES_PSA{j}.import{1});
                    project = {FluorescentSubsectionSelectionNamingConventions.MM_IMAGES_PSG{i}.getSingularProjectTag(), FluorescentSubsectionSelectionNamingConventions.MM_IMAGES_PSA{j}.getSingularProjectTag()};
                    
                    namingConventions{counter} = NamingConvention({import}, project);
                    counter = counter + 1;
                end
            end
        end
        
        
    end
    
end

