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
        
        function testColHeaders = getTestColumnHeaders(comparisonType)
            vs = ' vs. ';
            
            colHeaders = comparisonType.columnHeaders;
            
            numHeaders = length(colHeaders);
            
            testColHeaders = {};
            counter = 1;
            
            for i=1:numHeaders
                for j=i+1:numHeaders
                    testColHeaders{counter} = [colHeaders{i}, vs, colHeaders{j}];
                    
                    counter = counter + 1;                    
                end
            end
            
        end
    end
    
end

