classdef DataCollectionSession < Session
    % DataCollectionSession
    % emcompasses all location sessions that involved collecting data
    % (microscope, cslo, afm)
    
    properties
        % set by metadata entry
        dataCollectionSessionNumber
        
    end
    
    methods
        function session = DataCollectionSession()
            session.isDataCollectionSession = true;
        end
        
    end
           
    methods
        function session = createDirectories(session, toLocationPath, projectPath)
            dirSubtitle = session.getDirSubtitle(); % defined in each specific sessionsclass
            
            sessionDirectory = createDirName(SessionNamingConventions.DATA_COLLECTION_DIR_PREFIX, session.dataCollectionSessionNumber, dirSubtitle, SessionNamingConventions.DIR_NUM_DIGITS);
            
            createObjectDirectories(projectPath, toLocationPath, sessionDirectory);
                        
            session.dirName = sessionDirectory;
        end
        
        function [] = saveMetadata(session, toSessionPath, projectPath, saveToBackup)
            saveObjectMetadata(session, projectPath, toSessionPath, SessionNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function filenameSection = getFilenameSection(session)
            filenameSection = createFilenameSection(SessionNamingConventions.DATA_COLLECTION_DATA_FILENAME_LABEL, num2str(session.dataCollectionSessionNumber));
        end
        
        function [dataCollectionSessionNumberString] = getCollectionSessionMetadataString(session)
            dataCollectionSessionNumberString = ['Data Collection Session Number: ', num2str(session.dataCollectionSessionNumber)];
        end
    end
    
end

