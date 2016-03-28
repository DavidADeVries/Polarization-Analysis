classdef FileSelectionEntry
    % FileSelectionEntry
    
    properties
        toPath
        selectionLabel
        
        fileIndex = 0 %index of the file selected
        filesInDir % cell array of FileSelectionEntry
    end
    
    methods
        function selectionEntry = FileSelectionEntry(toPath, selectionLabel, filesInDir)
            selectionEntry.toPath = toPath;
            selectionEntry.selectionLabel = selectionLabel;
            selectionEntry.filesInDir = filesInDir;
        end
        
        function entry = updateFileIndex(entry, index)
            entry.fileIndex = index;
        end
        
        function fileSelection = getFileSelection(entry)
            files = entry.filesInDir;
            
            if isempty(files)
                fileSelection = [];
            else
                fileSelection = files{entry.fileIndex};
            end
        end
        
        function fileSelections = getFileSelections(entry)
            files = entry.filesInDir;
            
            numFiles = length(files);
            
            fileSelections = cell(numFiles, 1);
            
            for i=1:numFiles
                fileSelections{i} = files{i}.selectionLabel;
            end
        end
        
        function handles = updateNavigationListboxes(entry, handles)
            fileSelections = entry.getFileSelections();
            
            if isempty(fileSelections)
                disableNavigationListboxes(handles, handles.fileSelect);
            else
                set(handles.fileSelect, 'String', fileSelections, 'Value', entry.fileIndex, 'Enable', 'on');
                
                handles = updateImageAxes(handles, entry.getFileSelection());
            end
        end
        
        function fileSelection = incrementFileIndex(fileSelection, increment)
            index = fileSelection.fileIndex;
            
            files = fileSelection.filesInDir;
            numFiles = length(files);
            
            newIndex = index + increment;            
            newIndex = (mod(newIndex-1, numFiles)) + 1; % loop around appropriately
            
            nudge = increment/abs(increment);
            
            counter = 0;
            
            while ~isOpenableFile(files{newIndex}) && counter < numFiles
                newIndex = newIndex + nudge;            
                newIndex = (mod(newIndex-1, numFiles)) + 1; % loop around appropriately
                
                counter = counter + 1;
            end
            
            if counter ~= numFiles %suitable file found, update index
                fileSelection.fileIndex = newIndex;
            end
        end
    end
    
end

