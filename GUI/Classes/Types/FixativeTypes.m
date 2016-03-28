classdef FixativeTypes
    %FixativeTypes
    
    properties
        displayString
    end
    
    enumeration
        formaldehyde    ('Formaldehyde')
        formalin        ('Formalin')
        glycerol        ('Glycerol')
    end
    
    methods
        function enum = FixativeTypes(string)
            enum.displayString = string;
        end
    end
    
end

