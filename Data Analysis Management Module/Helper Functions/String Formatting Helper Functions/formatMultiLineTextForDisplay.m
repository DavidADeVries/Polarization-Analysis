function formattedText = formatMultiLineTextForDisplay(multiLineText)
% formatMultiLineTextForDisplay

if isempty(multiLineText)
    formattedText = {''};
else
    formattedText = cellstr(multiLineText);
    
    formattedText = formattedText'; %transpose into expected orientation
end

end

