classdef Location
    % Location
    % This is a location where imaging was done
    
    properties
        % set at initialization
        dirName
        metadataHistory
        
        % set by metadata entry
        locationNumber %usually a number         
        deposit %T/F tells whether a deposit was present, or if it was a control field        
        locationCoords %[x,y] for unit circle of radius 1 representing the retina, origin at centre
        notes
        
        % session list and index
        sessions
        sessionIndex = 0
    end
    
    methods
        
        
        function location = Location(suggestedLocationNumber, existingLocationNumbers, toQuarterPath, projectPath, importDir, userName, subjectType, eyeType, quarterType)
            [cancel, location] = enterMetadata(suggestedLocationNumber, existingLocationNumbers, subjectType, eyeType, quarterType, importDir, userName);
            
            if ~cancel
                % set metadata history
                location.metadataHistory = {MetadataHistoryEntry(userName)};
                
                % make directory/metadata file
                location = location.createDirectories(toQuarterPath, projectPath);
                
                % save metadata
                saveToBackup = true;
                location.saveMetadata(makePath(toQuarterPath, location.dirName), projectPath, saveToBackup);
            else
                location = Location.empty;
            end              
        end
        
        
        function location = importLocation(location, toLocationProjectPath, locationImportPath, projectPath, dataFilename, userName)
            filenameSection = createFilenameSection(LocationNamingConventions.DATA_FILENAME_LABEL, num2str(location.locationNumber));
            dataFilename = strcat(dataFilename, filenameSection);
            
                
            prompt = ['Select the session to which the data being imported from ', locationImportPath, ' belongs to.'];
            title = 'Select Session';
            choices = location.getSessionChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    listString = DataCollectionSession.getDataCollectionSessionChoices();
                    
                    [choice, ok] = listdlg('ListString', listString, 'SelectionMode', 'single', 'Name', 'Select Data Collection Type', 'PromptString', 'For the data being imported, please select how the data was collected:');
                    
                    if ok
                        suggestedSessionNumber = location.getNextSessionNumber();
                    
                        session = DataCollectionSession.createSession(choice, suggestedSessionNumber, location.existingSessionNumbers(), toLocationProjectPath, projectPath, locationImportPath, userName);
                    else
                        session = DataCollectionSession.empty;
                    end
                else
                    session = session.getSelectedSession(choice);
                end
                
                if ~isempty(quarter)
                    toLocationProjectPath = makePath(quarterProjectPath, location.dirName);
                    
                    location = location.importLocation(toLocationProjectPath, locationImportPath, projectPath, dataFilename, userName);
                    
                    quarter = quarter.updateLocation(location);
                end
            end
            
            
            
            
            
            
            
            dataCollectionSession = importDataCollectionSession(location, toLocationProjectPath, locationImportPath, projectPath, dataFilename, userName);
            
            location = location.addSession(dataCollectionSession);
        end
        
        
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
        
        
        function [cancel, location] = enterMetadata(location, suggestedLocationNumber, existingLocationNumbers, subjectType, eyeType, quarterType, importPath)
            
            %Call to LocationMetadataEntry Function
            [cancel, coords, locationNumber, deposit, notes] = LocationMetadataEntry(eyeType, subjectType, quarterType, suggestedLocationNumber, existingLocationNumbers, importPath);
            
            if ~cancel
                %Assigning values to the location class properties
                location.locationNumber = locationNumber;
                location.deposit = deposit;
                location.locationCoords = coords;
                location.notes = notes;
            end
            
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

