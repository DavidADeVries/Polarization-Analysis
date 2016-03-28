classdef TissueSampleSourceTypes
    %TissueSampleSourceTypes
    
    properties
        displayString
    end
    
    enumeration
        eyeBankOfCanada  ('Eye Bank of Canada (Ontario Division)')
        intervivo  ('Intervivo (Fergus)')
        ubcIanMackenzie   ('UBC (Ian Mackenzie)')
    end
    
    methods
        function enum = TissueSampleSourceTypes(string)
            enum.displayString = string;
        end
    end
    
end

