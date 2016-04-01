function linkedSessionNumbers = getSessionNumbersFromListBox(sessionListboxHandle, sessionChoices)
% getSessionNumbersFromListBox

choices = get(sessionListboxHandle, 'Value');

numChoices = length(choices);

linkedSessionNumbers = zeros(numChoices, 1);

for i=1:numChoices
    session = sessionChoices{choices(i)};
    
    linkedSessionNumbers(i) = session.sessionNumber;
end


end

