function indices = containsSubstring(stringCellArray, string)
% containsSubstring
% returns indicies where the stringCellArray contains the substring

indices = [];

counter = 1;

for i=1:length(stringCellArray)
    if ~isempty(strfind(stringCellArray{i}, string)) || ~isempty(strfind(string, stringCellArray{i}))
        indices(counter) = i;
        counter = counter + 1;
    end
end

end

