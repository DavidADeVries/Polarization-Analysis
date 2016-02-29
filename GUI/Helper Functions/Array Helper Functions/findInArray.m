function [ indices ] = findInArray(target, array)
%findInArray
%looks for target in 1D Array
%returns list of indices of where target is

indices = [];
counter = 1;

for i=1:length(array)
    if target == array(i);
        indices(counter) = i;
        
        counter = counter + 1;
    end
end


end

