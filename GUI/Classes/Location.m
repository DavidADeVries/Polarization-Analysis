classdef Location
    % Location
    % This is a location where imaging was done
    
    properties
        dirName
        
        locationNumber %usually a number
         
        deposit %T/F tells whether a deposit was present, or if it was a control field
        
        locationCoords %[x,y] for unit circle of radius 1 representing the retina, origin at centre
          
        sessions
        
        notes
    end
    
    methods
        function location = loadLocation(location, toLocationPath, locationDir)
            locationPath = makePath(toLocationPath, locationDir);
            
            % load metadata
            vars = load(makePath(locationPath, LocationNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR); 
            location = vars.metadata;
            
            %load dir name
            location.dirName = locationDir;
            
            % load sessions
            
            sessionDirs = getMetadataFolders(locationPath, SessionNamingConventions.METADATA_FILENAME);
            
            numSessions = length(sessionDirs);
            
            sessions = cell(numSessions, 1);
            
            for i=1:numSessions %load sessions
                vars = load(makePath(locationPath, sessionDirs{i}, SessionNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
                session = vars.metadata;
                
                session.dirName = sessionDirs{i};
                
                sessions{i} = session;
            end
            
            location.sessions = sessions;
        end
        
        function location = importLocation(location, locationProjectPath, locationImportPath, projectPath, localPath, dataFilename)
            filenameSection = createFilenameSection(LocationNamingConventions.DATA_FILENAME_LABEL, num2str(location.locationNumber));
            dataFilename = strcat(dataFilename, filenameSection);
            
            dataCollectionSession = importDataCollectionSession(location, locationProjectPath, locationImportPath, projectPath, localPath, dataFilename);
            
            location = location.addSession(dataCollectionSession);
        end
        
        function location = addSession(location, session)
            if ~isempty(session)
                sessions = location.sessions;
                numSessions = length(sessions);
                
                sessions{numSessions + 1} = session;
                
                location.sessions = sessions;
            end
        end        
        
        function location = enterMetadata(location, suggestedLocationNumber)
            %locationNumber
            prompt = {'Enter Location Number:'};
            title = 'Location Number';
            numLines = 1;
            defaultAns = {num2str(suggestedLocationNumber)};
            
            location.locationNumber = str2double(inputdlg(prompt, title, numLines, defaultAns));
            
            
            % deposit
            
            prompt = 'Is the location a blank, control field';
            selectionMode = 'single';
            title = 'Deposit at Location';
            choices = {'Control Field','Deposit Field'};
            
            [selection, ok] = listdlg('ListString', choices, 'SelectionMode', selectionMode, 'Name', title, 'PromptString', prompt);
            
            if selection == 1
                deposit = false;
            else
                deposit = true;
            end               
                
            location.deposit = deposit;
            
            % locationCoords 
            
            location.locationCoords = 'N/A';
            
                       
            %notes
            
            prompt = 'Enter Location notes:';
            title = 'Location Notes';
            
            response = inputdlg(prompt, title);
            location.notes = response{1}; 
        end
        
        function nextSessionNumber = getNextSessionNumber(location)
            sessions = location.sessions;
            
            numSessions = length(sessions);
            
            if numSessions == 0
                nextSessionNumber = 1;
            else
                lastSession = sessions{numSessions};
                
                lastSessionNumber = lastSession.sessionNumber;            
                nextSessionNumber = lastSessionNumber + 1;
            end  
        end
        
        function nextDataCollectionSessionNumber = getNextDataCollectionSessionNumber(location)
            sessions = location.sessions;
            
            lastDataCollectionSession = [];
            
            for i=1:length(sessions)
                if sessions{i}.isDataCollectionSession
                    lastDataCollectionSession = sessions{i};
                end
            end
            
            if isempty(lastDataCollectionSession)
                nextDataCollectionSessionNumber = 1;
            else
                lastDataCollectionSessionNumber = lastDataCollectionSession.dataCollectionSessionNumber;
                
                nextDataCollectionSessionNumber = lastDataCollectionSessionNumber + 1;
            end
        end
        
        function location = createDirectories(location, toQuarterPath, projectPath, localPath)
            dirSubtitle = '';
            
            locationDirectory = createDirName(LocationNamingConventions.DIR_PREFIX, num2str(location.locationNumber), dirSubtitle);
            
            createObjectDirectories(projectPath, localPath, toQuarterPath, locationDirectory);
                        
            location.dirName = locationDirectory;
        end
        
        function [] = saveMetadata(location, toLocationPath, projectDir, localDir, saveToBackup)
            saveObjectMetadata(location, projectDir, localDir, toLocationPath, LocationNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function location = wipeoutMetadataFields(location)
            location.dirName = '';
            location.sessions = [];
        end
    end
    
end

