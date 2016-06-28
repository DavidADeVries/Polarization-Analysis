classdef SensitivityAndSpecificityAnalysisTypes
    % SensitivityAndSpecificityAnalysisTypes
    
    properties
        displayString
    end
    
    enumeration
        bySubject   ('By Subject')
        byLocation  ('By Location')
    end
    
    methods
        function enum = SensitivityAndSpecificityAnalysisTypes(displayString)
            enum.displayString = displayString;
        end
    end
    
end

