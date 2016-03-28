function choice = getChoiceFromSelectValue(selectValue, enumString)

[choices, ~] = choicesFromEnum(enumString);

if selectValue > 1
    choice = choices(selectValue-1);
else
    choice = [];
end


end

