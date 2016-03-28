function displayString = displayDate(serialDate)
% displayDate
% takes MATLAB serial date and outputs it as a string

if isempty(serialDate) || serialDate == 0
    displayString = '';
else
    format = 'mmm dd, yyyy';
    displayString = datestr(serialDate, format);
end

end

