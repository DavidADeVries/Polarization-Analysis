function [] = setPopUpMenu(popUpMenuHandle, defaultChoiceString, choiceStrings, selectedString)
% setPopUpMenu


%Setting the list values for the Registration Type pop up menu
choiceList = {defaultChoiceString};

defaultValue = 1;

for i = 1:size(choiceStrings)
    choiceList{i+1} = choiceStrings{i};
    
    if strcmp(choiceStrings{i}, selectedString)
        defaultValue = i+1;
    end
end

set(popUpMenuHandle, 'String', choiceList, 'Value', defaultValue);


end

