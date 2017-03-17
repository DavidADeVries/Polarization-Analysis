classdef RegistrationTypes
    % RegistrationTypes
    
    properties
        displayString
    end
    
    enumeration
        erikProgram     ('Erik''s Program')
        harryProgram    ('Harry''s Program')
        chrisProgram    ('Chris''s Program')
        ianProgram      ('Ian''s Program')
        manual          ('Manual Registration')
        Unknown         ('Unknown')
    end
    
    methods
        function enum = RegistrationTypes(string)
            enum.displayString = string;
        end
    end
    
end

