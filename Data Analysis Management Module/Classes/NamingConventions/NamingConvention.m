classdef NamingConvention
    %NamingConvention
    
    properties
        import % cell array of options
        project % cell array of tags that converted as {'AA', 'BB'} -> [AA][BB]
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
        
        
        function tagString = generateProjectTagString(namingConvention)
            projectTags = namingConvention.project;
            
            tagString = '';
            
            numTags = length(projectTags);
            
            for i=1:numTags
                if i ~= 1
                    tagString = [tagString, ', '];
                end
                
                tagString = [tagString, projectTags{i}];
            end
        end
        
        function projectTag = getSingularProjectTag(namingConvention)
            
            if length(namingConvention.project) ~= 1
                error('NamingConvention does not have a singular project tag');
            else
                projectTag = namingConvention.project{1};
            end
        end
        
        function filenameSection = generateProjectFilenameSection(namingConvention)
            namingConventions = namingConvention.project;
            
            filenameSection = [];
            
            for i=1:length(namingConventions)
                nextSection = createFilenameSection(namingConventions{i}, []);
                
                filenameSection = [filenameSection, nextSection];
            end
        end
        
    end
    
end

