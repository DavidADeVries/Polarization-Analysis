function namingConvention = findMatchingNamingConvention(filenameSections, namingConventions)
% findMatchingNamingConvention

numNamingConventions = length(namingConventions);

numberOfMatches = zeros(numNamingConventions,1);

for i=1:numNamingConventions
    matchStrings = filenameSections;
    
    projectNamingConventions = namingConventions{i}.project;
    
    for j=1:length(projectNamingConventions)
        indices = findInCellArray(projectNamingConventions, matchStrings);
        
        if ~isempty(indices)
            index = indices(1);
            
            numberOfMatches(i) = numberOfMatches(i) + 1;
            matchStrings(index) = []; %remove from match strings
        end
    end   
end

% find naming convention with most matches





end

