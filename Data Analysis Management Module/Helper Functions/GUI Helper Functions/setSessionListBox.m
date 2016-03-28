function [] = setSessionListBox(listBoxHandle, sessionChoices, selectedSessionNumbers)

choiceStrings = {};
values = [];

valCounter = 1;

for i=1:length(sessionChoices)
    session = sessionChoices{i};
    
    choiceStrings{i} = session.naviListboxLabel;
    
    if ismember(session.sessionNumber, selectedSessionNumbers)
        values(valCounter) = i;
        valCounter = valCounter + 1;
    end
end

set(listBoxHandle, 'String', choiceStrings, 'Value', values);

end

