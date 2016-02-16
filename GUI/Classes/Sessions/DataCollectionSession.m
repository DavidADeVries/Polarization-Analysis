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
    
    methods(Static)
        function choices = getDataCollectionSessionChoices()
            choices = {'Microscope', 'CSLO', 'Unknown'};
        end
        
        
        function session = createSession(choice, suggestedSessionNumber, existingSessionNumbers, locationProjectPath, projectPath, locationImportPath, userName)
            if choice == 1
                session = MicroscopeSession;
            elseif choice == 2
                session = CLSOSession;
            elseif choice == 3
                session = DataCollectionSession;
            else
                error('Invalid Data Collection Session type!');
            end                
        end
    end
       
    methods
        function session = createDirectories(session, toLocationPath, projectPath)
            dirSubtitle = session.getDirSubtitle(); % defined in each specific sessionsclass
            
            sessionDirectory = createDirName(SessionNamingConventions.DATA_COLLECTION_DIR_PREFIX, num2str(session.dataCollectionSessionNumber), dirSubtitle);
            
            createObjectDirectories(projectPath, toLocationPath, sessionDirectory);
                        
            session.dirName = sessionDirectory;
        end
        
        function [] = saveMetadata(session, toSessionPath, projectPath, saveToBackup)
            saveObjectMetadata(session, projectPath, toSessionPath, SessionNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
    end
    
end

