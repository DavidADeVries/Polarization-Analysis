function selectedChoices = getSelectionChoicesFromSessionNumbers(sessionNumbers, selectedSessionNumbers)
% getSelectionChoicesFromSessionNumbers

numChoices = length(selectedSessionNumbers);

selectedChoices = zeros(numChoices, 1);

numSessionNumbers = length(sessionNumbers);

for i=1:numChoices
    sessionNumber = selectedSessionNumbers(i);
    
    for j=1:numSessionNumbers
        if sessionNumber  == sessionNumbers(j);
            selectedChoices(i) = j;
            break;
        end
    end
end


end

