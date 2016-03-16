function [] = setPopUpMenu(popUpMenuHandle, defaultChoiceString, choicesFromEnum, selectedChoice)
% setPopUpMenu


%Setting the list values for the Registration Type pop up menu
choiceList = {defaultChoiceString};

defaultValue = 1;


for i = 1:size(choicesFromEnum)
    choiceList{i+1} = choicesFromEnum(i).displayString;
    
    if choicesFromEnum(i) == selectedChoice
        defaultValue = i+1;
    end
end

set(popUpMenuHandle, 'String', choiceList, 'Value', defaultValue);


end

