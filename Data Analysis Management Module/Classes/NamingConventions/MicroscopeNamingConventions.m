classdef MicroscopeNamingConventions
    % MicroscopeNamingConventions
    % naming constants for microscope imaging
    
    properties (Constant)
        % directories
        SESSION_DIR_SUBTITLE = 'Microscope';
        
        FLUORO_DIR = NamingConvention({'F', 'FL', 'Fluorescent', 'Fluoro', 'Fluorescents', 'Flourescence'}, {'Fluorescent'});
        MM_DIR = NamingConvention({'MM', 'M M', 'Mueller', 'Mueller Matrix'}, {'MM'});
        TR_DIR = NamingConvention({'TR', 'T R', 'Top Row'}, {'Top Row'});
        LPO_DIR = NamingConvention({'JP', 'J P', 'Polarizers', 'Just Polarizers', 'Polarizers Only', 'PO', 'P O'}, {'Polarizers Only'});
        
        
        % image series
        FLUORO_IMAGES = {NamingConvention({'colour'}, {'RGB'}), NamingConvention({'mono'}, {'BW'})};
        
        MM_IMAGES_PSA = {NamingConvention({'45'}, {'45'}), NamingConvention({'00'}, {'00'}), NamingConvention({'30'}, {'30'}), NamingConvention({'60'}, {'60'})};
        MM_IMAGES_PSG = {NamingConvention({'45'}, {'45'}), NamingConvention({'00'}, {'00'}), NamingConvention({'30'}, {'30'}), NamingConvention({'60'}, {'60'})};
        
        TR_IMAGES = {NamingConvention({'45'}, {'45'}), NamingConvention({'00'}, {'00'}), NamingConvention({'30'}, {'30'}), NamingConvention({'60'}, {'60'})};
        
        LPO_IMAGES_ANGLES = {NamingConvention({'00'}, {'00'}), NamingConvention({'45'}, {'45'}), NamingConvention({'90'}, {'90'}), NamingConvention({'135'}, {'135'}), NamingConvention({'180'}, {'180'})};
        LPO_IMAGES_CROSSED = {NamingConvention({'C'}, {'x'}), NamingConvention({'P'}, {'='})}; %crossed, uncrossed
        
        
        % image filename suffixes
        FLUORO_FILENAME_LABEL = 'FL';
        MM_FILENAME_LABEL = 'MM';
        TR_FILENAME_LABEL = 'TR';
        LPO_FILENAME_LABEL = 'PO';
        
    end
    
    methods (Static)
        function directoryConventions = getDirectoryNamingConventions()
            directoryConventions = {MicroscopeNamingConventions.FLUORO_DIR, MicroscopeNamingConventions.MM_DIR, MicroscopeNamingConventions.TR_DIR, MicroscopeNamingConventions.LPO_DIR};
        end
        
        function namingConventions = getMMNamingConventions()
            namingConventions = {};
            counter = 1;
            
            for i=1:length(MicroscopeNamingConventions.MM_IMAGES_PSG)
                for j=1:length(MicroscopeNamingConventions.MM_IMAGES_PSA)
                    import = strcat(MicroscopeNamingConventions.MM_IMAGES_PSG{i}.import{1}, MicroscopeNamingConventions.MM_IMAGES_PSA{j}.import{1});
                    project = {MicroscopeNamingConventions.MM_IMAGES_PSG{i}.getSingularProjectTag(), MicroscopeNamingConventions.MM_IMAGES_PSA{j}.getSingularProjectTag()};
                    
                    namingConventions{counter} = NamingConvention({import}, project);
                    counter = counter + 1;
                end
            end
        end
        
        function namingConventions = getLPONamingConventions()
            namingConventions = {};
            counter = 1;
            
            for i=1:length(MicroscopeNamingConventions.LPO_IMAGES_ANGLES)
                for j=1:length(MicroscopeNamingConventions.LPO_IMAGES_CROSSED)
                    import = [MicroscopeNamingConventions.LPO_IMAGES_ANGLES{i}.import{1}, MicroscopeNamingConventions.LPO_IMAGES_CROSSED{j}.import{1}];
                    project = {MicroscopeNamingConventions.LPO_IMAGES_ANGLES{i}.getSingularProjectTag(), MicroscopeNamingConventions.LPO_IMAGES_CROSSED{j}.getSingularProjectTag()};
                    
                    namingConventions{counter} = NamingConvention({import}, project);
                    counter = counter + 1;
                end
            end
        end
        
        function namingConventions = getFluoroNamingConventions()
            namingConventions = MicroscopeNamingConventions.FLUORO_IMAGES;
        end
        
        function namingConventions = getTRNamingConventions()
            namingConventions = MicroscopeNamingConventions.TR_IMAGES;
        end
        
        
    end
    
end

