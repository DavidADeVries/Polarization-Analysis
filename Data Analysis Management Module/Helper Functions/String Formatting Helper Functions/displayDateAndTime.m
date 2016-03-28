function displayString = displayDateAndTime(serialDate)
% displayDateAndTime
% takes MATLAB serial date and outputs it as a string

if isempty(serialDate) || serialDate == 0
    displayString = '';
else
    format = 'mmm dd, yyyy - HH:MM';
    displayString = datestr(serialDate, format);
end

end

