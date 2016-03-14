function displayString = displayDateAndTime(serialDate)
% displayDateAndTime
% takes MATLAB serial date and outputs it as a string

format = 'mmm dd, yyyy - HH:MM';
displayString = datestr(serialDate, format);

end

