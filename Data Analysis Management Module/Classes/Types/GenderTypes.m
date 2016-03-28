classdef GenderTypes
    %GenderTypes
    
    properties
        displayString
    end
    
    enumeration
        Male    ('Male')
        Female  ('Female')
        Unknown ('Unknown')
    end
    
    methods
        function enum = GenderTypes(string)
            enum.displayString = string;
        end
    end
    
end

