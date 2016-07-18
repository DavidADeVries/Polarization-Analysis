classdef NaturalSubject < Subject
    % NaturalSubject 
    % a NaturalSubject is a person or animal
    
    properties
        % set by metadata entry
        age %number (decimal please!)
        gender % GenderTypes
        diagnoses % cell array of Diagnosis
        causeOfDeath
        timeOfDeath
        medicalHistory
    end
    
    methods
        function subject = NaturalSubject(subjectNumber, existingSubjectNumbers, toTrialPath, projectPath, importDir, userName, toTrialFilename)
            if nargin > 0
                [cancel, subject] = subject.enterMetadata(subjectNumber, existingSubjectNumbers, importDir, userName);
                
                if ~cancel
                    % set metadata history
                    subject.metadataHistory = MetadataHistoryEntry(userName, NaturalSubject.empty);
                    
                    % set navigation listbox label
                    subject.naviListboxLabel = subject.generateListboxLabel();
                    
                    % make directory/metadata file
                    subject = subject.createDirectories(toTrialPath, projectPath);
                    
                    % set toPath
                    subject.toPath = toTrialPath;
                    
                    % set toFilename
                    subject.toFilename = toTrialFilename;
                    
                    % save metadata
                    saveToBackup = true;
                    subject.saveMetadata(makePath(toTrialPath, subject.dirName), projectPath, saveToBackup);
                else
                    subject = NaturalSubject.empty;
                end
            end
        end
        
        function subject = editMetadata(subject, projectPath, toTrialPath, userName, dataFilename, existingSubjectNumbers)
            isEdit = true;
            
            [cancel, subjectNumber, subjectId, age, gender, diagnoses, causeOfDeath, timeOfDeath, medicalHistory, notes] = NaturalSubjectMetadataEntry([], existingSubjectNumbers, userName, '', isEdit, subject);
            
            if ~cancel
                subject = updateMetadataHistory(subject, userName);
                                
                oldDirName = subject.dirName;
                oldFilenameSection = subject.generateFilenameSection();
                
                %Assigning values to NaturalSubject Properties
                subject.subjectNumber = subjectNumber;
                subject.subjectId = subjectId;
                subject.age = age;
                subject.gender = gender;
                subject.diagnoses = diagnoses;
                subject.causeOfDeath = causeOfDeath;
                subject.timeOfDeath = timeOfDeath;
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
            samples = subject.samples;
            
            toPath = makePath(toPath, subject.dirName);
            
            for i=1:length(samples)
                subject.samples{i} = samples{i}.updateFileSelectionEntries(toPath);
            end
        end
        
        function subject = loadObject(subject)
            
            % load samples
            [objects, objectIndex] = loadObjects(subject, SampleNamingConventions.METADATA_FILENAME);
            
            subject.samples = objects;
            subject.sampleIndex = objectIndex;
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
        
        
        function subject = updateSelectedLocation(subject, location)
            sample = subject.samples{subject.sampleIndex};
            
            sample = sample.updateSelectedLocation(location);
                        
            subject.samples{subject.sampleIndex} = sample;
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
            
            isEdit = false;
            
            %Call to NaturalSubjectMetadataEntry GUI
            [cancel, subjectNumber, subjectId, age, gender, diagnoses, causeOfDeath, timeOfDeath, medicalHistory, notes] = NaturalSubjectMetadataEntry(subjectNumber, existingSubjectNumbers, userName, importPath, isEdit);
            
            if ~cancel
                %Assigning values to NaturalSubject Properties
                subject.subjectNumber = subjectNumber;
                subject.subjectId = subjectId;
                subject.age = age;
                subject.gender = gender;
                subject.diagnoses = diagnoses;
                subject.causeOfDeath = causeOfDeath;
                subject.timeOfDeath = timeOfDeath;
                subject.medicalHistory = medicalHistory;
                subject.notes = notes;
            end
            
        end
        
        function subject = wipeoutMetadataFields(subject)
            subject.dirName = '';
            subject.samples = [];
            subject.toPath = '';
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
                disableMetadataFields(handles, handles.sampleMetadata);
            else
                sampleMetadataString = sample.getMetadataString();
                                
                handles = sample.updateMetadataFields(handles, sampleMetadataString);
            end
        end
       
        function metadataString = getMetadataString(subject)
            
            [subjectIdString, subjectNumberString, subjectNotesString] = subject.getSubjectMetadataString();
            
            ageString = ['Age: ', num2str(subject.age)];
            genderString = ['Gender: ', displayType(subject.gender)];
            diagnosesStrings = ['Diagnoses: ', displayDiagnoses(subject.diagnoses)];
            causeOfDeathString = ['Cause of Death: ', formatMultiLineTextForDisplay(subject.causeOfDeath)];
            timeOfDeathString = ['Time of Death: ', displayDateAndTime(subject.timeOfDeath)];
            medicalHistoryString = ['Medical History: ', formatMultiLineTextForDisplay(subject.medicalHistory)];
            metadataHistoryStrings = generateMetadataHistoryStrings(subject.metadataHistory);
            
            metadataString = [subjectIdString, subjectNumberString, ageString, genderString, causeOfDeathString, timeOfDeathString, medicalHistoryString, subjectNotesString];
            metadataString = [metadataString, diagnosesStrings];
            metadataString = [metadataString, metadataHistoryStrings];
            
        end
        
        function subject = updateSampleIndex(subject, index)            
            subject.sampleIndex = index;
        end
        
        function subject = updateSubSampleIndex(subject, index)
            sample = subject.getSelectedSample();
            
            sample = sample.updateSubSampleIndex(index);
            
            subject = subject.updateSample(sample);
        end
        
        function subject = updateLocationIndex(subject, index)
            sample = subject.getSelectedSample();
            
            sample = sample.updateLocationIndex(index);
            
            subject = subject.updateSample(sample);
        end
        
        function subject = updateSessionIndex(subject, index)
            sample = subject.getSelectedSample();
            
            sample = sample.updateSessionIndex(index);
            
            subject = subject.updateSample(sample);
        end
        
        function subject = updateSubfolderIndex(subject, index)
            sample = subject.getSelectedSample();
            
            sample = sample.updateSubfolderIndex(index);
            
            subject = subject.updateSample(sample);
        end
        
        function subject = updateFileIndex(subject, index)
            sample = subject.getSelectedSample();
            
            sample = sample.updateFileIndex(index);
            
            subject = subject.updateSample(sample);
        end
        
        function fileSelection = getSelectedFile(subject)
            sample = subject.getSelectedSample();
            
            if ~isempty(sample)
                fileSelection = sample.getSelectedFile();
            else
                fileSelection = [];
            end
        end
        
        function subject = incrementFileIndex(subject, increment)            
            sample = subject.getSelectedSample();
            
            sample = sample.incrementFileIndex(increment);
            
            subject = subject.updateSample(sample);
        end
        
        
        function subject = importLegacyDataTypeSpecific(subject, toSubjectProjectPath, legacyImportPaths, displayImportPath, localProjectPath, dataFilename, userName, subjectType)
            filenameSection = subject.generateFilenameSection();
            dataFilename = [dataFilename, filenameSection];
            
            prompt = ['Select the eye to which the data being imported from ', displayImportPath, ' belongs to.'];
            title = 'Select Eye';
            choices = subject.getSampleChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                      sampleType = SampleTypes.Eye;
                      
                      suggestedSampleNumber = subject.nextSampleNumber();
                      suggestedSubSampleNumber = subject.nextSubSampleNumber(sampleType);
                      
                      existingSampleNumbers = subject.getSampleNumbers();
                      existingSubSampleNumbers = subject.getSubSampleNumbers(sampleType);
                      
                      sample = Sample.createSample(...
                          sampleType,...
                          suggestedSampleNumber,...
                          existingSampleNumbers,...
                          suggestedSubSampleNumber,...
                          existingSubSampleNumbers,...
                          toSubjectProjectPath,...
                          localProjectPath,...
                          displayImportPath,...
                          userName);
                else
                    sample = subject.getSampleFromChoice(choice);
                end
                
                if ~isempty(sample)
                    toEyeProjectPath = makePath(toSubjectProjectPath, sample.dirName);
                    
                    sample = sample.importLegacyData(toEyeProjectPath, legacyImportPaths, displayImportPath, localProjectPath, dataFilename, userName, subjectType);
                    
                    subject = subject.updateSample(sample);
                end
            end
        end
        
        
        function subject = editSelectedSampleMetadata(subject, projectPath, toSubjectPath, userName, dataFilename)
            sample = subject.getSelectedSample();
            
            if ~isempty(sample)
                existingSampleNumbers = subject.getSampleNumbers();
                
                sampleType = sample.getSampleType();
                
                existingSubSampleNumbers = subject.getSubSampleNumbers(sampleType);
                
                filenameSection = subject.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                sample = sample.editMetadata(projectPath, toSubjectPath, userName, dataFilename, existingSampleNumbers, existingSubSampleNumbers);
            
                subject = subject.updateSelectedSample(sample);
            end
        end
        
        function subject = editSelectedQuarterMetadata(subject, projectPath, toSubjectPath, userName, dataFilename)
            eye = subject.getSelectedSample();
            
            if ~isempty(eye)
                toEyePath = makePath(toSubjectPath, eye.dirName);
                filenameSection = subject.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                eye = eye.editSelectedQuarterMetadata(projectPath, toEyePath, userName, dataFilename);
            
                subject = subject.updateSelectedSample(eye);
            end
        end
        
        function subject = editSelectedLocationMetadata(subject, projectPath, toSubjectPath, userName, dataFilename, subjectType)
            sample = subject.getSelectedSample();
            
            if ~isempty(sample)
                toSamplePath = makePath(toSubjectPath, sample.dirName);
                filenameSection = subject.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                sample = sample.editSelectedLocationMetadata(projectPath, toSamplePath, userName, dataFilename, subjectType);
            
                subject = subject.updateSelectedSample(sample);
            end
        end
        
        function subject = editSelectedSessionMetadata(subject, projectPath, toSubjectPath, userName, dataFilename)
            sample = subject.getSelectedSample();
            
            if ~isempty(sample)
                toSamplePath = makePath(toSubjectPath, sample.dirName);
                filenameSection = subject.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                sample = sample.editSelectedSessionMetadata(projectPath, toSamplePath, userName, dataFilename);
            
                subject = subject.updateSelectedSample(sample);
            end
        end
        
        function bool = isADPositive(subject, trial)
            bool = false;
            
            diagnoses = subject.diagnoses;
            
            for i=1:length(diagnoses)
                diagnosis = diagnoses{i};
                
                if diagnosis.isADPositive(trial);
                    bool = true;
                    break;
                end
            end
        end
        
        function filenameSections = getFilenameSections(subject, indices)
            if isempty(indices)
                filenameSections = subject.generateFilenameSection();
            else
                index = indices(1);
                
                sample = subject.samples{index};
                
                if length(indices) == 1
                    indices = [];
                else
                    indices = indices(2:length(indices));
                end
                
                filenameSections = [subject.generateFilenameSection(), sample.getFilenameSections(indices)];
            end
        end
        
        function subject = applySelection(subject, indices, isSelected, additionalFields)
            index = indices(1);
            
            len = length(indices);
            
            selectedObject = subject.samples{index};
            
            if len > 1
                indices = indices(2:len);
                
                selectedObject = selectedObject.applySelection(indices, isSelected, additionalFields);
            else
                selectedObject.isSelected = isSelected;
                selectedObject.selectStructureFields = additionalFields;
            end           
            
            subject.samples{index} = selectedObject;
        end
        
        % ************************************************
        % FUNCTIONS FOR SENSITIVITY AND SPECIFICITY MODULE
        % ************************************************
        
        function [dataSheetOutput, rowIndex, sampleRowIndices, allLocationRowIndices] = placeSensitivityAndSpecificityData(selectSubject, dataSheetOutput, rowIndex, adPositiveRowIndex)
            colHeaders = getExcelColHeaders();
            
            samples = selectSubject.samples;
            
            allLocationRowIndices = [];
            
            sampleRowIndices = [];
            rowCounter = 1;
            
            for i=1:length(samples)
                sample = samples{i};
                
                if ~isempty(sample.isSelected) % if empty, that means it was never set (aka it was not included in the select structure)
                    % add row index
                    sampleRowIndices(rowCounter) = rowIndex;
                    rowCounter = rowCounter + 1;
                    
                    % write data
                    sampleRowIndex = rowIndex; %cache this, we need to place the eye and location data first
                    
                    rowIndex = rowIndex + 1;
                    
                    [dataSheetOutput, rowIndex, locationRowIndices] = sample.placeSensitivityAndSpecificityData(dataSheetOutput, rowIndex); %locationRowIndices is a cell array
                    
                    allLocationRowIndices = [allLocationRowIndices, locationRowIndices];
                    
                    % write data
                    rowStr = num2str(sampleRowIndex);
                    
                    dataSheetOutput{sampleRowIndex, 1} = sample.uuid;
                    dataSheetOutput{sampleRowIndex, 2} = sample.getFilename();
                    
                    if sample.isSelected
                        dataSheetOutput{sampleRowIndex, 3} = ['=',colHeaders{3},num2str(adPositiveRowIndex)];
                        dataSheetOutput{sampleRowIndex, 4} = setIndicesOrEquation(colHeaders{4}, locationRowIndices);
                        dataSheetOutput{sampleRowIndex, 5} = setIndicesOrEquation(colHeaders{5}, locationRowIndices);
                        dataSheetOutput{sampleRowIndex, 6} = ['=AND(', colHeaders{3}, rowStr, ',', colHeaders{4}, rowStr, ')'];
                        dataSheetOutput{sampleRowIndex, 7} = ['=AND(NOT(', colHeaders{3}, rowStr, '),', colHeaders{4}, rowStr, ')'];
                        dataSheetOutput{sampleRowIndex, 8} = ['=AND(', colHeaders{3}, rowStr, ',NOT(', colHeaders{4}, rowStr, '))'];
                        dataSheetOutput{sampleRowIndex, 9} = ['=AND(NOT(', colHeaders{3}, rowStr, '),NOT(', colHeaders{4}, rowStr, '))'];
                    else
                        reason = sample.selectStructureFields.exclusionReason;
                        
                        if isempty(reason)
                            reason = SensitivityAndSpecificityConstants.NO_REASON_TAG;
                        end
                        
                        dataSheetOutput{sampleRowIndex,3} = [SensitivityAndSpecificityConstants.NOT_RUN_TAG, reason];
                    end
                end
            end
        end
        
        % ******************************************
        % FUNCTIONS FOR POLARIZATION ANALYSIS MODULE
        % ******************************************
        
        function [hasValidSession, selectStructureForSubject] = createSelectStructure(subject, indices, sessionClass)
            samples = subject.samples;
            
            selectStructureForSubject = {};
            hasValidSession = false;
            
            for i=1:length(samples)
                newIndices = [indices, i];
                
                [newHasValidLocation, selectStructureForSample] = samples{i}.createSelectStructure(newIndices, sessionClass);
                
                if newHasValidLocation
                    selectStructureForSubject = [selectStructureForSubject, selectStructureForSample];
                    
                    hasValidSession = true;
                end
            end
            
            if hasValidSession
                switch sessionClass
                    case class(PolarizationAnalysisSession)
                        selectionEntry = PolarizationAnalysisModuleSelectionEntry(subject.naviListboxLabel, indices);
                    case class(SubsectionStatisticsAnalysisSession)
                        selectionEntry = SubsectionStatisticsModuleSelectionEntry(subject.naviListboxLabel, indices);
                    case class(SensitivityAndSpecificityAnalysisSession)
                        selectionEntry = SensitivityAndSpecificityModuleSelectionEntry(subject.naviListboxLabel, indices, subject);
                end
                
                selectStructureForSubject = [{selectionEntry}, selectStructureForSubject];
            else
                selectStructureForSubject = {};
            end
            
        end
        
        function [isValidated, toPath] = validateSession(subject, indices, toPath)
            sample = subject.samples{indices(1)};
            
            newIndices = indices(2:length(indices));
            toPath = makePath(toPath, subject.dirName);
            
            [isValidated, toPath] = sample.validateSession(newIndices, toPath);
        end
        
        function [subject, selectStructure] = runPolarizationAnalysis(subject, indices, defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName)
            sample = subject.samples{indices(1)};
            
            newIndices = indices(2:length(indices));
            toPath = makePath(toPath, subject.dirName);
            fileName = [fileName, subject.generateFilenameSection];
            
            [sample, selectStructure] = sample.runPolarizationAnalysis(newIndices, defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName);
            
            subject = subject.updateSample(sample);
        end
        
            
        
        % ******************************************
        % FUNCTIONS FOR SUBSECTION STATISTICS MODULE
        % ******************************************
        
        function [data, locationString, sessionString] = getPolarizationAnalysisData(subject, subsectionSession, toIndices, toPath, fileName)
            sample = subject.samples{toIndices(1)};
            
            newIndices = toIndices(2:length(toIndices));
            toPath = makePath(toPath, subject.dirName);
            fileName = [fileName, subject.generateFilenameSection];
            
            [data, locationString, sessionString] = sample.getPolarizationAnalysisData(subsectionSession, newIndices, toPath, fileName);
        end
        
        function mask = getFluoroMask(subject, subsectionSession, toIndices, toPath, fileName)
            sample = subject.samples{toIndices(1)};
            
            newIndices = toIndices(2:length(toIndices));
            toPath = makePath(toPath, subject.dirName);
            fileName = [fileName, subject.generateFilenameSection];
            
            mask = sample.getFluoroMask(subsectionSession, newIndices, toPath, fileName);
        end
        
    end
    
end

