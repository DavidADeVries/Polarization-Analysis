function selectedChoices = getChoicesFromListbox(listboxHandle, choices)
% getChoicesFromListbox

selections = get(listboxHandle, 'Value');

numSelections = length(selections);

selectedChoices = cell(numSelections, 1);

for i=1:numSelections
    selectedChoices{i} = choices(selections(i));
end




end

