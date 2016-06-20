classdef DataProcessingSession < Session
    % DataProcessingSession
    % emcompasses all location sessions that involved processing data
    % (registration, subsection selection, polarization analysis)
    
    properties
        % set by metadata entry
        dataProcessingSessionNumber
        linkedSessionNumbers = []; %the session numbers of sessions from which data for the processing was drawn
    end
           
    methods
        
        function dirName = generateDirName(session)
            dirSubtitle = session.getDirSubtitle(); % defined in each specific sessionsclass
            
            dirName = createDirName(SessionNamingConventions.DATA_PROCESSING_DIR_PREFIX, num2str(session.dataProcessingSessionNumber), dirSubtitle, SessionNamingConventions.DIR_NUM_DIGITS);
        end
        
                
        function label = generateListboxLabel(session)             
            label = createNavigationListboxLabel(SessionNamingConventions.DATA_PROCESSING_NAVI_LISTBOX_PREFIX, session.dataProcessingSessionNumber, session.getDirSubtitle());
        end
        
        
        function section = generateFilenameSection(session)
            section = createFilenameSection(SessionNamingConventions.DATA_PROCESSING_DATA_FILENAME_LABEL, num2str(session.dataProcessingSessionNumber));
        end
        
        
        function session = createDirectories(session, toLocationPath, projectPath)            
            sessionDirectory = session.generateDirName();
            
            createBackup = false;
            
            createObjectDirectories(projectPath, toLocationPath, sessionDirectory, createBackup);
                        
            session.dirName = sessionDirectory;
        end
        
        function [] = saveMetadata(session, toSessionPath, projectPath, saveToBackup)
            saveObjectMetadata(session, projectPath, toSessionPath, SessionNamingConventions.METADATA_FILENAME, saveToBackup);            
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
        
        function isLinked = isLinkedToSession(session, checkSession)
            isLinked = ~isempty(findInArray(checkSession.sessionNumber, session.linkedSessionNumbers));
        end
        
    end
    
end

