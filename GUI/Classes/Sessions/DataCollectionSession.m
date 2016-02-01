classdef DataCollectionSession < Session
    % DataCollectionSession
    % emcompasses all location sessions that involved collecting data
    % (microscope, cslo, afm)
    
    properties        
        dataCollectionSessionNumber
        
        rejected % T/F, will exclude data from being included in analysis
        rejectedReason % reason that this data was rejected (suspected poor imaging, out of focus
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
        
        function session = getSelection(choice)
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
        function session = createDirectories(session, toLocationPath, projectPath, localPath)
            dirSubtitle = session.getDirSubtitle(); % defined in each specific sessionsclass
            
            sessionDirectory = createDirName(SessionNamingConventions.DATA_COLLECTION_DIR_PREFIX, num2str(session.dataCollectionSessionNumber), dirSubtitle);
            
            createObjectDirectories(projectPath, localPath, toLocationPath, sessionDirectory);
                        
            session.dirName = sessionDirectory;
        end
        
        function [] = saveMetadata(session, toSessionPath, projectPath, localPath, saveToBackup)
            saveObjectMetadata(session, projectPath, localPath, toSessionPath, SessionNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
    end
    
end

