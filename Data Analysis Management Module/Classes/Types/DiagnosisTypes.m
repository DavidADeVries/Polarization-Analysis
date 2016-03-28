classdef DiagnosisTypes
    %DiagnosisTypes
    
    properties
        displayString
    end
    
    enumeration
        ADPositive  ('AD Positive')
        ADNegative  ('AD Negative')
        Unknown     ('Unknown')
    end
    
    methods
        function enum = DiagnosisTypes(string)
            enum.displayString = string;
        end
    end
    
end

