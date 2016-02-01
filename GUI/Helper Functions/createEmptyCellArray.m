function cellArray = createEmptyCellArray(class, length)
% createEmptyCellArray
% creates a length by 1 cell array for the empty class specified

cellArray = cell(length, 1);

for i=1:length
    cellArray{i} = class;
end

end

