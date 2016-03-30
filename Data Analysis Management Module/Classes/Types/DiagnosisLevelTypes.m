classdef DiagnosisLevelTypes
    %DiagnosisLevelTypes
    
    properties
        displayString
    end
    
    enumeration
        
        mild        ('Mild')
        moderate    ('Moderate')
        severe      ('Severe')
        young       ('Young')
        markedly    ('Markedly')
        
        none        ('No Level Specified')
        
    end
    
    methods
        function enum = DiagnosisLevelTypes(displayString)
            enum.displayString = displayString;
        end
    end
    
end

