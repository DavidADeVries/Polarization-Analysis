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
        
        function subject = importSubject(subject, subjectProjectPath, subjectImportPath, projectPath)           
            dirList = getAllFolders(subjectImportPath);
            
            importEyeNumbers = getNumbersFromFolderNames(dirList);
                
            filenameSection = createFilenameSection(SubjectNamingConventions.DATA_FILENAME_LABEL, num2str(subject.subjectNumber));
            dataFilename = filenameSection; % filename start
                        
            for i=1:length(dirList)
                indices = findInArray(importEyeNumbers{i}, subject.getEyeNumbers());
                
                if isempty(indices) % new eye
                    eye = Eye;
                    
                    eye = eye.enterMetadata(importEyeNumbers{i});
                    
                    % make directory/metadata file
                    eye = eye.createDirectories(subjectProjectPath, projectPath);
                    
                    saveToBackup = true;
                    eye.saveMetadata(makePath(subjectProjectPath, eye.dirName), projectPath, saveToBackup);
                else % old eye
                    eye = subject.getEyeByNumber(importEyeNumbers{i});
                end
                
                eyeProjectPath = makePath(subjectProjectPath, eye.dirName);
                eyeImportPath = makePath(subjectImportPath, dirList{i});
                
                eye = eye.importEye(eyeProjectPath, eyeImportPath, projectPath, dataFilename);
                
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
        
        function subject = enterMetadata(subject)
            % age:
            prompt = 'Enter subject''s age (decimal number only):';
            title = 'Subject Age';
            
            subject.age = str2double(inputdlg(prompt, title));
            
            % gender
            prompt = 'Choose subject''s gender';
            selectionMode = 'single';
            title = 'Subject Gender';
            
            [choices, choiceStrings] = choicesFromEnum('GenderTypes');
            
            [selection, ok] = listdlg('ListString', choiceStrings, 'SelectionMode', selectionMode, 'Name', title, 'PromptString', prompt);
            
            subject.gender = choices(selection);
            
            %ADDiagnosis
            prompt = 'Choose subject''s AD Diagnosis';
            selectionMode = 'single';
            title = 'Subject AD Diagnosis';
            
            [choices, choiceStrings] = choicesFromEnum('DiagnosisTypes');
            
            [selection, ok] = listdlg('ListString', choiceStrings, 'SelectionMode', selectionMode, 'Name', title, 'PromptString', prompt);
            
            subject.ADDiagnosis = choices(selection);
            
            %causeOfDeath
            prompt = 'Enter subject''s cause of death:';
            title = 'Subject Cause of Death';
            
            response = inputdlg(prompt, title);
            subject.causeOfDeath = response{1};
            
            %notes
            prompt = 'Enter subject notes:';
            title = 'Subject Notes';
            
            response = inputdlg(prompt, title);
            subject.notes = response{1};
            
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
                
                subject.getSelectedEye().updateNavigationListboxes(handles);
            end
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
    end
    
end

