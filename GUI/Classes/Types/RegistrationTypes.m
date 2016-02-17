classdef RegistrationTypes
    % RegistrationTypes
    
    properties
        displayString
    end
    
    enumeration
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

