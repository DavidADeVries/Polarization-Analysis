function [] = setPopUpMenu(popUpMenuHandle, defaultChoiceString, choices, selectedChoice)
% setPopUpMenu


%Setting the list values for the Registration Type pop up menu
choiceList = {defaultChoiceString};

defaultValue = 1;

for i = 1:size(choices)
    choiceList{i+1} = choices(i).displayString;
    
    if choices(i) == selectedChoice
        defaultValue = i+1;
    end
end

set(popUpMenuHandle, 'String', choiceList, 'Value', defaultValue);


end

