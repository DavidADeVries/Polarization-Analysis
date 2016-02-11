function displayString = displayDate(serialDate)
% displayDate
% takes MATLAB serial date and outputs it as a string

dateString = datestr(serialDate);

displayString = dateString(1:11);

end

