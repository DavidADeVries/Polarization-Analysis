classdef Eye
    % Eye
    % metadata about an eye
        
    properties
        % set at initialization
        dirName        
        metadataHistory
        
        % set by metadata entry
        eyeId
        eyeType % EyeTypes        
        eyeNumber        
        dissectionDate
        dissectionDoneBy
        notes
        
        % list of quarters and index
        quarters
        quarterIndex = 0        
    end
    
    methods
        function eye = Eye(eyeNumber, existingEyeNumbers, toSubjectPath, projectPath, importDir, userName)
            [cancel, eye] = enterMetadata(eyeNumber, existingEyeNumbers, importDir, userName);
            
            if ~cancel
                % set metadata history
                eye.metadataHistory = {MetadataHistoryEntry(userName)};
                
                % make directory/metadata file
                eye = eye.createDirectories(toSubjectPath, projectPath);
                
                % save metadata
                saveToBackup = true;
                eye.saveMetadata(makePath(toSubjectPath, eye.dirName), projectPath, saveToBackup);
            else
                eye = Eye.empty;
            end              
        end
        
        function eye = loadEye(eye, toEyePath, eyeDir)
            eyePath = makePath(toEyePath, eyeDir);

            % load metadata
            vars = load(makePath(eyePath, EyeNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
            eye = vars.metadata;

            % load dir name
            eye.dirName = eyeDir;
            
            % load quarters
            quarterDirs = getMetadataFolders(eyePath, QuarterNamingConventions.METADATA_FILENAME);
            
            numQuarters = length(quarterDirs);
            
            eye.quarters = createEmptyCellArray(Quarter.empty, numQuarters);
            
            for i=1:numQuarters
                eye.quarters{i} = eye.quarters{i}.loadQuarter(eyePath, quarterDirs{i});
            end
            
            if ~isempty(eye.quarters)
                eye.quarterIndex = 1;
            end
        end
        
        function eye = importEye(eye, toEyeProjectPath, eyeImportPath, projectPath, dataFilename, userName, subjectType)  
            dirList = getAllFolders(eyeImportPath);
            
            filenameSection = createFilenameSection(EyeNamingConventions.DATA_FILENAME_LABEL, num2str(eye.eyeNumber));
            dataFilename = [dataFilename, filenameSection];
            
            for i=1:length(dirList)
                folderName = dirList{i};
                
                quarterImportPath = makePath(eyeImportPath, folderName);
                
                prompt = ['Select the quarter to which the data being imported from ', quarterImportPath, ' belongs to.'];
                title = 'Select Quarter';
                choices = subject.getEyeChoices();
                
                [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                
                if ~cancel
                    if createNew
                        suggestedEyeNumber = getNumberFromFolderName(folderName);
                        
                        if isnan(suggestedEyeNumber)
                            suggestedEyeNumber = subject.getNextEyeNumber();
                        end
                        
                        quarter = Quarter(suggestedEyeNumber, eye.existingQuarterNumbers(), toEyeProjectPath, projectPath, quarterImportPath, userName);
                    else
                        quarter = eye.getSelectedQuarter(choice);
                    end
                    
                    if ~isempty(quarter)
                        quarterProjectPath = makePath(toEyeProjectPath, quarter.dirName);
                        
                        quarter = quarter.importQuarter(quarterProjectPath, quarterImportPath, projectPath, dataFilename, userName, subjectType);
                        
                        eye = eye.updateQuarter(quarter);
                    end
                end
            end
        end
        
        function eye = updateQuarter(eye, quarter)
            quarters = eye.quarters;
            numQuarters = length(quarters);
            updated = false;
            
            for i=1:numQuarters
                if quarters{i}.quarterNumber == quarter.quarterNumber
                    eye.quarters{i} = quarter;
                    updated = true;
                    break;
                end
            end
            
            if ~updated
                eye.quarters{numQuarters + 1} = quarter;
                
                if eye.quarterIndex == 0
                    eye.quarterIndex = 1;
                end
            end            
        end
        
        function quarter = getQuarterByNumber(eye, number)
            quarters = eye.quarters;
            
            quarter = Quarter.empty;
            
            for i=1:length(quarters)
                if quarters{i}.quarterNumber == number
                    quarter = quarters{i};
                    break;
                end
            end
        end
        
        function quarterNumbers = getQuarterNumbers(eye)
            quarterNumbers = zeros(length(eye.quarters), 1); % want this to be an matrix, not cell array
            
            for i=1:length(eye.quarters)
                quarterNumbers(i) = eye.quarters{i}.quarterNumber;                
            end
        end
        
        function nextQuarterNumber = getNextQuarterNumber(eye)
            lastQuarterNumber = max(eye.getQuarterNumbers());
            nextQuarterNumber = lastQuarterNumber + 1;
        end
                
        function eye = enterMetadata(eye, suggestedEyeNumber, importPath, userName)
            
            %Call to EyeMetadataEntry GUI
            [eyeId, eyeType, eyeNumber, dissectionDate, dissectionDoneBy, notes] = EyeMetadataEntry(eye, suggestedEyeNumber, userName, importPath);
            
            %Assigning values to Eye Properties
            eye.eyeId = eyeId;
            eye.eyeType = eyeType;
            eye.eyeNumber = eyeNumber;
            eye.dissectionDate = dissectionDate;
            eye.dissectionDoneBy = dissectionDoneBy;
            eye.notes = notes;
        end
        
        function eye = createDirectories(eye, toSubjectPath, projectPath)
            dirSubtitle = eye.eyeType.displayString;
            
            eyeDirectory = createDirName(EyeNamingConventions.DIR_PREFIX, num2str(eye.eyeNumber), dirSubtitle);
            
            createObjectDirectories(projectPath, toSubjectPath, eyeDirectory);
                        
            eye.dirName = eyeDirectory;
        end
        
        function [] = saveMetadata(eye, toEyePath, projectPath, saveToBackup)
            saveObjectMetadata(eye, projectPath, toEyePath, EyeNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function eye = wipeoutMetadataFields(eye)
            eye.dirName = '';
            eye.quarters = [];
        end
        
        function quarter = getSelectedQuarter(eye)
            quarter = [];
            
            if eye.quarterIndex ~= 0
                quarter = eye.quarters{eye.quarterIndex};
            end
        end
        
        function handles = updateNavigationListboxes(eye, handles)
            numQuarters = length(eye.quarters);
            
            quarterOptions = cell(numQuarters, 1);
            
            if numQuarters == 0
                disableNavigationListboxes(handles, handles.quarterSampleSelect);
            else
                for i=1:numQuarters
                    quarterOptions{i} = eye.quarters{i}.dirName;
                end
                
                set(handles.quarterSampleSelect, 'String', quarterOptions, 'Value', eye.quarterIndex, 'Enable', 'on');
                
                handles = eye.getSelectedQuarter().updateNavigationListboxes(handles);
            end
        end
        
        function handles = updateMetadataFields(eye, handles, eyeMetadataString)
            quarter = eye.getSelectedQuarter();
                        
            if isempty(quarter)
                metadataString = eyeMetadataString;
                
                disableMetadataFields(handles, handles.locationMetadata);
            else
                quarterMetadataString = quarter.getMetadataString();
                
                metadataString = [eyeMetadataString, {' '}, quarterMetadataString];
                
                handles = quarter.updateMetadataFields(handles);
            end
            
            set(handles.eyeQuarterSampleMetadata, 'String', metadataString);
        end        
        
        function metadataString = getMetadataString(eye)
            
            eyeIdString = ['Eye ID: ', eye.eyeId];
            eyeTypeString = ['Eye Type: ', eye.eyeType.displayString];
            eyeNumberString = ['Eye Number: ', num2str(eye.eyeNumber)];
            dissectionDateString = ['Dissection Date: ', eye.dissectionDate];
            dissectionDoneByString = ['Dissection Done By: ', eye.dissectionDoneBy];
            eyeNotesString = ['Notes: ', eye.notes];
            
            
            metadataString = {'Eye:', eyeIdString, eyeTypeString, eyeNumberString, dissectionDateString, dissectionDoneByString, eyeNotesString};
            
        end
        
        function eye = updateQuarterSampleIndex(eye, index)
            eye.quarterIndex = index;
        end
        
        function eye = updateLocationIndex(eye, index)
            quarter = eye.getSelectedQuarter();
            
            quarter = quarter.updateLocationIndex(index);
            
            eye = eye.updateQuarter(quarter);
        end
        
        function eye = updateSessionIndex(eye, index)
            quarter = eye.getSelectedQuarter();
            
            quarter = quarter.updateSessionIndex(index);
            
            eye = eye.updateQuarter(quarter);
        end
        
        function eye = updateSubfolderIndex(eye, index)
            quarter = eye.getSelectedQuarter();
            
            quarter = quarter.updateSubfolderIndex(index);
            
            eye = eye.updateQuarter(quarter);
        end
        
        function eye = updateFileIndex(eye, index)
            quarter = eye.getSelectedQuarter();
            
            quarter = quarter.updateFileIndex(index);
            
            eye = eye.updateQuarter(quarter);
        end
        
        function fileSelection = getSelectedFile(eye)
            quarter = eye.getSelectedQuarter();
            
            if ~isempty(quarter)
                fileSelection = quarter.getSelectedFile();
            else
                fileSelection = [];
            end
        end
        
        function eye = incrementFileIndex(eye, increment)            
            quarter = eye.getSelectedQuarter();
            
            quarter = quarter.incrementFileIndex(increment);
            
            eye = eye.updateQuarter(quarter);
        end
    end
    
end

