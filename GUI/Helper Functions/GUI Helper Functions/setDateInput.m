function [] = setDateInput(textFieldHandle, serialDate, justDate)
%setDateInput

if isempty(serialDate) || serialDate == 0
    set(textFieldHandle, 'String', '');
else
    if justDate
        dateString = displayDate(serialDate);
    else
        dateString = displayDateAndTime(serialDate);
    end
    
    set(textFieldHandle, 'String', dateString);
end


end

