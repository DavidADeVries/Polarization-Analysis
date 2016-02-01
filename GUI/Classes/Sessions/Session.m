classdef Session
    %Session
    % holds metadata describing data collection or analysis for a given
    % location
    
    % a lot of classes inherit from this bad boy
    
    properties
        dirName
        
        sessionDate
        sessionDoneBy
           
        sessionNumber
        
        isDataCollectionSession
        
        notes
    end
    
    methods
        function session = wipeoutMetadataFields(session)
            session.dirName = '';
        end
    end
    
end

