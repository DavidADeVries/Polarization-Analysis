classdef SampleTypes
    %SampleTypes
    
    properties
        displayString
        sessionClass
    end
    
    enumeration
        % Tissue Sample
        Eye             ('Eye',             Eye.empty)
        CsfSample       ('CSF Sample',      CsfSample.empty)
        BrainSection    ('Brain Section',   BrainSection.empty)
        
    end
    
    methods
        function enum = SampleTypes(string, class)
            enum.displayString = string;
            enum.sessionClass = class;
        end
    end
    
end

