classdef EyeTypes
    % EyeTypes
    
    properties
        displayString
    end
    
    enumeration
        Left    ('Left')
        Right   ('Right')
        Unknown ('Unknown')
    end
    
    methods
        function enum = EyeTypes(string)
            enum.displayString = string;
        end
    end
    
end

