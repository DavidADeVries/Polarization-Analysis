classdef NaturalSubject < Subject
    % NaturalSubject 
    % a NaturalSubject is a person or animal
    
    properties
        % set by metadata entry
        age %number (decimal please!)
        gender % GenderTypes
        ADDiagnosis % DiagnosisTypes
        causeOfDeath
        medicalHistory
    end
    
    methods
        function subject = NaturalSubject(subjectNumber, existingSubjectNumbers, toTrialPath, projectPath, importDir, userName)
            if nargin > 0
                [cancel, subject] = subject.enterMetadata(subjectNumber, existingSubjectNumbers, importDir, userName);
                
                if ~cancel
                    % set metadata history
                    subject.metadataHistory = {MetadataHistoryEntry(userName)};
                    
                    % set navigation listbox label
                    subject.naviListboxLabel = subject.generateListboxLabel();
                    
                    % make directory/metadata file
                    subject = subject.createDirectories(toTrialPath, projectPath);
                    
                    % save metadata
                    saveToBackup = true;
                    subject.saveMetadata(makePath(toTrialPath, subject.dirName), projectPath, saveToBackup);
                else
                    subject = NaturalSubject.empty;
                end
            end
        end
        
        function subject = editMetadata(subject, projectPath, toTrialPath, userName, dataFilename, existingSubjectNumbers)
            [cancel, subjectNumber, subjectId, age, gender, ADDiagnosis, causeOfDeath, medicalHistory, notes] = NaturalSubjectMetadataEntry([], existingSubjectNumbers, userName, '', subject);
            
            if ~cancel
                subject = updateMetadataHistory(subject, userName);
                                
                oldDirName = subject.dirName;
                oldFilenameSection = subject.generateFilenameSection();
                
                %Assigning values to NaturalSubject Properties
                subject.subjectNumber = subjectNumber;
                subject.subjectId = subjectId;
                subject.age = age;
                subject.gender = gender;
                subject.ADDiagnosis = ADDiagnosis;
                subject.causeOfDeath = causeOfDeath;
                subject.medicalHistory = medicalHistory;
                subject.notes = notes;
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                newDirName = subject.generateDirName();
                newFilenameSection = subject.generateFilenameSection();
                
                renameDirectory(toTrialPath, projectPath, oldDirName, newDirName, updateBackupFiles);
                renameFiles(toTrialPath, projectPath, dataFilename, oldFilenameSection, newFilenameSection, updateBackupFiles);
                
                subject.dirName = newDirName;
                subject.naviListboxLabel = subject.generateListboxLabel();
                
                subject = subject.updateFileSelectionEntries(makePath(projectPath, toTrialPath)); %incase files renamed
                
                subject.saveMetadata(makePath(toTrialPath, subject.dirName), projectPath, updateBackupFiles);
            end
        end
        
        
        function subject = updateFileSelectionEntries(subject, toPath)
            eyes = subject.eyes;
            
            toPath = makePath(toPath, subject.dirName);
            
            for i=1:length(eyes)
                subject.eyes{i} = eyes{i}.updateFileSelectionEntries(toPath);
            end
        end
        
        
        function subject = loadSubject(subject, toSubjectPath, subjectDir)
            subjectPath = makePath(toSubjectPath, subjectDir);
            
            % load metadata
            vars = load(makePath(subjectPath, SubjectNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
            subject = vars.metadata;
            
            % load dir name
            subject.dirName = subjectDir;
            
            % load eyes            
            sampleDirs = getMetadataFolders(subjectPath, SampleNamingConventions.METADATA_FILENAME);
            
            numSamples = length(sampleDirs);
            
            subject.samples = createEmptyCellArray(Sample.empty, numSamples);
            
            for i=1:numSamples
                subject.samples{i} = subject.samples{i}.loadGenericSample(subjectPath, sampleDirs{i});
            end
            
            if ~isempty(subject.samples)
                subject.sampleIndex = 1;
            end
        end
        
        function subject = importSubject(subject, toSubjectProjectPath, subjectImportPath, projectPath, dataFilename, userName, subjectType)
            dirList = getAllFolders(subjectImportPath);
            
            filenameSection = subject.generateFilenameSection();
            dataFilename = [dataFilename, filenameSection]; 
            
            for i=1:length(dirList)
                folderName = dirList{i};
                
                sampleImportPath = makePath(subjectImportPath, folderName);
                
                prompt = ['Select the sample to which the data being imported from ', sampleImportPath, ' belongs to.'];
                title = 'Select Sample';
                choices = subject.getSampleChoices();
                
                [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                
                if ~cancel
                    if createNew
                        [choices, choiceStrings] = choicesFromEnum('SampleTypes');
                        
                        [choice, ok] = listdlg('ListString', choiceStrings,...
                                               'SelectionMode', 'single',...
                                               'Name', 'Select Sample Type',...
                                               'PromptString', 'For the data being imported, please select the type of sample it is from:');
                        
                        if ok
                            sampleType = choices(choice);
                            
                            suggestedSampleNumber = subject.nextSampleNumber();
                            
                            suggestedSubSampleNumber = getNumberFromFolderName(folderName);
                            
                            if isnan(suggestedSubSampleNumber)
                                suggestedSubSampleNumber = subject.nextSubSampleNumber(sampleType);
                            end
                            
                            existingSampleNumbers = subject.getSampleNumbers();
                            existingSubSampleNumbers = subject.getSubSampleNumbers(sampleType);
                            
                            sample = Sample.createSample(sampleType,...
                                                         suggestedSampleNumber,...
                                                         existingSampleNumbers,...
                                                         suggestedSubSampleNumber,...
                                                         existingSubSampleNumbers,...
                                                         toSubjectProjectPath,...
                                                         projectPath,...
                                                         sampleImportPath,...
                                                         userName);
                        end                        
                    else
                        sample = subject.getSampleFromChoice(choice);
                    end
                    
                    if ~isempty(sample)
                        sampleProjectPath = makePath(toSubjectProjectPath, sample.dirName);
                        
                        sample = sample.importSample(sampleProjectPath, sampleImportPath, projectPath, dataFilename, userName, subjectType);
                        
                        subject = subject.updateSample(sample);
                    end
                end                
            end          
        end
        
        function eye = getEyeFromChoice(subject, choice)
            eye = subject.eyes{choice};
        end
        
        function eyeChoices = getEyeChoices(subject)
            eyes = subject.eyes;
            numEyes = length(eyes);
            
            eyeChoices = cell(numEyes, 1);
            
            for i=1:numEyes
                eyeChoices{i} = eyes{i}.naviListboxLabel;
            end
        end
        
        function sample = getSampleFromChoice(subject, choice)
            sample = subject.samples{choice};
        end
        
        function sampleChoices = getSampleChoices(subject)
            samples = subject.samples;
            numSamples = length(samples);
            
            sampleChoices = cell(numSamples, 1);
            
            for i=1:numSamples
                sampleChoices{i} = samples{i}.naviListboxLabel;
            end
        end
        
        function subject = updateEye(subject, eye)
            eyes = subject.eyes;
            numEyes = length(eyes);
            updated = false;
            
            for i=1:numEyes
                if eyes{i}.eyeNumber == eye.eyeNumber
                    subject.eyes{i} = eye;
                    updated = true;
                    break;
                end
            end
            
            if ~updated % add new eye
                subject.eyes{numEyes + 1} = eye;
                
                if subject.eyeIndex == 0
                    subject.eyeIndex = 1;
                end
            end            
        end
        
        function subject = updateSample(subject, sample)
            samples = subject.samples;
            numSamples = length(samples);
            updated = false;
            
            for i=1:numSamples
                if samples{i}.sampleNumber == sample.sampleNumber
                    subject.samples{i} = sample;
                    updated = true;
                    break;
                end
            end
            
            if ~updated % add new sample
                subject.samples{numSamples + 1} = sample;
                
                if subject.sampleIndex == 0
                    subject.sampleIndex = 1;
                end
            end            
        end
        
        function subject = updateSelectedEye(subject, eye)
            subject.eyes{subject.eyeIndex} = eye;
        end
        
        function eye = getEyeByNumber(subject, number)
            eyes = subject.eyes;
            
            eye = Eye.empty;
            
            for i=1:length(eyes)
                if eyes{i}.eyeNumber == number
                    eye = eyes{i};
                    break;
                end
            end
        end
        
        function eyeNumbers = getEyeNumbers(subject)
            eyes = subject.eyes;
            numEyes = length(eyes);
            
            eyeNumbers = zeros(numEyes, 1); % want this to be an matrix, not cell array
            
            for i=1:numEyes
                eyeNumbers(i) = eyes{i}.eyeNumber;                
            end
        end
        
        function nextEyeNumber = nextEyeNumber(subject)
            eyeNumbers = subject.getEyeNumbers();
            
            if isempty(eyeNumbers)
                nextEyeNumber = 1;
            else
                lastEyeNumber = max(eyeNumbers);
                nextEyeNumber = lastEyeNumber + 1;
            end
        end
       
        function [cancel, subject] = enterMetadata(subject, subjectNumber, existingSubjectNumbers, importPath, userName)
            
            %Call to NaturalSubjectMetadataEntry GUI
            [cancel, subjectNumber, subjectId, age, gender, ADDiagnosis, causeOfDeath, medicalHistory, notes] = NaturalSubjectMetadataEntry(subjectNumber, existingSubjectNumbers, userName, importPath);
            
            if ~cancel
                %Assigning values to NaturalSubject Properties
                subject.subjectNumber = subjectNumber;
                subject.subjectId = subjectId;
                subject.age = age;
                subject.gender = gender;
                subject.ADDiagnosis = ADDiagnosis;
                subject.causeOfDeath = causeOfDeath;
                subject.medicalHistory = medicalHistory;
                subject.notes = notes;
            end
            
        end
        
        function subject = wipeoutMetadataFields(subject)
            subject.dirName = '';
            subject.samples = [];
        end
        
        function sample = getSelectedSample(subject)
            sample = [];
            
            if subject.sampleIndex ~= 0
                sample = subject.samples{subject.sampleIndex};
            end
        end
        
        function handles = updateNavigationListboxes(subject, handles)
            numSamples = length(subject.samples);
            
            if numSamples == 0
                disableNavigationListboxes(handles, handles.sampleSelect);
            else            
                sampleOptions = cell(numSamples, 1);
                
                for i=1:numSamples
                    sampleOptions{i} = subject.samples{i}.naviListboxLabel;
                end
                
                set(handles.sampleSelect, 'String', sampleOptions, 'Value', subject.sampleIndex, 'Enable', 'on');
                
                handles = subject.getSelectedSample().updateNavigationListboxes(handles);
            end
        end
        
        function handles = updateMetadataFields(subject, handles)
            sample = subject.getSelectedSample();
                        
            if isempty(sample)
                disableMetadataFields(handles, handles.eyeQuarterSampleMetadata);
            else
                sampleMetadataString = sample.getMetadataString();
                                
                handles = sample.updateMetadataFields(handles, sampleMetadataString);
            end
        end
       
        function metadataString = getMetadataString(subject)
            
            [subjectIdString, subjectNumberString, subjectNotesString] = subject.getSubjectMetadataString();
            
            ageString = ['Age: ', num2str(subject.age)];
            genderString = ['Gender: ', subject.gender.displayString];
            ADDiagnosisString = ['AD Diagnosis: ', subject.ADDiagnosis.displayString];
            causeOfDeathString = ['Cause of Death: ', subject.causeOfDeath];
            medicalHistoryString = ['Medical History: ', subject.medicalHistory];
            metadataHistoryStrings = generateMetadataHistoryStrings(subject.metadataHistory);
            
            metadataString = {subjectIdString, subjectNumberString, ageString, genderString, ADDiagnosisString, causeOfDeathString, medicalHistoryString, subjectNotesString};
            metadataString = [metadataString, metadataHistoryStrings];
            
        end
        
        function subject = updateSampleIndex(subject, index)            
            subject.sampleIndex = index;
        end
        
        function subject = updateQuarterSampleIndex(subject, index)
            sample = subject.getSelectedSample();
            
            sample = sample.updateQuarterSampleIndex(index);
            
            subject = subject.updateSample(sample);
        end
        
        function subject = updateLocationIndex(subject, index)
            eye = subject.getSelectedEye();
            
            eye = eye.updateLocationIndex(index);
            
            subject = subject.updateEye(eye);
        end
        
        function subject = updateSessionIndex(subject, index)
            eye = subject.getSelectedEye();
            
            eye = eye.updateSessionIndex(index);
            
            subject = subject.updateEye(eye);
        end
        
        function subject = updateSubfolderIndex(subject, index)
            eye = subject.getSelectedEye();
            
            eye = eye.updateSubfolderIndex(index);
            
            subject = subject.updateEye(eye);
        end
        
        function subject = updateFileIndex(subject, index)
            eye = subject.getSelectedEye();
            
            eye = eye.updateFileIndex(index);
            
            subject = subject.updateEye(eye);
        end
        
        function fileSelection = getSelectedFile(subject)
            eye = subject.getSelectedEye();
            
            if ~isempty(eye)
                fileSelection = eye.getSelectedFile();
            else
                fileSelection = [];
            end
        end
        
        function subject = incrementFileIndex(subject, increment)            
            eye = subject.getSelectedEye();
            
            eye = eye.incrementFileIndex(increment);
            
            subject = subject.updateEye(eye);
        end
        
        
        function subject = importLegacyDataTypeSpecific(subject, toSubjectProjectPath, legacyImportPaths, displayImportPath, localProjectPath, dataFilename, userName, subjectType)
            filenameSection = subject.generateFilenameSection();
            dataFilename = [dataFilename, filenameSection];
            
            prompt = ['Select the eye to which the data being imported from ', displayImportPath, ' belongs to.'];
            title = 'Select Eye';
            choices = subject.getEyeChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    suggestedEyeNumber = subject.nextEyeNumber();
                    
                    eye = Eye(suggestedEyeNumber, subject.getEyeNumbers(), toSubjectProjectPath, localProjectPath, displayImportPath, userName);
                else
                    eye = subject.getEyeFromChoice(choice);
                end
                
                if ~isempty(eye)
                    toEyeProjectPath = makePath(toSubjectProjectPath, eye.dirName);
                    
                    eye = eye.importLegacyData(toEyeProjectPath, legacyImportPaths, displayImportPath, localProjectPath, dataFilename, userName, subjectType);
                    
                    subject = subject.updateEye(eye);
                end
            end
        end
        
        
        function subject = editSelectedEyeMetadata(subject, projectPath, toSubjectPath, userName, dataFilename)
            eye = subject.getSelectedEye();
            
            if ~isempty(eye)
                existingEyeNumbers = subject.getEyeNumbers();
                filenameSection = subject.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                eye = eye.editMetadata(projectPath, toSubjectPath, userName, dataFilename, existingEyeNumbers);
            
                subject = subject.updateSelectedEye(eye);
            end
        end
        
        function subject = editSelectedQuarterMetadata(subject, projectPath, toSubjectPath, userName, dataFilename)
            eye = subject.getSelectedEye();
            
            if ~isempty(eye)
                toEyePath = makePath(toSubjectPath, eye.dirName);
                filenameSection = subject.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                eye = eye.editSelectedQuarterMetadata(projectPath, toEyePath, userName, dataFilename);
            
                subject = subject.updateSelectedEye(eye);
            end
        end
        
        function subject = editSelectedLocationMetadata(subject, projectPath, toSubjectPath, userName, dataFilename, subjectType)
            eye = subject.getSelectedEye();
            
            if ~isempty(eye)
                toEyePath = makePath(toSubjectPath, eye.dirName);
                filenameSection = subject.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                eye = eye.editSelectedLocationMetadata(projectPath, toEyePath, userName, dataFilename, subjectType);
            
                subject = subject.updateSelectedEye(eye);
            end
        end
        
        function subject = editSelectedSessionMetadata(subject, projectPath, toSubjectPath, userName, dataFilename)
            eye = subject.getSelectedEye();
            
            if ~isempty(eye)
                toEyePath = makePath(toSubjectPath, eye.dirName);
                filenameSection = subject.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                eye = eye.editSelectedSessionMetadata(projectPath, toEyePath, userName, dataFilename);
            
                subject = subject.updateSelectedEye(eye);
            end
        end
        
    end
    
end

