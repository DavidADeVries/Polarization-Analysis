classdef Location
    % Location
    % This is a location where imaging was done
    
    properties
        % set at initialization
        uuid
        dirName
        naviListboxLabel
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
        
        function location = Location(suggestedLocationNumber, existingLocationNumbers, locationCoordsWithLabels, toQuarterPath, projectPath, importDir, userName, subjectType, eyeType, quarterType)
            [cancel, location] = location.enterMetadata(suggestedLocationNumber, existingLocationNumbers, locationCoordsWithLabels, subjectType, eyeType, quarterType, importDir);
            
            if ~cancel
                % set UUID
                location.uuid = generateUUID();
                
                % set metadata history
                location.metadataHistory = MetadataHistoryEntry(userName, Location.empty);
                
                % set navigation listbox label
                location.naviListboxLabel = location.generateListboxLabel();
                
                % make directory/metadata file
                location = location.createDirectories(toQuarterPath, projectPath);
                
                % save metadata
                saveToBackup = true;
                location.saveMetadata(makePath(toQuarterPath, location.dirName), projectPath, saveToBackup);
            else
                location = Location.empty;
            end              
        end
        
        
        function location = editMetadata(location, projectPath, toQuarterSamplePath, userName, dataFilename, existingLocationNumbers, locationCoordsWithLabels, eyeType, subjectType, quarterType)
            [cancel, coords, locationNumber, deposit, notes] = LocationMetadataEntry(eyeType, subjectType, quarterType, [], existingLocationNumbers, locationCoordsWithLabels, '', location);
            
            if ~cancel
                location = updateMetadataHistory(location, userName);
                
                oldDirName = location.dirName;
                oldFilenameSection = location.generateFilenameSection();   
                
                %Assigning values to the location class properties
                location.locationNumber = locationNumber;
                location.deposit = deposit;
                location.locationCoords = coords;
                location.notes = notes;
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                newDirName = location.generateDirName();
                newFilenameSection = location.generateFilenameSection();
                                
                renameDirectory(toQuarterSamplePath, projectPath, oldDirName, newDirName, updateBackupFiles);
                renameFiles(toQuarterSamplePath, projectPath, dataFilename, oldFilenameSection, newFilenameSection, updateBackupFiles);
                                
                location.dirName = newDirName;
                location.naviListboxLabel = location.generateListboxLabel();
                
                location = location.updateFileSelectionEntries(makePath(projectPath, toQuarterSamplePath)); %incase files renamed
                
                location.saveMetadata(makePath(toQuarterSamplePath, location.dirName), projectPath, updateBackupFiles);
            end
            
        end
        
        
        function dirName = generateDirName(location)
            dirSubtitle = '';
            
            dirName = createDirName(LocationNamingConventions.DIR_PREFIX, num2str(location.locationNumber), dirSubtitle, LocationNamingConventions.DIR_NUM_DIGITS);
        end
        
        
        function label = generateListboxLabel(location)             
            label = createNavigationListboxLabel(LocationNamingConventions.NAVI_LISTBOX_PREFIX, location.locationNumber, '');
        end
        
        
        function section = generateFilenameSection(location)
            section = createFilenameSection(LocationNamingConventions.DATA_FILENAME_LABEL, num2str(location.locationNumber));
        end
        
        
        function location = updateFileSelectionEntries(location, toPath)
            sessions = location.sessions;
            
            toPath = makePath(toPath, location.dirName);
            
            for i=1:length(sessions)
                location.sessions{i} = sessions{i}.updateFileSelectionEntries(toPath);
            end
        end
        
        
        function location = importLocation(location, toLocationProjectPath, locationImportPath, projectPath, dataFilename, userName, locations)
            filenameSection = location.generateFilenameSection();
            dataFilename = strcat(dataFilename, filenameSection);
            
            prompt = ['Select the session to which the data being imported from ', locationImportPath, ' belongs to.'];
            title = 'Select Session';
            
            noSessionType = []; %don't select a certian session type
            choiceStrings = location.getSessionChoiceStrings(noSessionType);
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choiceStrings);
            
            if ~cancel
                if createNew
                    [choices, choiceStrings] = choicesFromEnum('SessionTypes');
                    
                    [choice, ok] = listdlg('ListString', choiceStrings, 'SelectionMode', 'single', 'Name', 'Select Data Collection Type', 'PromptString', 'For the data being imported, please select how the data was collected:');
                    
                    if ok
                        sessionType = choices(choice);
                        
                        sessionNumber = location.nextSessionNumber();
                        dataCollectionSessionNumber = location.nextDataCollectionSessionNumber();
                        dataProcessingSessionNumber = location.nextDataProcessingSessionNumber();
                        
                        noSessionType = []; %don't select a certian session type
                        sessionChoices = location.getSessionChoices(noSessionType); % used for linking processing sessions with other sessionsnoSessionType = []; %don't select a certian session type
                        
                        lastSession = getLastSessionByType(locations, sessionType);
                        
                        session = Session.createSession(sessionType,...
                                                        sessionNumber,...
                                                        dataCollectionSessionNumber,...
                                                        dataProcessingSessionNumber,...
                                                        toLocationProjectPath,...
                                                        projectPath,...
                                                        locationImportPath,...
                                                        userName,...
                                                        sessionChoices,...
                                                        lastSession);
                    else
                        session = Session.empty;
                    end
                else
                    session = location.getSessionFromChoice(noSessionType, choice);
                end
                
                if ~isempty(session)
                    toSessionProjectPath = makePath(toLocationProjectPath, session.dirName);
                    
                    session = session.importSession(toSessionProjectPath, locationImportPath, projectPath, dataFilename);
                        
                    session = session.createFileSelectionEntries(makePath(projectPath, toLocationProjectPath));
                    
                    location = location.updateSession(session);
                end
            end
        end
        
        
        function session = getSessionFromChoice(location, sessionType, choice)
            sessions = location.getSessionsOfType(sessionType);
                        
            session = sessions{choice};
        end
        
        function sessions = getSessionsOfType(location, sessionType)
            allSessions = location.sessions;
            numAllSessions = length(allSessions);
            
            if isempty(sessionType) % no session type specified? Allow them all
                sessions = allSessions;
            else
                sessions = {};
                counter = 1;
                
                for i=1:numAllSessions
                    if strcmp(class(allSessions{i}), class(sessionType.sessionClass))
                        sessions{counter} = allSessions{i};
                        
                        counter = counter + 1;
                    end
                end
            end
        end
        
        function sessionChoices = getSessionChoices(location, sessionType)
            sessions = location.getSessionsOfType(sessionType);
            
            numSessions = length(sessions);
            
            sessionChoices = cell(numSessions, 1);
            
            for i=1:numSessions
                sessionChoices{i} = sessions{i};
            end            
        end
        
        function choiceStrings = getSessionChoiceStrings(location, sessionType)
            sessions = location.getSessionChoices(sessionType);
            
            numSessions = length(sessions);
            
            choiceStrings = cell(numSessions, 1);
            
            for i=1:numSessions
                choiceStrings{i}  = sessions{i}.naviListboxLabel;
            end
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
                
                session = session.createFileSelectionEntries(locationPath);
                
                sessions{i} = session;
            end
            
            location.sessions = sessions;
            
            if ~isempty(sessions)
                location.sessionIndex = 1;
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
        
        function location = updateSelectedSession(location, session)
            location.sessions{location.sessionIndex} = session;
        end
        
        
        function [cancel, location] = enterMetadata(location, suggestedLocationNumber, existingLocationNumbers, locationCoordsWithLabels, subjectType, eyeType, quarterType, importPath)
            
            %Call to LocationMetadataEntry Function
            [cancel, coords, locationNumber, deposit, notes] = LocationMetadataEntry(eyeType, subjectType, quarterType, suggestedLocationNumber, existingLocationNumbers, locationCoordsWithLabels, importPath);
            
            if ~cancel
                %Assigning values to the location class properties
                location.locationNumber = locationNumber;
                location.deposit = deposit;
                location.locationCoords = coords;
                location.notes = notes;
            end
            
        end
                
        
        function sessionNumbers = getSessionNumbers(location)
            sessionNumbers = zeros(length(location.sessions), 1); % want this to be an matrix, not cell array
            
            for i=1:length(location.sessions)
                sessionNumbers(i) = location.sessions{i}.sessionNumber;                
            end
        end
        
        
        function dataCollectionSessionNumbers = getDataCollectionSessionNumbers(location)
            dataCollectionSessionNumbers = [];
            
            sessions = location.sessions;
            
            counter = 1;
            
            for i=1:length(sessions)
                if isa(sessions{i}, 'DataCollectionSession')
                    dataCollectionSessionNumbers(counter) = sessions{i}.dataCollectionSessionNumber;
                    
                    counter = counter + 1;
                end
            end
        end
        
        
        function dataProcessingSessionNumbers = getDataProcessingSessionNumbers(location)
            dataProcessingSessionNumbers = [];
            
            sessions = location.sessions;
            
            counter = 1;
            
            for i=1:length(sessions)
                if isa(sessions{i}, 'DataProcessingSession')
                    dataProcessingSessionNumbers(counter) = sessions{i}.dataProcessingSessionNumber;
                    
                    counter = counter + 1;
                end
            end
        end
        
        
        function nextNumber = nextSessionNumber(location)
            sessionNumbers = location.getSessionNumbers();
            
            if isempty(sessionNumbers)
                nextNumber = 1;
            else
                lastNumber = max(sessionNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        
        function nextNumber = nextDataCollectionSessionNumber(location)
            dataCollectionSessionNumbers = location.getDataCollectionSessionNumbers();
            
            if isempty(dataCollectionSessionNumbers)
                nextNumber = 1;
            else
                lastNumber = max(dataCollectionSessionNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        
        function nextNumber = nextDataProcessingSessionNumber(location)
            dataProcessingSessionNumbers = location.getDataProcessingSessionNumbers();
            
            if isempty(dataProcessingSessionNumbers)
                nextNumber = 1;
            else
                lastNumber = max(dataProcessingSessionNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        
        function location = createDirectories(location, toQuarterPath, projectPath)
            locationDirectory = location.generateDirName();
            
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
            
            if numSessions == 0
                disableNavigationListboxes(handles, handles.sessionSelect);
            else            
                sessionOptions = cell(numSessions, 1);
                
                for i=1:numSessions
                    sessionOptions{i} = location.sessions{i}.naviListboxLabel;
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
            locationCoordsString = ['Location Coordinates: ', coordsToString(location.locationCoords)];
            locationNotesString = ['Notes: ', location.notes];
            metadataHistoryStrings = generateMetadataHistoryStrings(location.metadataHistory);
            
            metadataString = {locationNumberString, depositString, locationCoordsString, locationNotesString};
            metadataString = [metadataString, metadataHistoryStrings];
            
        end
        
        
        function location = updateSessionIndex(location, index)
            location.sessionIndex = index;
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
        
        
        function lastSession = getLastSessionByType(location, sessionType)
            sessions = location.sessions;
            
            numSessions = length(sessions);
            
            compareClass = class(sessionType.sessionClass);
            
            lastSession = sessionType.sessionClass;
            
            for i=numSessions:-1:1
                session = sessions{i};
                
                if strcmp(class(session), compareClass)
                    lastSession = session;
                    break;
                end
            end
        end
        
        
        function location = importLegacyData(location, toLocationProjectPath, legacyImportPaths, localProjectPath, dataFilename, userName, locations)
            filenameSection = location.generateFilenameSection();
            dataFilename = strcat(dataFilename, filenameSection);
            
            % import raw data
            importPath = legacyImportPaths.rawDataPath;
            sessionType = SessionTypes.Microscope;
            location = location.importLegacyDataSession(toLocationProjectPath, importPath, localProjectPath, dataFilename, userName, sessionType, locations);
            
            % import registered data
            importPath = legacyImportPaths.registeredDataPath;
            sessionType = SessionTypes.LegacyRegistration;
            location = location.importLegacyDataSession(toLocationProjectPath, importPath, localProjectPath, dataFilename, userName, sessionType, locations);  
            
            % import positive area
            importPath = legacyImportPaths.positiveAreaPath;
            sessionType = SessionTypes.LegacySubsectionSelection;
            location = location.importLegacyDataSession(toLocationProjectPath, importPath, localProjectPath, dataFilename, userName, sessionType, locations);  
                        
            % import negative area
            importPath = legacyImportPaths.negativeAreaPath;
            sessionType = SessionTypes.LegacySubsectionSelection;
            location = location.importLegacyDataSession(toLocationProjectPath, importPath, localProjectPath, dataFilename, userName, sessionType, locations); 
            
        end
        
        function location = importLegacyDataSession(location, toLocationProjectPath, importPath, localProjectPath, dataFilename, userName, sessionType, locations)
            if ~isempty(importPath)                
                prompt = ['Select the session to which the ', sessionType.displayString, ' being imported from ', importPath, ' belongs to.'];
                title = [sessionType.displayString, ' Session'];
                choiceStrings = location.getSessionChoiceStrings(sessionType);
                
                [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choiceStrings);
                
                if ~cancel
                    if createNew
                        sessionNumber = location.nextSessionNumber();
                        dataCollectionSessionNumber = location.nextDataCollectionSessionNumber();
                        dataProcessingSessionNumber = location.nextDataProcessingSessionNumber();
                        
                        noSessionType = []; %don't select a certian session type
                        sessionChoices = location.getSessionChoices(noSessionType); % used for linking processing sessions with other sessions
                        
                        lastSession = getLastSessionByType(locations, sessionType);
                        
                        session = Session.createSession(sessionType,...
                                                        sessionNumber,...
                                                        dataCollectionSessionNumber,...
                                                        dataProcessingSessionNumber,...
                                                        toLocationProjectPath,...
                                                        localProjectPath,...
                                                        importPath,...
                                                        userName,...
                                                        sessionChoices,...
                                                        lastSession);
                    else
                        session = location.getSessionFromChoice(sessionType, choice);
                    end
                    
                    if ~isempty(session)
                        toSessionProjectPath = makePath(toLocationProjectPath, session.dirName);
                        
                        session = session.importSession(toSessionProjectPath, importPath, localProjectPath, dataFilename);
                        
                        session = session.createFileSelectionEntries(makePath(localProjectPath, toLocationProjectPath));
                        
                        location = location.updateSession(session);
                    end
                end
            end
        end
        
                
        function location = editSelectedSessionMetadata(location, projectPath, toLocationPath, userName, dataFilename)
            session = location.getSelectedSession();
            
            if ~isempty(session)
                
                noSessionType = []; %don't select a certian session type
                sessionChoices = location.getSessionChoices(noSessionType); % used for linking processing sessions with other sessions
                                
                filenameSection = location.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                session = session.editMetadata(projectPath, toLocationPath, userName, dataFilename, sessionChoices);
            
                location = location.updateSelectedSession(session);
            end
        end
        
    end
    
end

