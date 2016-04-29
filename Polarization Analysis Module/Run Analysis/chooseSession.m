function [selectedSession, cancel] = chooseSession(matchedSessions, croppingType)
% chooseSession

numSessions = length(matchedSessions);

if numSessions > 0
    
    listString = cell(numSessions, 1);
    
    for i=1:numSessions
        listString{i} = matchedSessions.naviListboxLabel();        
    end
    
    selectionMode = 'single';
    name = 'Select Session to Process';
    promptString = ['The following ', croppingType.displayString, ' sessions were found. Please select which one to process.'];
    
    [selection, ok] = listdlg('ListString', listString, 'SelectionMode', selectionMode, 'Name', name, 'promptString', promptString, 'Cancel', 'Select None');
    
    if ok
        selectedSession = matchedSessions{selection};
        cancel = false;
    else
        selectedSession = [];
        cancel = true;
    end
else
    selectedSession = [];
    cancel = false;
end

end

