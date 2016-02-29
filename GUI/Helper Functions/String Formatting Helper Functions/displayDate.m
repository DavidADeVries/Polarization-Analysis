function displayString = displayDate(serialDate)
% displayDate
% takes MATLAB serial date and outputs it as a string

format = 'mmm dd, yyyy';
displayString = datestr(serialDate, format);

end

