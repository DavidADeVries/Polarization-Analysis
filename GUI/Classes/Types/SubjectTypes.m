classdef SubjectTypes
    %SubjectTypes
    
    properties
        displayString
    end
    
    enumeration
        Natural     ('Natural')
        Artifical   ('Artifical')
    end
    
    methods
        function enum = SubjectTypes(string)
            enum.displayString = string;
        end
    end
    
end

