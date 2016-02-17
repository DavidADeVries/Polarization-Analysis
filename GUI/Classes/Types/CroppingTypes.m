classdef CroppingTypes
    %CroppingTypes
    
    properties
        displayString
    end
    
    enumeration
        positiveArea  ('Positive Area')
        negativeArea  ('Negative Area')
        controlArea   ('Control Area')
        otherArea     ('Other Area')
        Unknown       ('Unknown')
    end
    
    methods
        function enum = DiagnosisTypes(string)
            enum.displayString = string;
        end
    end
    
end

