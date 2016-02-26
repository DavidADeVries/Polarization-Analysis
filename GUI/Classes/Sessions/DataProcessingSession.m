classdef DataProcessingSession < Session
    % DataProcessingSession
    % emcompasses all location sessions that involved processing data
    % (registration, subsection selection, polarization analysis)
    
    properties
        % set by metadata entry
        dataProcessingSessionNumber
        linkedSessionNumbers %the session numbers of sessions from which data for the processing was drawn
    end
    
    methods
        function session = DataProcessingSession()
            session.isDataCollectionSession = false;
        end
        
    end
           
    methods
        function session = createDirectories(session, toLocationPath, projectPath)
            dirSubtitle = session.getDirSubtitle(); % defined in each specific sessionsclass
            
            sessionDirectory = createDirName(SessionNamingConventions.DATA_PROCESSING_DIR_PREFIX, num2str(session.dataProcessingSessionNumber), dirSubtitle, SessionNamingConventions.DIR_NUM_DIGITS);
            
            createObjectDirectories(projectPath, toLocationPath, sessionDirectory);
                        
            session.dirName = sessionDirectory;
        end
        
        function [] = saveMetadata(session, toSessionPath, projectPath, saveToBackup)
            saveObjectMetadata(session, projectPath, toSessionPath, SessionNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function filenameSection = getFilenameSection(session)
            filenameSection = createFilenameSection(SessionNamingConventions.DATA_PROCESSING_DATA_FILENAME_LABEL, num2str(session.dataProcessingSessionNumber));
        end
        
        function [dataProcessingSessionNumberString, linkedSessionsString] = getProcessingSessionMetadataString(session)
            dataProcessingSessionNumberString = ['Data Processing Session Number: ', num2str(session.dataProcessingSessionNumber)];
            
            sessionNumbersString = '';
            
            sessionNumbers = session.linkedSessionNumbers;
            
            for i=1:length(sessionNumbers)
                if i ~= 1
                    sessionNumbersString = [sessionNumbersString, ', '];
                end
                
                sessionNumbersString = [sessionNumbersString, num2str(sessionNumbers(i))];
            end
            
            linkedSessionsString = ['Linked Session Numbers: ', sessionNumbersString];
            
        end
    end
    
end

