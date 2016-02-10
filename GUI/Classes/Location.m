classdef Location
    % Location
    % This is a location where imaging was done
    
    properties
        dirName
        
        locationNumber %usually a number
         
        deposit %T/F tells whether a deposit was present, or if it was a control field
        
        locationCoords %[x,y] for unit circle of radius 1 representing the retina, origin at centre
          
        sessions
        sessionIndex = 0
        
        metadataHistory
        
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
                
                session = createFileSelectionEntries(session, locationPath);
                
                if ~isempty(session.fileSelectionEntries)
                    session.subfolderIndex = 1;
                end
                
                sessions{i} = session;
            end
            
            location.sessions = sessions;
            
            if ~isempty(sessions)
                location.sessionIndex = 1;
            end
        end
        
        function location = importLocation(location, locationProjectPath, locationImportPath, projectPath, dataFilename, userName)
            filenameSection = createFilenameSection(LocationNamingConventions.DATA_FILENAME_LABEL, num2str(location.locationNumber));
            dataFilename = strcat(dataFilename, filenameSection);
            
            dataCollectionSession = importDataCollectionSession(location, locationProjectPath, locationImportPath, projectPath, dataFilename, userName);
            
            location = location.addSession(dataCollectionSession);
        end
        
        function location = addSession(location, session)
            if ~isempty(session)
                sessions = location.sessions;
                numSessions = length(sessions);
                
                sessions{numSessions + 1} = session;
                
                location.sessions = sessions;
                
                if location.sessionIndex == 0
                    location.sessionIndex = 1;
                end
            end
        end
        
        function location = updateSession(location, session)
            sessions = location.sessions;
            numSessions = length(sessions);
            updated = false;
            
            for i=1:numSessions
                if sessions{i}.sessionNumber == session.sessionNumber
                    location.sessions{i} = session;
                    updated = true;
                    break;
                end
            end
            
            if ~updated
                location.sessions{numSessions + 1} = session;
                
                if location.sessionIndex == 0
                    location.sessionIndex = 1;
                end
            end   
        end
        
        function location = enterMetadata(location, suggestedLocationNumber, subjectType, eyeType, quarterType, importPath)
            
            %Call to LocationMetadataEntry Function
            [coords, locationNumber, deposit, notes] = LocationMetadataEntry(eyeType, subjectType, quarterType, suggestedLocationNumber, importPath);
            
            %Assigning values to the location class properties
            location.locationNumber = locationNumber;
            location.deposit = deposit;
            location.locationCoords = coords;
            location.notes = notes;
            
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
        
        function location = createDirectories(location, toQuarterPath, projectPath)
            dirSubtitle = '';
            
            locationDirectory = createDirName(LocationNamingConventions.DIR_PREFIX, num2str(location.locationNumber), dirSubtitle);
            
            createObjectDirectories(projectPath, toQuarterPath, locationDirectory);
                        
            location.dirName = locationDirectory;
        end
        
        function [] = saveMetadata(location, toLocationPath, projectPath, saveToBackup)
            saveObjectMetadata(location, projectPath, toLocationPath, LocationNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function location = wipeoutMetadataFields(location)
            location.dirName = '';
            location.sessions = [];
        end
        
        function session = getSelectedSession(location)
            session = [];
            
            if location.sessionIndex ~= 0
                session = location.sessions{location.sessionIndex};
            end
        end
        
        function handles = updateNavigationListboxes(location, handles)
            numSessions = length(location.sessions);
            
            sessionOptions = cell(numSessions, 1);
            
            if numSessions == 0
                disableNavigationListboxes(handles, handles.sessionSelect);
            else
                for i=1:numSessions
                    sessionOptions{i} = location.sessions{i}.dirName;
                end
                
                set(handles.sessionSelect, 'String', sessionOptions, 'Value', location.sessionIndex, 'Enable', 'on');
                
                handles = location.getSelectedSession().updateNavigationListboxes(handles);
            end
        end
        
        function handles = updateMetadataFields(location, handles)
            session = location.getSelectedSession();
                        
            if isempty(session)
                disableMetadataFields(handles, handles.sessionMetadata);
            else
                metadataString = session.getMetadataString();
                
                set(handles.sessionMetadata, 'String', metadataString);
            end
        end
        
        function metadataString = getMetadataString(location)
            
            locationNumberString = ['Location Number: ', num2str(location.locationNumber)];
            depositString = ['Deposit: ', booleanToString(location.deposit)];
            if ~isempty(location.locationCoords)
                locationCoordsString = ['Location Coordinates: ', coordsIntoString(location.locationCoords(1), location.locationCoords(2))];
            else
                locationCoordsString = ['Location Coordinates: ', 'Unknown'];
            end
            locationNotesString = ['Notes: ', location.notes];
            
            metadataString = {locationNumberString, depositString, locationCoordsString, locationNotesString};
            
        end
        
        function location = updateSessionIndex(location, index)
            location.sessionIndex(index);
        end
        
        function location = updateSubfolderIndex(location, index)
            session = location.getSelectedSession();
            
            session = session.updateSubfolderIndex(index);
            
            location = location.updateSession(session);
        end
        
        function location = updateFileIndex(location, index)
            session = location.getSelectedSession();
            
            session = session.updateFileIndex(index);
            
            location = location.updateSession(session);
        end
        
        function fileSelection = getSelectedFile(location)
            session = location.getSelectedSession();
            
            if ~isempty(session)
                fileSelection = session.getSelectedFile();
            else
                fileSelection = [];
            end
        end
        
        function location = incrementFileIndex(location, increment)            
            session = location.getSelectedSession();
            
            session = session.incrementFileIndex(increment);
            
            location = location.updateSession(session);
        end
    end
    
end

