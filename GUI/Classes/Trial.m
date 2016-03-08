classdef Trial
    %Trial
    %holds metadata and more important directory location for a trial
    
    properties
        % set at initialization
        uuid        
        dirName
        naviListboxLabel
        metadataHistory
        
        % set by metadata entry
        title
        description        
        trialNumber        
        subjectType % dog, human, artifical        
        notes
        
        % list of subjects and the index
        subjects
        subjectIndex = 0
    end
    
    methods
        function trial = Trial(trialNumber, existingTrialNumbers, userName, projectPath, importPath)
            [cancel, trial] = trial.enterMetadata(trialNumber, existingTrialNumbers, importPath);
            
            if ~cancel
                % set UUID
                trial.uuid = generateUUID();
                
                % set metadata history
                trial.metadataHistory = {MetadataHistoryEntry(userName)};
                
                % set navigation listbox label
                trial.naviListboxLabel = trial.generateListboxLabel();
                
                % make directory/metadata file
                toTrialPath = ''; %starts at project path
                trial = trial.createDirectories(toTrialPath, projectPath);
                
                % save metadata
                saveToBackup = true;
                trial.saveMetadata(trial.dirName, projectPath, saveToBackup);
            else
                trial = Trial.empty;
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
            
            createObjectDirectories(projectPath, toProjectPath, trialDirectory);
                        
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
                        
                    subject = trial.createNewSubject(suggestedSubjectNumber, trial.getSubjectNumbers(), trial.dirName, handles.localPath, importDir, handles.userName);
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
        end
        
        function trial = wipeoutMetadataFields(trial)
            trial.dirName = '';
            trial.subjects = [];
        end        
        
        function subject = createNewSubject(trial, nextSubjectNumber, existingSubjectNumbers, toTrialPath, localPath, importDir, userName)
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
                
                if trial.subjectIndex == 0
                    trial.subjectIndex = 1;
                end
            end            
        end
        
        function trial = updateSelectedSubject(trial, subject)
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
            trialSubjectTypeString = ['Subject Type: ', trial.subjectType.displayString];
            trialNotesString = ['Notes: ', trial.notes];
            metadataHistoryStrings = generateMetadataHistoryStrings(trial.metadataHistory);
            
            metadataString = {trialTitleString, trialDescriptionString, trialNumberString, trialSubjectTypeString, trialNotesString};
            metadataString = [metadataString, metadataHistoryStrings];
        end
        
        function trial = updateSubjectIndex(trial, index)            
            trial.subjectIndex = index;
        end
        
        function trial = updateEyeIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateEyeIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateQuarterSampleIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateQuarterSampleIndex(index);
            
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
        
        function trial = importLegacyData(trial, legacySubjectImportDir, localProjectPath, userName)
            % select subject
            
            prompt = ['Select the subject to which the data being imported from ', legacySubjectImportDir, ' belongs to.'];
            title = 'Select Subject';
            choices = trial.getSubjectChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    suggestedSubjectNumber = trial.nextSubjectNumber();
                        
                    subject = trial.createNewSubject(suggestedSubjectNumber, trial.getSubjectNumbers(), trial.dirName, localProjectPath, legacySubjectImportDir, userName);
                else
                    subject = trial.getSubjectFromChoice(choice);
                end
                
                if ~isempty(subject)
                    dataFilename = trial.generateFilenameSection();
                    
                    subject = subject.importLegacyData(makePath(trial.dirName, subject.dirName), legacySubjectImportDir, localProjectPath, dataFilename, userName, trial.subjectType);
                
                    trial = trial.updateSubject(subject);
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
        
        function trial = editSelectedEyeMetadata(trial, projectPath, userName)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                toSubjectPath = makePath(trial.dirName, subject.dirName);
                dataFilename = trial.generateFilenameSection();
                
                subject = subject.editSelectedEyeMetadata(projectPath, toSubjectPath, userName, dataFilename);
            
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
        
    end
    
end

