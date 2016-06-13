classdef RegistrationSession < DataProcessingSession
    % RegisrationSession
    % stores metadata for a registration procedure
    
    properties
        registeredImages
        movementParameters % [vertical shift, horizontal shift, rotation]
        method
    end
    
    methods
        function [images, filenames] = getMMImages(session, toSessionPath)
            mmPath = makePath(toSessionPath, LegacyRegistrationNamingConventions.MM_DIR);
            
            filenames = getFilesByExtension(mmPath, Constants.BMP_EXT);
                        
            for i=1:length(filenames)
                images{i} = openImage(makePath(mmPath, filenames{i}));
            end
        end
    end
    
end

