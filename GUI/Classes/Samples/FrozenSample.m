classdef FrozenSample < TissueSample
    %FrozenSample
    
    properties
        storageTemp = []; %in degrees Celsius
    end
    
    methods
        
        function [storageTempString] = getFrozenSampleMetadataString(sample)
            
            storageTempString = ['Storage Temperature (°C): ', num2str(sample.storageTemp)];  
            
        end
        
    end
    
end

