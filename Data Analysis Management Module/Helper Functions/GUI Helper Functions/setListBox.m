function [] = setListBox(listBoxHandle, choicesFromEnum)

choiceList = {};

for i=1:length(choicesFromEnum)
    choiceList{i} = choicesFromEnum{i}.displayString;    
end

set(listBoxHandle, 'String', choiceList);

end

