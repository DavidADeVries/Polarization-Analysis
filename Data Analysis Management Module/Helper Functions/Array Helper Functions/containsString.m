function indices = containsString(stringCellArray, string)
% containsString
% returns indicies where the stringCellArray contains the string

indices = [];

counter = 1;

for i=1:length(stringCellArray)
    if strcmp(stringCellArray{i}, string)
        indices(counter) = i;
        counter = counter + 1;
    end
end

end

