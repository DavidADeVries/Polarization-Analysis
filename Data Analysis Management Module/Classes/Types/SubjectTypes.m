classdef SubjectTypes
    %SubjectTypes
    
    properties
        displayString
        subjectClass
        subjectClassType
    end
    
    enumeration
        Dog         ('Dog',             NaturalSubject.empty,     SubjectClassTypes.Natural)
        Human       ('Human',           NaturalSubject.empty,     SubjectClassTypes.Natural)
        PureAmyloid ('Pure Amyloid',    ArtificalSubject.empty,   SubjectClassTypes.Artifical)
    end
    
    methods
        function enum = SubjectTypes(string, class, subjectClassType)
            enum.displayString = string;
            enum.subjectClass = class;
            enum.subjectClassType = subjectClassType;
        end
    end
    
end

