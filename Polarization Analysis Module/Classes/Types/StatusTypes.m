classdef StatusTypes
    % StatusTypes
    
    properties
        displayString
    end
    
    enumeration
        ComputeMM ('Computing Mueller Matrix')
        WritingMM ('Writing Mueller Matrix Files')
        ValidatingMM ('Validating Mueller Matrices for Analysis')
        ComputingMetrics ('Conducting Polarization Analysis')
        WritingMetrics ('Writing Polarization Analysis Files')
        Complete ('Complete')
    end
    
    methods
        function enum = StatusTypes(displayString)
            enum.displayString = displayString;
        end
        
        function displayString = getDisplayString(enum)
            displayString = [enum.displayString, ' [', displayDateAndTime, ']'];
        end
    end
    
end

