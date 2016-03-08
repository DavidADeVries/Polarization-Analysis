function selectedSessionNumbers = getSelectedSessionNumbers(sessionChoices, selectedChoices)
% getSelectedSessionNumbers

numChoices = length(selectedChoices);

selectedSessionNumbers = zeros(numChoices, 1);

for i=1:numChoices
    selectedSessionNumbers(i) = sessionChoices{selectedChoices(i)}.sessionNumber;
end


end

