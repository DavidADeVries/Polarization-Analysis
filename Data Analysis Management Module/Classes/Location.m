classdef Location
    % Location
    % This is a location where imaging was done
    
    properties
        % set at initialization
        uuid
        dirName
        naviListboxLabel
        metadataHistory
        
        projectPath = ''
        toPath = ''
        toFilename = ''
        
        % set by metadata entry
        locationNumber %usually a number         
        deposit %T/F tells whether a deposit was present, or if it was a control field        
        locationCoords %[x,y] for unit circle of radius 1 representing the retina, origin at centre
        notes
        
        % session list and index
        sessions
        sessionIndex = 0
                        
        % for use with select structures
        isSelected = [];
        selectStructureFields = [];
    end
    
    methods       
        
        function location = Location(suggestedLocationNumber, existingLocationNumbers, locationCoordsWithLabels, toQuarterPath, projectPath, importDir, userName, subjectType, eyeType, quarterType, toFilename)
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
                
                % set toPath
                location.toPath = toQuarterPath;
                
                % set toFilename
                location.toFilename = toFilename;
                
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
        
        
        function filename = getFilename(location)
            filename = [location.toFilename, location.generateFilenameSection()];
        end 
        
        
        function toPath = getToPath(location)
            toPath = makePath(location.toPath, location.dirName);
        end
        
        
        function toPath = getFullPath(location)
            toPath = makePath(location.projectPath, location.getToPath());
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
                        
                        toFilename = location.getFilename();
                        
                        session = Session.createSession(sessionType,...
                                                        sessionNumber,...
                                                        dataCollectionSessionNumber,...
                                                        dataProcessingSessionNumber,...
                                                        toLocationProjectPath,...
                                                        projectPath,...
                                                        locationImportPath,...
                                                        userName,...
                                                        sessionChoices,...
                                                        lastSession,...
                                                        toFilename);
                    else
                        session = Session.empty;
                    end
                else
                    session = location.getSessionFromChoice(noSessionType, choice);
                end
                
                if ~isempty(session)
                    toSessionProjectPath = makePath(toLocationProjectPath, session.dirName);
                    
                    session = session.importSession(toSessionProjectPath, locationImportPath, projectPath, dataFilename);
                        
                    session = session.createFileSelectionEntries();
                    
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
        
        
        function location = loadObject(location)            
            % load sessions
            [objects, objectIndex] = loadObjects(location, SessionNamingConventions.METADATA_FILENAME);
            
            location.sessions = objects;
            location.sessionIndex = objectIndex;
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
            
            createBackup = true;
            
            createObjectDirectories(projectPath, toQuarterPath, locationDirectory, createBackup);
                        
            location.dirName = locationDirectory;
        end
        
        
        function [] = saveMetadata(location, toLocationPath, projectPath, saveToBackup)
            saveObjectMetadata(location, projectPath, toLocationPath, LocationNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        
        function location = wipeoutMetadataFields(location)
            location.dirName = '';
            location.sessions = [];
            location.toPath = '';
            location.toFilename = '';
            location.projectPath = '';
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
            locationNotesString = ['Notes: ', formatMultiLineTextForDisplay(location.notes)];
            metadataHistoryStrings = generateMetadataHistoryStrings(location.metadataHistory);
            
            metadataString = [locationNumberString, depositString, locationCoordsString, locationNotesString];
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
            
            %import CSLO data
            importPath = legacyImportPaths.CSLODataPath;
            sessionType = SessionTypes.CSLO;
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
                        toFilename = location.getFilename();
                        session = Session.createSession(sessionType,...
                                                        sessionNumber,...
                                                        dataCollectionSessionNumber,...
                                                        dataProcessingSessionNumber,...
                                                        toLocationProjectPath,...
                                                        localProjectPath,...
                                                        importPath,...
                                                        userName,...
                                                        sessionChoices,...
                                                        lastSession,...
                                                        toFilename);
                    else
                        session = location.getSessionFromChoice(sessionType, choice);
                    end
                    
                    if ~isempty(session)
                        toSessionProjectPath = makePath(toLocationProjectPath, session.dirName);
                        
                        session = session.importSession(toSessionProjectPath, importPath, localProjectPath, dataFilename);
                        
                        session = session.createFileSelectionEntries();
                        
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
                
                        
        function location = createNewSession(location, projectPath, toPath, userName, sessionType, locations)
            toPath = makePath(toPath, location.dirName);
            toFilename = location.getFilename();
            
            sessionNumber = location.nextSessionNumber();
            dataCollectionSessionNumber = location.nextDataCollectionSessionNumber();
            dataProcessingSessionNumber = location.nextDataProcessingSessionNumber();
            
            importPath = '';
            
            noSessionType = []; %don't select a certian session type
            sessionChoices = location.getSessionChoices(noSessionType); % used for linking processing sessions with other sessionsnoSessionType = []; %don't select a certian session type
            
            lastSession = getLastSessionByType(locations, sessionType);
            
            session = Session.createSession(...
                sessionType,...
                sessionNumber,...
                dataCollectionSessionNumber,...
                dataProcessingSessionNumber,...
                toPath,...
                projectPath,...
                importPath,...
                userName,...
                sessionChoices,...
                lastSession,...
                toFilename);
            
            if ~isempty(session)
                session = session.createFileSelectionEntries();
                
                location = location.updateSession(session);
            end
        end
        
        function [microscopeSession] = getMicroscopeSession(location)
            allSessions = location.sessions;
            
            microscopeSessions = {};
            counter = 1;
            
            for i=1:length(allSessions)
                session = allSessions{i};
                
                if isa(session, class(MicroscopeSession))
                    microscopeSessions{counter} = session;
                    counter = counter + 1;
                end
            end
            
            if length(microscopeSessions) == 1
                microscopeSession = microscopeSessions{1};
            else
                error(['Non singular microscope session found! DEBUG PATH: ', getObjectPath(location)]);
            end
        end
        
        function filenameSections = getFilenameSections(location, indices)
            if isempty(indices)
                filenameSections = location.generateFilenameSection();
            else
                index = indices(1);
                
                session = location.sessions{index};
                
                if length(indices) == 1
                    indices = [];
                else
                    indices = indices(2:length(indices));
                end
                
                filenameSections = [location.generateFilenameSection(), session.getFilenameSections(indices)];
            end
        end
        
        function location = applySelection(location, indices, isSelected, additionalFields)
            index = indices(1);
            
            len = length(indices);
            
            selectedObject = location.sessions{index};
            
            if len > 1
                indices = indices(2:len);
                
                selectedObject = selectedObject.applySelection(indices, isSelected, additionalFields);
            else
                selectedObject.isSelected = isSelected;
                selectedObject.selectStructureFields = additionalFields;
            end           
            
            location.sessions{index} = selectedObject;
        end
        
        
        % ******************************************
        % FUNCTIONS FOR POLARIZATION ANALYSIS MODULE
        % ******************************************
        
        function [hasValidSession, selectStructureForLocation] = createSelectStructure(location, indices, sessionClass)
            sessions = location.sessions;
            
            selectStructureForLocation = {};
            hasValidSession = false;
            
            label = location.naviListboxLabel;
            
            if strcmp(sessionClass, class(SensitivityAndSpecificityAnalysisSession)) % look for locations
                
                isLocation = true;
                
                hasValidSession = true;
                
                selectionEntry = SensitivityAndSpecificityModuleSelectionEntry(label, indices, location, isLocation);
                
                selectStructureForLocation = [{selectionEntry}, selectStructureForLocation];
            else % look for sessions
                
                for i=1:length(sessions)
                    newIndices = [indices, i];
                    
                    [isValidSession, selectStructureForSession] = sessions{i}.createSelectStructure(newIndices, sessionClass);
                    
                    if isValidSession
                        selectStructureForLocation = [selectStructureForLocation, {selectStructureForSession}];
                        
                        hasValidSession = true;
                    end
                end
                
                if hasValidSession
                    switch sessionClass
                        case class(PolarizationAnalysisSession)
                            selectionEntry = PolarizationAnalysisModuleSelectionEntry(label, indices);
                        case class(SubsectionStatisticsAnalysisSession)
                            selectionEntry = SubsectionStatisticsModuleSelectionEntry(label, indices);
                    end
                    
                    selectStructureForLocation = [{selectionEntry}, selectStructureForLocation];
                else
                    selectStructureForLocation = {};
                end
                
            end
            
        end
           
        
        function [isValidated, toPath] = validateSession(location, indices, toPath)
            session = location.sessions{indices(1)};
            
            toPath = makePath(toPath, location.dirName);
            
            [isValidated, toPath] = session.validateSession(toPath);
        end
        
        
        function [location, selectStructure] = runPolarizationAnalysis(location, indices, defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName)
            parentSession = location.sessions{indices(1)};
            
            toPath = makePath(toPath, location.dirName);
            fileName = [fileName, location.generateFilenameSection];
            
            defaultSession = defaultSession.setSpecificPreAnalysisFields(parentSession, location);
            
            [newPolarizationAnalysisSession, selectStructure] = parentSession.runPolarizationAnalysis(defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName);
            
            location = location.updateSession(newPolarizationAnalysisSession);
        end
        
        
        function [isValidated, toLocationPath, finalSessionsToProcess] = validateLocation(location, toLocationPath, useOnlyRegisteredData, autoUseMostRecentData, autoIgnoreRejectedSessions, doNotRerunDataAboveCutoff, versionCutoff, processFullFieldData, subsectionChoices, rawDataSources)
            toLocationPath = makePath(toLocationPath, location.dirName);
            
            numRawDataSources = length(rawDataSources);
            rawDataSourcesClasses = cell(numRawDataSources, 1);
            
            for i=1:numRawDataSources
                rawDataSourcesClasses{i} = class(rawDataSources{i}.sessionClass);
            end
            
            sessions = location.sessions;
                        
            sessionsToProcess = [];
            
            % get subsections
            
            for i=1:length(subsectionChoices)
                croppingType = subsectionChoices{i};
                
                matchedSessions  = {};
                counter = 1;
                
                legacySubsectionClassString = class(LegacySubsectionSelectionSession);
                subsectionClassString = class(SubsectionSelectionSession);
                
                for j=1:length(sessions)
                    if isa(sessions{j}, legacySubsectionClassString) || isa(sessions{j}, subsectionClassString)
                        if sessions{j}.croppingType == croppingType
                            if sessions{j}.noAnalysisAfterVersionCutoff(doNotRerunDataAboveCutoff, versionCutoff)
                                [linkedSessionNumbers, ~] = getLinkedSessionNumbers(sessions{j}, sessions, [], []);
                                
                                if autoIgnoreRejectedSessions || sessions{j}.isConnectedToRejectedSession(sessions, linkedSessionNumbers)
                                    if ~useOnlyRegisteredData || sessions{j}.isConnectedToRegistedData(sessions, linkedSessionNumbers)
                                        dataCollectionSession = sessions{j}.getLinkedDataCollectionSession(sessions, linkedSessionNumbers);
                                        
                                        if ~isempty(dataCollectionSession)
                                            searchClassString = class(dataCollectionSession);
                                            
                                            if ~isempty(containsString(rawDataSourcesClasses, searchClassString));
                                                % finally get to add it!!
                                                matchedSessions{counter} = sessions{j};
                                                counter = counter + 1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                if length(matchedSessions) > 1 % if there are multiple sessions, we needed to narrow that down
                    if autoUseMostRecentData
                        [selectedSession, duplicateTimes] = getMostRecentSession(matchedSessions);
                    end
                    
                    if duplicateTimes || ~autoUseMostRecentData % duplicateTimes is true is there were two or more sesssions with the same session date
                        [selectedSession, cancel] = chooseSession(matchedSessions, croppingType);
                    end
                    
                    if ~cancel
                        sessionsToProcess = [sessionsToProcess, selectedSession.sessionNumber];
                    else
                        isValidated = false;
                    end
                end
            end
            
            % get full field (if needed!)
            if processFullFieldData
                for i=1:numRawDataSources
                    rawDataSourceClassString = rawDataSourcesClasses{i};
                    
                    matchedSessions = findSessionsMatchClass(sessions, rawDataSourceClassString);
                    
                    filteredSessions = {};
                    counter = 1;
                    
                    for j=1:length(matchedSessions)
                        matchedSession = matchedSessions{j};
                        
                        if matchedSession.noAnalysisAfterVersionCutoff(doNotRerunDataAboveCutoff, versionCutoff, sessions)
                            if useOnlyRegisteredData
                                nonFilteredRegisteredSessions = matchedSession.findRegisteredSessions(sessions);
                                
                                if doNotRerunDataAboveCutoff
                                    registeredSessions = {};
                                    regCounter = 1;
                                    
                                    for k=1:length(nonFilteredRegisteredSessions)
                                        if nonFilteredRegisteredSessions{k}.noAnalysisAfterVersionCutoff(doNotRerunDataAboveCutoff, versionCutoff)
                                            registeredSessions{regCounter} = nonFilteredRegisteredSessions{k};
                                            regCounter = regCounter + 1;
                                        end
                                    end                                    
                                else
                                    registeredSessions = nonFilteredRegisteredSessions;
                                end
                                
                                if isempty(registeredSessions)
                                    % no nothing
                                elseif length(registeredSessions) == 1
                                    filteredSessions{counter} = selectedSession;
                                    counter = counter + 1;
                                else
                                    if autoUseMostRecentData
                                        [selectedSession, duplicateTimes] = getMostRecentSession(registeredSessions);
                                    end
                                    
                                    if duplicateTimes || ~autoUseMostRecentData % duplicateTimes is true is there were two or more sesssions with the same session date
                                        [selectedSession, cancel] = chooseSession(registeredSessions, []);
                                    end
                                    
                                    if ~cancel
                                        filteredSessions{counter} = selectedSession;
                                        counter = counter + 1;
                                    else
                                        isValidated = false;
                                    end
                                end
                            else % if not using registered data, but the data collection session in
                                filteredSessions{counter} = matchedSession;
                                counter = counter + 1;
                            end
                        end
                    end
                    
                    if ~isempty(filteredSessions)
                        if length(filteredSessions) == 1
                            sessionsToProcess = [sessionsToProcess, filteredSessions{1}.sessionNumber];
                        else
                            if autoUseMostRecentData
                                [selectedSession, duplicateTimes] = getMostRecentSession(filteredSessions);
                            end
                            
                            if duplicateTimes || ~autoUseMostRecentData % duplicateTimes is true is there were two or more sesssions with the same session date
                                [selectedSession, cancel] = chooseSession(filteredSessions, []);
                            end
                            
                            if ~cancel
                                sessionsToProcess = [sessionsToProcess, selectedSession.sessionNumber];
                            else
                                isValidated = false;
                            end
                        end
                    end
                end                
            end
            
            
            % WE NOW HAVE A LIST OF THE SESSION NUMBERS TO PROCESS!
            % now do a final check that we have all the data we need for
            % these sessions
            
            finalSessionsToProcess = [];
            
            if isempty(sessionsToProcess)
                isValidated = true;
            else
                for i=1:length(sessionsToProcess)
                    session = getSessionBySessionNumber(sessions, sessionsToProcess(i));
                    
                    if session.hasMMData()
                        finalSessionsToProcess = [finalSessionsToProcess, sessionsToProcess(i)];
                        isValidated = true;
                    else
                        isValidated = false;
                    end
                end
            end
            
        end
        
        
        
        
        
        
        
        % ******************************************
        % FUNCTIONS FOR SUBSECTION STATISTICS MODULE
        % ******************************************
        
        function [data, locationString, sessionString] = getPolarizationAnalysisData(location, subsectionSession, toPath, fileName)
            toPath = makePath(toPath, location.dirName);
            fileName = [fileName, location.generateFilenameSection];
            
            locationString = fileName;
            
            [data, sessionString] = subsectionSession.getPolarizationAnalysisDataFromSubsectionSelectionSession(location.sessions, toPath, fileName);
        end
        
        function mask = getFluoroMask(location, subsectionSession, toPath, fileName)
            toPath = makePath(toPath, location.dirName);
            fileName = [fileName, location.generateFilenameSection];
            
            mask = subsectionSession.getFluoroMask(toPath, fileName);
        end
        
    end
    
end

