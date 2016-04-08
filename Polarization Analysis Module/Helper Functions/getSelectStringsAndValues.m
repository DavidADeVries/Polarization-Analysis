function [selectStrings, selectValues] = getSelectStringsAndValues(locationSelectStructure)
% getSelectStringsAndValues

numEntries = length(locationSelectStructure);

selectStrings = cell(numEntries, 1);
selectValues = [];

for i=1:numEntries
    entry = locationSelectStructure{i};
    
    numTabs = length(entry.indices) - 1;
    
    tab = genTab(numTabs);
    
    selectStrings{i} = [tab, entry.label];
    
    if entry.isSelected
        selectValues = [selectValues, i];
    end
end


end

function tab = genTab(numTabs)
    tab = '';
    
    for i=1:numTabs
        tab = [tab, PolarizationAnalysisModuleConstants.TAB];
    end
end