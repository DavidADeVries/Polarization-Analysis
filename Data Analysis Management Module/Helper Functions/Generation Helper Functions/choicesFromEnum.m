function [choices, choiceStrings] = choicesFromEnum(enumString)
% choicesFromEnum
% gives a cell array of strings of the members of the enumeration and the
% members of the enumberation

choices = enumeration(enumString);

numMembers = length(choices);

choiceStrings = cell(numMembers, 1);

for i=1:numMembers
    choiceStrings{i} = choices(i).displayString;
end


end

