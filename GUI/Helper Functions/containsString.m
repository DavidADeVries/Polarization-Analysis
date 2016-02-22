function doesContain = containsString(stringCellArray, string)
% containsString
% returns true if the stringCellArray contains the string

doesContain = false;

for i=1:length(stringCellArray)
    if strcmp(stringCellArray{i}, string)
        doesContain = true;
        break;
    end
end

end

