classdef TissueSampleSourceTypes
    %TissueSampleSourceTypes
    
    properties
        displayString
    end
    
    enumeration
        eyeBankOfCanada  ('Eye Bank of Canada - Ontario Division')
        fergus  ('1??')
        ubc   ('2??')
    end
    
    methods
        function enum = TissueSampleSourceTypes(string)
            enum.displayString = string;
        end
    end
    
end

