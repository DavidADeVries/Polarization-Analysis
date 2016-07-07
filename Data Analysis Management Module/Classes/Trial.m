classdef Trial
    %Trial
    %holds metadata and more important directory location for a trial
    
    properties
        % set at initialization
        uuid        
        dirName
        naviListboxLabel
        metadataHistory
        toPath = ''
        
        % set by metadata entry
        title
        description        
        trialNumber        
        subjectType % dog, human, artifical        
        notes
        
        % list of subjects and the index
        subjects
        subjectIndex = 0
        
        % list of sessions and the index
        sessions
        sessionIndex = 0;
    end
    
    methods
        function trial = Trial(trialNumber, existingTrialNumbers, userName, projectPath, importPath)
            if nargin > 0
                [cancel, trial] = trial.enterMetadata(trialNumber, existingTrialNumbers, importPath);
                
                if ~cancel
                    % set UUID
                    trial.uuid = generateUUID();
                    
                    % set metadata history
                    trial.metadataHistory = MetadataHistoryEntry(userName, Trial.empty);
                    
                    % set navigation listbox label
                    trial.naviListboxLabel = trial.generateListboxLabel();
                    
                    % make directory/metadata file
                    toTrialPath = ''; %starts at project path
                    trial = trial.createDirectories(toTrialPath, projectPath);
                    
                    % set toPath
                    trial.toPath = toTrialPath;
                    
                    % save metadata
                    saveToBackup = true;
                    trial.saveMetadata(trial.dirName, projectPath, saveToBackup);
                else
                    trial = Trial.empty;
                end
            end
            
        end
        
        
        function dirName = generateDirName(trial)            
            dirSubtitle = trial.title;
            
            dirName = createDirName(TrialNamingConventions.DIR_PREFIX, trial.trialNumber, dirSubtitle, TrialNamingConventions.DIR_NUM_DIGITS);
        end
        
        
        function label = generateListboxLabel(trial)
            label = createNavigationListboxLabel(TrialNamingConventions.NAVI_LISTBOX_PREFIX, trial.trialNumber, trial.title);
        end
                
        
        function section = generateFilenameSection(trial)
            section = createFilenameSection(TrialNamingConventions.DATA_FILENAME_LABEL, num2str(trial.trialNumber));
        end
        
        
        function trial = updateFileSelectionEntries(trial, toPath)
            subjects = trial.subjects;
            
            toPath = makePath(toPath, trial.dirName);
            
            for i=1:length(subjects)
                trial.subjects{i} = subjects{i}.updateFileSelectionEntries(toPath);
            end
        end
                
        function trial = editMetadata(trial, projectPath, userName, existingTrialNumbers)
            [cancel, title, description, trialNumber, subjectType, trialNotes] = TrialMetadataEntry([], existingTrialNumbers, '', trial);
            
            if ~cancel                
                trial = updateMetadataHistory(trial, userName);
                
                oldDirName = trial.dirName;
                oldFilenameSection = trial.generateFilenameSection();
                
                trial.title = title;
                trial.description = description;
                trial.trialNumber = trialNumber;
                trial.subjectType = subjectType;
                trial.notes = trialNotes;
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                newDirName = trial.generateDirName();                
                newFilenameSection = trial.generateFilenameSection();
                
                toPath = '';
                dataFilename = '';
                
                renameDirectory(toPath, projectPath, oldDirName, newDirName, updateBackupFiles);
                renameFiles(toPath, projectPath, dataFilename, oldFilenameSection, newFilenameSection, updateBackupFiles);
                
                trial.dirName = newDirName;
                trial.naviListboxLabel = trial.generateListboxLabel();
                
                trial = trial.updateFileSelectionEntries(projectPath); %incase files renamed
                
                trial.saveMetadata(trial.dirName, projectPath, updateBackupFiles);
            end
            
        end
        
        function [cancel, trial] = enterMetadata(trial, suggestedTrialNumber, existingTrialNumbers, importPath)
            [cancel, title, description, trialNumber, subjectType, trialNotes] = TrialMetadataEntry(suggestedTrialNumber, existingTrialNumbers, importPath);
            
            if ~cancel
                trial.title = title;
                trial.description = description;
                trial.trialNumber = trialNumber;
                trial.subjectType = subjectType;
                trial.notes = trialNotes;
            end
        end
        
        function trial = createDirectories(trial, toProjectPath, projectPath)
            trialDirectory = trial.generateDirName();
            
            createBackup = true;
            
            createObjectDirectories(projectPath, toProjectPath, trialDirectory, createBackup);
                        
            trial.dirName = trialDirectory;
        end
        
        function [] = saveMetadata(trial, toTrialPath, projectPath, saveToBackup)
            saveObjectMetadata(trial, projectPath, toTrialPath, TrialNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function trial = importData(trial, handles, importDir)
            % select subject
            
            prompt = ['Select the subject to which the data being imported from ', importDir, ' belongs to.'];
            title = 'Select Subject';
            choices = trial.getSubjectChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    suggestedSubjectNumber = getNumberFromFolderName(getFilename(importDir));
                    
                    if isnan(suggestedSubjectNumber)
                        suggestedSubjectNumber = trial.nextSubjectNumber();
                    end
                        
                    subject = trial.createSubject(suggestedSubjectNumber, trial.getSubjectNumbers(), trial.dirName, handles.localPath, importDir, handles.userName);
                else
                    subject = trial.getSubjectFromChoice(choice);
                end
                
                if ~isempty(subject)
                    dataFilename = trial.generateFilenameSection();
                    subject = subject.importSubject(makePath(trial.dirName, subject.dirName), importDir, handles.localPath, dataFilename, handles.userName, trial.subjectType);
                
                    trial = trial.updateSubject(subject);
                end
            end            
        end
        
        
        function trial = loadTrial(trial, toTrialPath, trialDir)
            trialPath = makePath(toTrialPath, trialDir);

            % load metadata
            vars = load(makePath(trialPath, TrialNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
            trial = vars.metadata;
            
            % load dir name
            trial.dirName = trialDir;
            
            % load toPath
            trial.toPath = toTrialPath;
            
            % load subjects            
            subjectDirs = getMetadataFolders(trialPath, SubjectNamingConventions.METADATA_FILENAME);
            
            numSubjects = length(subjectDirs);
            
            trial.subjects = createEmptyCellArray(trial.subjectType.subjectClass.empty, numSubjects);
            
            for i=1:numSubjects
                trial.subjects{i} = trial.subjects{i}.loadSubject(trialPath, subjectDirs{i});
            end
            
            if ~isempty(trial.subjects)
                trial.subjectIndex = 1;
            end
            
            % load sessions            
            sessionDirs = getMetadataFolders(trialPath, SessionNamingConventions.METADATA_FILENAME);
            
            numSessions = length(sessionDirs);
            
            sessions = cell(numSessions, 1);
            
            for i=1:numSessions
                vars = load(makePath(trialPath, sessionDirs{i}, SessionNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
                session = vars.metadata;
                
                session.dirName = sessionDirs{i};
                
                session = session.createFileSelectionEntries(trialPath);
                
                sessions{i} = session;
            end
            
            trial.sessions = sessions;
            
            if ~isempty(trial.sessions)
                trial.sessionIndex = 1;
            end
        end
        
        function trial = wipeoutMetadataFields(trial)
            trial.dirName = '';
            trial.subjects = [];
            trial.sessions = [];            
            trial.toPath = '';
        end        
        
        function subject = createSubject(trial, nextSubjectNumber, existingSubjectNumbers, toTrialPath, localPath, importDir, userName)
            if trial.subjectType.subjectClassType == SubjectClassTypes.Natural
                subject = NaturalSubject(nextSubjectNumber, existingSubjectNumbers, toTrialPath, localPath, importDir, userName);
            elseif trial.subjectType.subjectClassType == SubjectClassTypes.Artifical
                subject = ArtificalSubject();
            else
                error('Unknown Subject Type');
            end
        end
        
        function subjectNumbers = getSubjectNumbers(trial)
            subjects = trial.subjects;
            numSubjects = length(subjects);
            
            subjectNumbers = zeros(numSubjects, 1); % want this to be an matrix, not cell array
            
            for i=1:numSubjects
                subjectNumbers(i) = subjects{i}.subjectNumber;                
            end
        end
        
        function nextNumber = nextSubjectNumber(trial)
            subjectNumbers = trial.getSubjectNumbers();
            
            if isempty(subjectNumbers)
                nextNumber = 1;
            else
                lastNumber = max(subjectNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        function trial = updateSubject(trial, subject)
            subjects = trial.subjects;
            numSubjects = length(subjects);
            updated = false;
            
            for i=1:numSubjects
                if subjects{i}.subjectNumber == subject.subjectNumber
                    trial.subjects{i} = subject;
                    updated = true;
                    break;
                end
            end
            
            if ~updated % add new subject
                trial.subjects{numSubjects + 1} = subject;
                
                trial.subjectIndex = numSubjects + 1;
            end            
        end
        
        function trial = updateSelectedSubject(trial, subject)
            trial.subjects{trial.subjectIndex} = subject;
        end
        
        function trial = updateSelectedLocation(trial, location)
            subject = trial.subjects{trial.subjectIndex};
            
            subject = subject.updateSelectedLocation(location);
                        
            trial.subjects{trial.subjectIndex} = subject;
        end
        
        function subjectIds = getSubjectIds(trial)
            subjects = trial.subjects;
            numSubjects = length(subjects);
            
            subjectIds = cell(numSubjects, 1);
            
            for i=1:numSubjects
                subjectIds{i} = subjects{i}.subjectId;
            end
            
        end
        
        function subjectChoices = getSubjectChoices(trial)
            subjects = trial.subjects;
            numSubjects = length(subjects);
            
            subjectChoices = cell(numSubjects, 1);
            
            for i=1:numSubjects
                subjectChoices{i} = subjects{i}.naviListboxLabel;
            end
        end
        
        function subject = getSubjectFromChoice(trial, choice)
            subject = trial.subjects{choice}; 
        end      
        
        function subject = getSelectedSubject(trial)
            subject = [];
            
            if trial.subjectIndex ~= 0
                subject = trial.subjects{trial.subjectIndex};
            end
        end
        
        function handles = updateNavigationListboxes(trial, handles)
            numSubjects = length(trial.subjects);
            
            if numSubjects == 0
                disableNavigationListboxes(handles, handles.subjectSelect);
            else            
                subjectOptions = cell(numSubjects, 1);
                
                for i=1:numSubjects
                    subjectOptions{i} = trial.subjects{i}.naviListboxLabel;
                end
                
                set(handles.subjectSelect, 'String', subjectOptions, 'Value', trial.subjectIndex, 'Enable', 'on');
                
                
                % update trial sessions
                trialSessions = trial.sessions;
                
                if isempty(trialSessions)
                    disableNavigationListbox(handles.trialSessionSelect);
                else
                    sessionOptions = {};
                    
                    for i=1:length(trialSessions)
                        sessionOptions{i} = trialSessions{i}.naviListboxLabel;
                    end
                    
                    set(handles.trialSessionSelect, 'String', sessionOptions, 'Value', trial.sessionIndex, 'Enable', 'on');
                end
                
                % move on to subject
                handles = trial.getSelectedSubject().updateNavigationListboxes(handles);
            end
        end
        
        function handles = updateMetadataFields(trial, handles)
            subject = trial.getSelectedSubject();
                        
            if isempty(subject)
                disableMetadataFields(handles, handles.subjectMetadata);
            else
                metadataString = subject.getMetadataString();
                
                set(handles.subjectMetadata, 'String', metadataString);
                
                handles = subject.updateMetadataFields(handles);
            end
        end
        
        function metadataString = getMetadataString(trial)
            
            trialTitleString = ['Title: ', trial.title];
            trialDescriptionString = ['Description: ', trial.description];
            trialNumberString = ['Trial Number: ', num2str(trial.trialNumber)];
            trialSubjectTypeString = ['Subject Type: ', displayType(trial.subjectType)];
            trialNotesString = ['Notes: ', trial.notes];
            metadataHistoryStrings = generateMetadataHistoryStrings(trial.metadataHistory);
            
            metadataString = {trialTitleString, trialDescriptionString, trialNumberString, trialSubjectTypeString, trialNotesString};
            trialMetadataString = [metadataString, metadataHistoryStrings];
            
            if isempty(trial.sessions)
                metadataString = trialMetadataString;
            else
                trialHeader = {'Trial:'};
                
                trialSessionHeader = {'Trial Session:'};
                
                trialSession = trial.getSelectedTrialSession();
                
                trialSessionMetadataString = trialSession.getMetadataString();
                
                metadataString = [trialHeader, trialMetadataString, {''}, trialSessionHeader, trialSessionMetadataString];
            end
        end
        
        function trial = updateTrialSessionIndex(trial, index)            
            trial.sessionIndex = index;
        end
        
        function trial = updateSubjectIndex(trial, index)            
            trial.subjectIndex = index;
        end
        
        function trialSession = getSelectedTrialSession(trial)
            sessions = trial.sessions;
            
            if isempty(sessions)
                trialSession = [];
            else
                trialSession = sessions{trial.sessionIndex};
            end
        end
        
        function trial = updateSampleIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateSampleIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateSubSampleIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateSubSampleIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateLocationIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateLocationIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateSessionIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateSessionIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateSubfolderIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateSubfolderIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateFileIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateFileIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function fileSelection = getSelectedFile(trial)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                fileSelection = subject.getSelectedFile();
            else
                fileSelection = [];
            end
        end
        
        function trial = incrementFileIndex(trial, increment)            
            subject = trial.getSelectedSubject();
            
            subject = subject.incrementFileIndex(increment);
            
            trial = trial.updateSubject(subject);
        end
        
        function handles = importLegacyData(trial, legacySubjectImportDir, project, handles)
            % select subject
            
            prompt = ['Select the subject to which the data being imported from ', legacySubjectImportDir, ' belongs to.'];
            title = 'Select Subject';
            choices = trial.getSubjectChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    suggestedSubjectNumber = trial.nextSubjectNumber();
                        
                    subject = trial.createSubject(suggestedSubjectNumber, trial.getSubjectNumbers(), trial.dirName, handles.localPath, legacySubjectImportDir, handles.userName);
                else
                    subject = trial.getSubjectFromChoice(choice);
                end
                
                if ~isempty(subject)
                    dataFilename = trial.generateFilenameSection();
                    
                    handles = subject.importLegacyData(makePath(trial.dirName, subject.dirName), legacySubjectImportDir, dataFilename, handles, project, trial);
                end
            end            
        end
        
        function trial = editSelectedSubjectMetadata(trial, projectPath, userName)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toTrialPath = trial.dirName;
                dataFilename = trial.generateFilenameSection();
                
                existingSubjectNumbers = trial.getSubjectNumbers();
                
                subject = subject.editMetadata(projectPath, toTrialPath, userName, dataFilename, existingSubjectNumbers);
            
                trial = trial.updateSelectedSubject(subject);
            end
        end
        
        function trial = editSelectedSampleMetadata(trial, projectPath, userName)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toSubjectPath = makePath(trial.dirName, subject.dirName);
                dataFilename = trial.generateFilenameSection();
                
                subject = subject.editSelectedSampleMetadata(projectPath, toSubjectPath, userName, dataFilename);
            
                trial = trial.updateSelectedSubject(subject);
            end
        end
        
        function trial = editSelectedQuarterMetadata(trial, projectPath, userName)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toSubjectPath = makePath(trial.dirName, subject.dirName);
                dataFilename = trial.generateFilenameSection();
                
                subject = subject.editSelectedQuarterMetadata(projectPath, toSubjectPath, userName, dataFilename);
            
                trial = trial.updateSelectedSubject(subject);
            end
        end
        
        function trial = editSelectedLocationMetadata(trial, projectPath, userName)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toSubjectPath = makePath(trial.dirName, subject.dirName);
                dataFilename = trial.generateFilenameSection();
                
                subject = subject.editSelectedLocationMetadata(projectPath, toSubjectPath, userName, dataFilename, trial.subjectType);
            
                trial = trial.updateSelectedSubject(subject);
            end
        end
        
        function trial = editSelectedSessionMetadata(trial, projectPath, userName)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toSubjectPath = makePath(trial.dirName, subject.dirName);
                dataFilename = trial.generateFilenameSection();
                
                subject = subject.editSelectedSessionMetadata(projectPath, toSubjectPath, userName, dataFilename);
            
                trial = trial.updateSelectedSubject(subject);
            end
        end
        
        function trial = createNewSubject(trial, projectPath, userName)
            suggestedSubjectNumber = trial.nextSubjectNumber;
            existingSubjectNumbers = trial.getSubjectNumbers;
            toTrialPath = trial.dirName;
            importPath = '';
            
            subject = trial.createSubject(suggestedSubjectNumber, existingSubjectNumbers, toTrialPath, projectPath, importPath, userName);
            
            if ~isempty(subject)
                trial = trial.updateSubject(subject);
            end
        end
        
        function trial = createNewSample(trial, projectPath, userName, sampleType)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toPath = trial.dirName;
                
                subject = subject.createNewSample(projectPath, toPath, userName, sampleType);
                
                trial = trial.updateSubject(subject);
            end
        end
                
        function trial = createNewQuarter(trial, projectPath, userName)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toPath = trial.dirName;
                
                subject = subject.createNewQuarter(projectPath, toPath, userName);
                
                trial = trial.updateSubject(subject);
            end
        end
                
        function trial = createNewLocation(trial, projectPath, userName)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toPath = trial.dirName;
                
                subjectType = trial.subjectType;
                
                subject = subject.createNewLocation(projectPath, toPath, userName, subjectType);
                
                trial = trial.updateSubject(subject);
            end
        end
        
        function trial = createNewSession(trial, projectPath, userName, sessionType)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toPath = trial.dirName;
                
                subject = subject.createNewSession(projectPath, toPath, userName, sessionType);
                
                trial = trial.updateSubject(subject);
            end
        end
        
        function [session, toLocationPath, toLocationFilename] = getSelectedLocation(trial)
            subject = trial.getSelectedSubject();
            
            if isempty(subject)            
                session = [];
            else
                [session, toLocationPath, toLocationFilename] = subject.getSelectedLocation();
                
                toLocationPath = makePath(subject.dirName, toLocationPath);
                toLocationFilename = [subject.generateFilenameSection, toLocationFilename];
            end
        end
        
        function session = getSelectedSession(trial)
            subject = trial.getSelectedSubject();
            
            if isempty(subject)            
                session = [];
            else
                session = subject.getSelectedSession();
            end
        end
        
        function sessionNumbers = getSessionNumbers(trial)
            sessionNumbers = zeros(length(trial.sessions), 1); % want this to be an matrix, not cell array
            
            for i=1:length(trial.sessions)
                sessionNumbers(i) = trial.sessions{i}.sessionNumber;                
            end
        end
        
        
        function dataCollectionSessionNumbers = getDataCollectionSessionNumbers(trial)
            dataCollectionSessionNumbers = [];
            
            sessions = trial.sessions;
            
            counter = 1;
            
            for i=1:length(sessions)
                if isa(sessions{i}, class(DataCollectionSession))
                    dataCollectionSessionNumbers(counter) = sessions{i}.dataCollectionSessionNumber;
                    
                    counter = counter + 1;
                end
            end
        end
        
        
        function dataProcessingSessionNumbers = getDataProcessingSessionNumbers(trial)
            dataProcessingSessionNumbers = [];
            
            sessions = trial.sessions;
            
            counter = 1;
            
            for i=1:length(sessions)
                if isa(sessions{i}, class(DataProcessingSession))
                    dataProcessingSessionNumbers(counter) = sessions{i}.dataProcessingSessionNumber;
                    
                    counter = counter + 1;
                end
            end
        end
        
        function nextNumber = nextSessionNumber(trial)
            sessionNumbers = trial.getSessionNumbers();
            
            if isempty(sessionNumbers)
                nextNumber = 1;
            else
                lastNumber = max(sessionNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        function nextNumber = nextDataCollectionSessionNumber(trial)
            dataCollectionSessionNumbers = trial.getDataCollectionSessionNumbers();
            
            if isempty(dataCollectionSessionNumbers)
                nextNumber = 1;
            else
                lastNumber = max(dataCollectionSessionNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        
        function nextNumber = nextDataProcessingSessionNumber(trial)
            dataProcessingSessionNumbers = trial.getDataProcessingSessionNumbers();
            
            if isempty(dataProcessingSessionNumbers)
                nextNumber = 1;
            else
                lastNumber = max(dataProcessingSessionNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        function trial = addSession(trial, session)
            sessions = trial.sessions;
            
            numSessions = length(sessions);
            
            sessions{numSessions+1} = session;
            
            trial.sessions = sessions;
            trial.sessionIndex = numSessions+1;
        end
        
        function filenameSections = getFilenameSections(trial, indices)
            if isempty(indices)
                filenameSections = trial.generateFilenameSection();
            else
                index = indices(1);
                
                subject = trial.subjects{index};
                
                if length(indices) == 1
                    indices = [];
                else
                    indices = indices(2:length(indices));
                end
                
                filenameSections = [trial.generateFilenameSection(), subject.getFilenameSections(indices)];
            end
        end
        
        
        % ******************************************
        % FUNCTIONS FOR POLARIZATION ANALYSIS MODULE
        % ******************************************
        
        function [hasValidSession, locationSelectStructureForTrial] = createSelectStructure(trial, sessionClass)
            subjects = trial.subjects;
            
            locationSelectStructureForTrial = {};
            
            for i=1:length(subjects)
                indices = i;
                
                [hasValidSession, locationSelectStructureForSubject] = subjects{i}.createSelectStructure(indices, sessionClass);
                
                if hasValidSession
                    locationSelectStructureForTrial = [locationSelectStructureForTrial, locationSelectStructureForSubject];
                end
            end
            
            hasValidSession = ~isempty(locationSelectStructureForTrial);
        end
        
        function entry = validateSession(trial, entry)
            indices = entry.indices;
            
            subject = trial.subjects{indices(1)};
            
            newIndices = indices(2:length(indices));
            toPath = trial.dirName;
            
            [isValidated, toPath] = subject.validateSession(newIndices, toPath);
            
            if isValidated
                entry.isValidated = true;
                entry.toPath = toPath;
            else
                entry.isValidated = false;
            end
        end
        
        function [trial, selectStructure] = runPolarizationAnalysis(trial, indices, defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex)
            subject = trial.subjects{indices(1)};
            
            newIndices = indices(2:length(indices));
            toPath = trial.dirName;
            fileName = trial.generateFilenameSection;
            
            [subject, selectStructure] = subject.runPolarizationAnalysis(newIndices, defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName);
            
            trial = trial.updateSubject(subject);
        end
        
        
        
        % ******************************************
        % FUNCTIONS FOR SUBSECTION STATISTICS MODULE
        % ******************************************
        
        function [data, locationString, sessionString] = getPolarizationAnalysisData(trial, subsectionSession, toIndices, toPath)
            subject = trial.subjects{toIndices(1)};
            
            newIndices = toIndices(2:length(toIndices));
            toPath = makePath(toPath, trial.dirName);
            fileName = trial.generateFilenameSection;
            
            [data, locationString, sessionString] = subject.getPolarizationAnalysisData(subsectionSession, newIndices, toPath, fileName);
        end
        
        function mask = getFluoroMask(trial, subsectionSession, toIndices, toPath)
            subject = trial.subjects{toIndices(1)};
            
            newIndices = toIndices(2:length(toIndices));
            toPath = makePath(toPath, trial.dirName);
            fileName = trial.generateFilenameSection;
            
            mask = subject.getFluoroMask(subsectionSession, newIndices, toPath, fileName);
        end
        
    end
    
end

