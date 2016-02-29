function selectedSessionNumbers = getSelectedSessionNumbers(sessionNumbers, selectedChoices)
% getSelectedSessionNumbers

numChoices = length(selectedChoices);

selectedSessionNumbers = zeros(numChoices, 1);

for i=1:numChoices
    selectedSessionNumbers(i) = sessionNumbers(selectedChoices(i));
end


end

