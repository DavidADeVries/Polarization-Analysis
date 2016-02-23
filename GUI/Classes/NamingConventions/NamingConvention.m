classdef NamingConvention
    %NamingConvention
    
    properties
        import % cell array of options
        project % single string
    end
    
    methods
        
        function namingConvention = NamingConvention(importConvention, projectConvention)
            namingConvention.import = importConvention;
            namingConvention.project = projectConvention;
        end
        
        % returns true if matchString matches one of the import strings
        function matchFound = importMatches(namingConvention, matchString)
            matchFound = false;
            
            for i=1:length(namingConvention.import)                
                if strcmpi(namingConvention.import{i}, matchString) % ignore case
                    matchFound = true;
                    break;
                end
            end
        end
        
    end
    
end

