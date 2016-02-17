classdef ProcessingSession < Session
    %ProcessingSession
    %holds metadata for an image/data processing sessions
    
    properties
        relatedSessionIds %ids of the data collection sessions from which data is being processed (can be a combination of data collection and/or processing sessions)
    end
    
    methods
        function session = ProcessingSession()
            session.isDataCollectionSession = false;
        end
    end
    
end

