function exclusionReasons = getExclusionReasons(selectStructure)
%getExclusionReasons

exclusionReasons = {};

for i=1:length(selectStructure)
    entry = selectStructure{i};

    if entry.isSelected
        exclusionReasons{i} = ' '; %blank
    else
        reason = entry.exclusionReason;
        
        if isempty(reason)        
            reason = ' ';
        end
        
        exclusionReasons{i} = reason;
    end
end


end

