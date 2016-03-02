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
        
        % list of eyes and index
        eyes
        eyeIndex = 0
    end
    
    methods
        function subject = NaturalSubject(subjectNumber, existingSubjectNumbers, toTrialPath, projectPath, importDir, userName)
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
        
        function subject = editMetadata(subject, projectPath, toTrialPath, userName, existingSubjectNumbers)
            [cancel, subjectNumber, subjectId, age, gender, ADDiagnosis, causeOfDeath, medicalHistory, notes] = NaturalSubjectMetadataEntry([], existingSubjectNumbers, userName, '', subject);
            
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
                
                subject = subject.updateMetadataHistory(userName);
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                newDirName = subject.generateDirName();
                oldDirName = subject.dirName;
                
                renameDirectory(toTrialPath, projectPath, oldDirName, newDirName, updateBackupFile);
                
                subject.dirName = newDirName;
                subject.naviListboxLabel = subject.generateListboxLabel();
                
                subject.saveMetadata(makePath(toTrialPath, subject.dirName), projectPath, updateBackupFiles);
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
            eyeDirs = getMetadataFolders(subjectPath, EyeNamingConventions.METADATA_FILENAME);
            
            numEyes = length(eyeDirs);
            
            subject.eyes = createEmptyCellArray(Eye.empty, numEyes);
            
            for i=1:numEyes
                subject.eyes{i} = subject.eyes{i}.loadEye(subjectPath, eyeDirs{i});
            end
            
            if ~isempty(subject.eyes)
                subject.eyeIndex = 1;
            end
        end
        
        function subject = importSubject(subject, toSubjectProjectPath, subjectImportPath, projectPath, dataFilename, userName, subjectType)
            dirList = getAllFolders(subjectImportPath);
            
            filenameSection = createFilenameSection(SubjectNamingConventions.DATA_FILENAME_LABEL, num2str(subject.subjectNumber));
            dataFilename = [dataFilename, filenameSection]; 
            
            for i=1:length(dirList)
                folderName = dirList{i};
                
                eyeImportPath = makePath(subjectImportPath, folderName);
                
                prompt = ['Select the eye to which the data being imported from ', eyeImportPath, ' belongs to.'];
                title = 'Select Eye';
                choices = subject.getEyeChoices();
                
                [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                
                if ~cancel
                    if createNew                        
                        suggestedEyeNumber = getNumberFromFolderName(folderName);
                        
                        if isnan(suggestedEyeNumber)
                            suggestedEyeNumber = subject.nextEyeNumber();
                        end
                        
                        eye = Eye(suggestedEyeNumber, subject.getEyeNumbers(), toSubjectProjectPath, projectPath, subjectImportPath, userName);
                    else
                        eye = subject.getEyeFromChoice(choice);
                    end
                    
                    if ~isempty(eye)
                        eyeProjectPath = makePath(toSubjectProjectPath, eye.dirName);
                        
                        eye = eye.importEye(eyeProjectPath, eyeImportPath, projectPath, dataFilename, userName, subjectType);
                        
                        subject = subject.updateEye(eye);
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
            subject.eyes = [];
        end
        
        function eye = getSelectedEye(subject)
            eye = [];
            
            if subject.eyeIndex ~= 0
                eye = subject.eyes{subject.eyeIndex};
            end
        end
        
        function handles = updateNavigationListboxes(subject, handles)
            numEyes = length(subject.eyes);
            
            if numEyes == 0
                disableNavigationListboxes(handles, handles.eyeSelect);
            else            
                eyeOptions = cell(numEyes, 1);
                
                for i=1:numEyes
                    eyeOptions{i} = subject.eyes{i}.naviListboxLabel;
                end
                
                set(handles.eyeSelect, 'String', eyeOptions, 'Value', subject.eyeIndex, 'Enable', 'on');
                
                handles = subject.getSelectedEye().updateNavigationListboxes(handles);
            end
        end
        
        function handles = updateMetadataFields(subject, handles)
            eye = subject.getSelectedEye();
                        
            if isempty(eye)
                disableMetadataFields(handles, handles.eyeQuarterSampleMetadata);
            else
                eyeMetadataString = eye.getMetadataString();
                                
                handles = eye.updateMetadataFields(handles, eyeMetadataString);
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
        
        function subject = updateEyeIndex(subject, index)            
            subject = subject.eyeIndex(index);
        end
        
        function subject = updateQuarterSampleIndex(subject, index)
            eye = subject.getSelectedEye();
            
            eye = eye.updateQuarterSampleIndex(index);
            
            subject = subject.updateEye(eye);
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
            filenameSection = createFilenameSection(SubjectNamingConventions.DATA_FILENAME_LABEL, num2str(subject.subjectNumber));
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
        
        
        function subject = editSelectedEyeMetadata(subject, projectPath, toSubjectPath, userName)
            eye = subject.getSelectedEye();
            
            if ~isempty(eye)
                existingEyeNumbers = subject.getEyeNumbers();
                
                eye = eye.editMetadata(projectPath, toSubjectPath, userName, existingEyeNumbers);
            
                subject = subject.updateSelectedEye(eye);
            end
        end
        
        function subject = editSelectedQuarterMetadata(subject, projectPath, toSubjectPath, userName)
            eye = subject.getSelectedEye();
            
            if ~isempty(subject)
                toEyePath = makePath(toSubjectPath, eye.dirName);
                
                eye = eye.editSelectedQuarterMetadata(projectPath, toEyePath, userName);
            
                subject = subject.updateSelectedEye(eye);
            end
        end
        
        function subject = editSelectedLocationMetadata(subject, projectPath, toSubjectPath, userName)
            eye = subject.getSelectedEye();
            
            if ~isempty(subject)
                toEyePath = makePath(toSubjectPath, eye.dirName);
                
                eye = eye.editSelectedLocationMetadata(projectPath, toEyePath, userName);
            
                subject = subject.updateSelectedEye(eye);
            end
        end
        
        function subject = editSelectedSessionMetadata(subject, projectPath, toSubjectPath, userName)
            eye = subject.getSelectedEye();
            
            if ~isempty(subject)
                toEyePath = makePath(toSubjectPath, eye.dirName);
                
                eye = eye.editSelectedSessionMetadata(projectPath, toEyePath, userName);
            
                subject = subject.updateSelectedEye(eye);
            end
        end
        
    end
    
end

