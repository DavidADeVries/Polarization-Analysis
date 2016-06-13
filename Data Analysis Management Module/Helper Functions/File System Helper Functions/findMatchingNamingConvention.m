function namingConvention = findMatchingNamingConvention(filenameSections, namingConventions)
% findMatchingNamingConvention

numNamingConventions = length(namingConventions);

numberOfMatches = zeros(numNamingConventions,1);

for i=1:numNamingConventions
    matchStrings = filenameSections;
    
    projectNamingConventions = namingConventions{i}.project;
    
    for j=1:length(projectNamingConventions)
        indices = containsString(matchStrings, projectNamingConventions{j});
        
        if ~isempty(indices)
            index = indices(1);
            
            numberOfMatches(i) = numberOfMatches(i) + 1;
            matchStrings(1:index) = []; %remove match and all previous sections from match strings
        end
    end   
end

% find naming convention with most matches

[sorted, sortIndices] = sort(numberOfMatches, 'descend');

if sorted(1) == 0
    namingConvention = [];
    error('No naming convention matches found');
else
    if numNamingConventions == 1
        namingConvention = namingConventions{1};
    else
        if sorted(1) == sorted(2) 
            namingConvention = [];
            error('No unique naming convention match found')
        else
            namingConvention = namingConventions{sortIndices(1)};
        end
    end
end


end

