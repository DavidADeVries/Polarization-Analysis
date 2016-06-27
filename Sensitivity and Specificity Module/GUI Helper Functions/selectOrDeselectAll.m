function selectStructure = selectOrDeselectAll(selectStructure, selected)
% selectStructure

for i=1:length(selectStructure)
    selectStructure{i}.isSelected = selected;
end



end

