classdef ImagingTypes
    %ImagingTypes
    
    properties
        displayString
    end
    
    enumeration
        Microscope  ('Microscope')
        CSLO        ('CSLO')
        OCT         ('OCT')
        AFM         ('AFM')
        Unknown     ('Unknown')
    end
    
    methods
        function enum = ImagingTypes(string)
            enum.displayString = string;
        end         
    end
    
end

