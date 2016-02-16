classdef Session
    %Session
    % holds metadata describing data collection or analysis for a given
    % location
    
    % a lot of classes inherit from this bad boy
    
    properties
        % set at initialization
        dirName
        metadataHistory
        
        % set by metadata entry
        sessionDate
        sessionDoneBy           
        sessionNumber        
        isDataCollectionSession
        notes
        
        rejected % T/F, will exclude data from being included in analysis
        rejectedReason % reason that this data was rejected (suspected poor imaging, out of focus
        rejectedBy
        
        % list of files for the session and the index   
        fileSelectionEntries     
        subfolderIndex = 0
    end
    
    methods
        function session = wipeoutMetadataFields(session)
            session.dirName = '';
            session.fileSelectionEntries = [];
        end
        
        function handles = updateNavigationListboxes(session, handles)
            subfolderSelections = session.getSubfolderSelections();
            
            if isempty(subfolderSelections)
                disableNavigationListboxes(handles, handles.subfolderSelect);
            else
                set(handles.subfolderSelect, 'String', subfolderSelections, 'Value', session.subfolderIndex, 'Enable', 'on');
                
                handles = session.getSubfolderSelection().updateNavigationListboxes(handles);
            end            
        end
        
        function session = createFileSelectionEntries(session, toSessionPath)
            session.fileSelectionEntries = generateFileSelectionEntries({}, toSessionPath, session.dirName, 0);
        end
        
        function subfolderSelections = getSubfolderSelections(session)
            numEntries = length(session.fileSelectionEntries);
            
            subfolderSelections = cell(numEntries, 1);
            
            for i=1:numEntries
                subfolderSelections{i} = session.fileSelectionEntries{i}.selectionLabel;
            end
        end              
        
        function subfolderSelection = getSubfolderSelection(session)
            
            if session.subfolderIndex ~= 0
                subfolderSelection = session.fileSelectionEntries{session.subfolderIndex};
            else
                subfolderSelection = [];
            end
        end
        
        function session = updateCurrentSubfolderSelection(session, subfolderSelection)
            session.fileSelectionEntries{session.subfolderIndex} = subfolderSelection;
        end
                
        function session = updateSubfolderIndex(session, index)
            session.subfolderIndex = index;
        end
        
        function session = updateFileIndex(session, index)
            subfolderSelection = session.getSubfolderSelection();
            
            subfolderSelection = subfolderSelection.updateFileIndex(index);  
            
            session.fileSelectionEntries{session.subfolderIndex} = subfolderSelection;
        end
        
        function fileSelection = getSelectedFile(session)
            subfolderSelection = session.getSubfolderSelection();
            
            if ~isempty(subfolderSelection)
                fileSelection = subfolderSelection.getFileSelection();
            else
                fileSelection = [];
            end
        end
        
        function session = incrementFileIndex(session, increment)            
            subfolderSelection = session.getSubfolderSelection();
            
            subfolderSelection = subfolderSelection.incrementFileIndex(increment);            
            
            session = session.updateCurrentSubfolderSelection(subfolderSelection);
        end
        
        function [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString] = getSessionMetadataString(session)
            
            sessionDateString = ['Date: ', displayDate(session.sessionDate)];
            sessionDoneByString = ['Done By: ', session.sessionDoneBy];
            sessionNumberString = ['Session Number: ', num2str(session.sessionNumber)];
            rejectedString = ['Rejected: ' , booleanToString(session.rejected)];
            rejectedReasonString = ['Rejected Reason: ', session.rejectedReason];
            rejectedByString = ['Rejected By: ', session.rejectedBy];
            sessionNotesString = ['Notes: ', session.notes];
        end
    end
    
end

