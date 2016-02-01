classdef NamingConvention
    %NamingConvention
    
    properties
        import
        project
    end
    
    methods
        function namingConvention = NamingConvention(importConvention, projectConvention)
            namingConvention.import = importConvention;
            namingConvention.project = projectConvention;
        end
    end
    
end

