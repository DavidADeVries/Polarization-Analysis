classdef FileSelectionEntry
    % FileSelectionEntry
    
    properties
        toPath
        selectionLabel
        
        filesInDir % cell array of FileSelectionEntry
    end
    
    methods
        function selectionEntry = FileSelectionEntry(toPath, selectionLabel, filesInDir)
            selectionEntry.toPath = toPath;
            selectionEntry.selectionLabel = selectionLabel;
            selectionEntry.filesInDir = filesInDir;
        end
    end
    
end

