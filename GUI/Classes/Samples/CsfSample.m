classdef CsfSample
    %CsfSample
    
    properties
        amountMl = 0; % numeric in millilitres
        csfSampleNumber
    end
    
    methods
                
        function sample = loadObject(sample, samplePath)
        end
                       
        function subSampleNumber = getSubSampleNumber(sample)
            subSampleNumber = sample.csfSampleNumber;
        end
        
    end
    
end

