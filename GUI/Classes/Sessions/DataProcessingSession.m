classdef DataProcessingSession < Session
    % DataProcessingSession
    % emcompasses all location sessions that involved processing data
    % (registration, subsection selection, polarization analysis)
    
    properties
        % set by metadata entry
        dataProcessingSessionNumber
        
    end
    
    methods
        function session = DataProcessingSession()
            session.isDataCollectionSession = false;
        end
        
    end
           
    methods
        function session = createDirectories(session, toLocationPath, projectPath)
            dirSubtitle = session.getDirSubtitle(); % defined in each specific sessionsclass
            
            sessionDirectory = createDirName(SessionNamingConventions.DATA_PROCESSING_DIR_PREFIX, num2str(session.dataProcessingSessionNumber), dirSubtitle);
            
            createObjectDirectories(projectPath, toLocationPath, sessionDirectory);
                        
            session.dirName = sessionDirectory;
        end
        
        function [] = saveMetadata(session, toSessionPath, projectPath, saveToBackup)
            saveObjectMetadata(session, projectPath, toSessionPath, SessionNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
    end
    
end

