classdef NaturalSubject < Subject
    % NaturalSubject 
    % a NaturalSubject is a person or animal
    
    properties      
        age %number (decimal please!)
        gender % GenderTypes
        ADDiagnosis % DiagnosisTypes
        causeOfDeath
        
        eyes
        eyeIndex = 0
    end
    
    methods
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
            
            subject.eyes = createEmptyCellArray(Eye, numEyes);
            
            for i=1:numEyes
                subject.eyes{i} = subject.eyes{i}.loadEye(subjectPath, eyeDirs{i});
            end
            
            if ~isempty(subject.eyes)
                subject.eyeIndex = 1;
            end
        end
        
        function subject = importSubject(subject, subjectProjectPath, subjectImportPath, projectPath, userName, subjectType)           
            dirList = getAllFolders(subjectImportPath);
            
            importEyeNumbers = getNumbersFromFolderNames(dirList);
                
            filenameSection = createFilenameSection(SubjectNamingConventions.DATA_FILENAME_LABEL, num2str(subject.subjectNumber));
            dataFilename = filenameSection; % filename start
                        
            for i=1:length(dirList)
                indices = findInArray(importEyeNumbers{i}, subject.getEyeNumbers());
                
                eyeImportPath = makePath(subjectImportPath, dirList{i});
                
                if isempty(indices) % new eye
                    eye = Eye;
                    
                    eye = eye.enterMetadata(importEyeNumbers{i}, eyeImportPath, userName);
                    
                    % make directory/metadata file
                    eye = eye.createDirectories(subjectProjectPath, projectPath);
                    
                    saveToBackup = true;
                    eye.saveMetadata(makePath(subjectProjectPath, eye.dirName), projectPath, saveToBackup);
                else % old eye
                    eye = subject.getEyeByNumber(importEyeNumbers{i});
                end
                
                eyeProjectPath = makePath(subjectProjectPath, eye.dirName);
                
                eye = eye.importEye(eyeProjectPath, eyeImportPath, projectPath, dataFilename, userName, subjectType);
                
                subject = subject.updateEye(eye);
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
            eyeNumbers = zeros(length(subject.eyes), 1); % want this to be an matrix, not cell array
            
            for i=1:length(subject.eyes)
                eyeNumbers(i) = subject.eyes{i}.eyeNumber;                
            end
        end
        
        function nextEyeNumber = getNextEyeNumber(subject)
            lastEyeNumber = max(subject.getEyeNumbers());
            nextEyeNumber = lastEyeNumber + 1;
        end
       
        function subject = enterMetadata(subject, importPath, userName)
            
            %Call to NaturalSubjectMetadataEntry GUI
            [age, gender, ADDiagnosis, causeOfDeath, notes] = NaturalSubjectMetadataEntry(userName, importPath);
            
            %Assigning values to NaturalSubject Properties
            subject.age = age;
            subject.gender = gender;
            subject.ADDiagnosis = ADDiagnosis;
            subject.causeOfDeath = causeOfDeath;
            subject.notes = notes;
            
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
            
            eyeOptions = cell(numEyes, 1);
            
            if numEyes == 0
                disableNavigationListboxes(handles, handles.eyeSelect);
            else
                for i=1:numEyes
                    eyeOptions{i} = subject.eyes{i}.dirName;
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
            
            metadataString = {subjectIdString, subjectNumberString, ageString, genderString, ADDiagnosisString, causeOfDeathString, subjectNotesString};
            
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
    end
    
end

