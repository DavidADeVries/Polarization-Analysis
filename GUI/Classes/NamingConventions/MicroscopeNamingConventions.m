classdef MicroscopeNamingConventions
    % MicroscopeNamingConventions
    % naming constants for microscope imaging
    
    properties (Constant)
        % directories
        FLUORO_DIR = NamingConvention('F', 'Fluoroscent');
        MM_DIR = NamingConvention('MM', 'MM');
        TR_DIR = NamingConvention('TR', 'Top Row');
        LPO_DIR = NamingConvention('JP', 'Linear Polarizers Only');
        
        
        % image series
        FLUORO_IMAGES = {NamingConvention('colour', 'RGB'), NamingConvention('mono', 'BW')};
        
        MM_IMAGES_PSA = {NamingConvention('45', '45'), NamingConvention('00', '00'), NamingConvention('30', '30'), NamingConvention('60', '60')};
        MM_IMAGES_PSG = {NamingConvention('45', '45'), NamingConvention('00', '00'), NamingConvention('30', '30'), NamingConvention('60', '60')};
        
        TR_IMAGES = {NamingConvention('45', '45'), NamingConvention('00', '00'), NamingConvention('30', '30'), NamingConvention('60', '60')};
        
        LPO_IMAGES_ANGLES = {NamingConvention('00', '00'), NamingConvention('45', '45'), NamingConvention('90', '90'), NamingConvention('135', '135'), NamingConvention('180', '180')};
        LPO_IMAGES_CROSSED = {NamingConvention('C', 'Crossed'), NamingConvention('P', 'Uncrossed')}; %crossed, uncrossed
        
        
        % image filename suffixes
        FLUORO_FILENAME_LABEL = 'FL';
        MM_FILENAME_LABEL = 'MM';
        TR_FILENAME_LABEL = 'TR';
        LPO_FILENAME_LABEL = 'LPO';
        
        %MetdataGUI default input values
        DEFAULT_METADATA_GUI_MAGNIFICATION = 40;
        DEFAULT_METADATA_GUI_PIXEL_SIZE_MICRONS = 1.13;
        DEFAULT_METADATA_GUI_INSTRUMENT = 'Nikon Eclipse Ti-U';
        
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
                    import = strcat(MicroscopeNamingConventions.MM_IMAGES_PSG{i}.import, MicroscopeNamingConventions.MM_IMAGES_PSA{j}.import);
                    project = strcat(MicroscopeNamingConventions.MM_IMAGES_PSG{i}.project, MicroscopeNamingConventions.MM_IMAGES_PSA{j}.project);
                    
                    namingConventions{counter} = NamingConvention(import, project);
                    counter = counter + 1;
                end
            end
        end
        
        function namingConventions = getLPONamingConventions()
            namingConventions = {};
            counter = 1;
            
            for i=1:length(MicroscopeNamingConventions.LPO_IMAGES_ANGLES)
                for j=1:length(MicroscopeNamingConventions.LPO_IMAGES_CROSSED)
                    import = [MicroscopeNamingConventions.LPO_IMAGES_ANGLES{i}.import, MicroscopeNamingConventions.LPO_IMAGES_CROSSED{j}.import];
                    project = [MicroscopeNamingConventions.LPO_IMAGES_ANGLES{i}.project, ' ', MicroscopeNamingConventions.LPO_IMAGES_CROSSED{j}.project];
                    
                    namingConventions{counter} = NamingConvention(import, project);
                    counter = counter + 1;
                end
            end
        end
    end
    
end

