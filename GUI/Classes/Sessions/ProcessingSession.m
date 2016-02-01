classdef ProcessingSession < Session
    %ProcessingSession
    %holds metadata for an image/data processing sessions
    
    properties
        dataCollectionSessionIds %ids of the data collection sessions which data is being processed
    end
    
    methods
        function session = ProcessingSession()
            session.isDataCollectionSession = false;
        end
    end
    
end

