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
        
        function dirName = generateDirName(session)
            dirSubtitle = session.getDirSubtitle(); % defined in each specific sessionsclass
            
            dirName = createDirName(SessionNamingConventions.DATA_COLLECTION_DIR_PREFIX, session.dataCollectionSessionNumber, dirSubtitle, SessionNamingConventions.DIR_NUM_DIGITS);
        end
           
        
        function label = generateListboxLabel(session)             
            label = createNavigationListboxLabel(SessionNamingConventions.DATA_COLLECTION_NAVI_LISTBOX_PREFIX, session.dataCollectionSessionNumber, session.getDirSubtitle());
        end
        
        
        function section = generateFilenameSection(session)
            section = createFilenameSection(SessionNamingConventions.DATA_COLLECTION_DATA_FILENAME_LABEL, num2str(session.dataCollectionSessionNumber));
        end
        
        
        function session = createDirectories(session, toLocationPath, projectPath)
            sessionDirectory = session.generateDirName();
            
            createObjectDirectories(projectPath, toLocationPath, sessionDirectory);
                        
            session.dirName = sessionDirectory;
        end
        
        function [] = saveMetadata(session, toSessionPath, projectPath, saveToBackup)
            saveObjectMetadata(session, projectPath, toSessionPath, SessionNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function [dataCollectionSessionNumberString] = getCollectionSessionMetadataString(session)
            dataCollectionSessionNumberString = ['Data Collection Session Number: ', num2str(session.dataCollectionSessionNumber)];
        end
    end
    
end

