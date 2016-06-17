classdef SubsectionComparisonTypes
    % SubsectionComparisonTypes
    
    properties
        displayString
        columnHeaders
        numSessionsRequired
    end
    
    enumeration
        subsectionComparison ('Subsection Comparison (Rectangle Select)', {'Pos', 'Neg'}, 2)
        fluorescentSubsectionComparison ('Fluorescent Subsection Comparison', {'Pos', 'Neg'}, 1)
    end
    
    methods
        function enum = SubsectionComparisonTypes(displayString, columnHeaders, numSessionsRequired)
            enum.displayString = displayString;
            enum.columnHeaders = columnHeaders;
            enum.numSessionsRequired = numSessionsRequired;
        end
    end
    
end

