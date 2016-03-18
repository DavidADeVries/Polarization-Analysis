classdef CsfSample < FrozenSample
    %CsfSample
    
    properties
        amountMl = []; % numeric in millilitres
        csfSampleNumber
    end
    
    methods
                
        function sample = loadObject(sample, samplePath)
        end
                       
        function subSampleNumber = getSubSampleNumber(sample)
            subSampleNumber = sample.csfSampleNumber;
        end
                
        function sample = createNewQuarter(sample, projectPath, toPath, userName)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function sample = editSelectedQuarterMetadata(sample, projectPath, toEyePath, userName, dataFilename)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function sample = createNewLocation(sample, projectPath, toPath, userName, subjectType)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function sample = editSelectedLocationMetadata(sample, projectPath, toSamplePath, userName, dataFilename, subjectType)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function sample = editSelectedSessionMetadata(sample, projectPath, toSamplePath, userName, dataFilename)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end 
        
        function sample = createNewSession(sample, projectPath, toPath, userName, sessionType)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
    end
    
end

