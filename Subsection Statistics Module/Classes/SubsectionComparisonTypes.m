classdef SubsectionComparisonTypes
    % SubsectionComparisonTypes
    
    properties
        displayString
    end
    
    enumeration
        subsectionComparison ('Subsection Comparison (Rectangle Select)')
        fluoroscentSubsectionComparison ('fluoroscentSubsectionComparison')
    end
    
    methods
        function enum = DiagnosisTypes(displayString)
            enum.displayString = displayString;
        end
    end
    
end

