function [ indices ] = findInCellArray(target, cellArray)
%findInCellArray
%looks for target in 1D cellArray
%returns list of indices of where target is

indices = [];
counter = 1;

for i=1:length(cellArray)
    if target == cellArray{i};
        indices(counter) = i;
        
        counter = counter + 1;
    end
end


end

