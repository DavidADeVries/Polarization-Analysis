classdef SubjectClassTypes
    %SubjectClassTypes
    
    properties
        displayString
    end
    
    enumeration
        Natural     ('Natural')
        Artifical   ('Artifical')
    end
    
    methods
        function enum = SubjectClassTypes(string)
            enum.displayString = string;
        end
    end
    
end

