classdef QuarterTypes
    %QuarterTypes
    
    properties
        displayString
    end
    
    enumeration
        Superior    ('Superior')
        Inferior    ('Inferior')
        Temporal    ('Temporal')
        Nasal       ('Nasal')
        Unknown     ('Unknown')
    end
    
    methods
        function enum = QuarterTypes(string)
            enum.displayString = string;
        end
    end
    
end

