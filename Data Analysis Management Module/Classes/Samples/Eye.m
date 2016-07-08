classdef Eye < FixedSample
    % Eye
    % metadata about an eye
        
    properties        
        % set by metadata entry
        eyeId = '';
        eyeType = [];% EyeTypes        
        eyeNumber        
        dissectionDate = [];
        dissectionDoneBy = '';
        
        % list of quarters and index
        quarters
        quarterIndex = 0        
    end
    
    methods
        function eye = Eye(sampleNumber, existingSampleNumbers, eyeNumber, existingEyeNumbers, toSubjectPath, projectPath, importPath, userName)
            if nargin > 0
                [cancel, eye] = eye.enterMetadata(sampleNumber, existingSampleNumbers, eyeNumber, existingEyeNumbers, importPath, userName);
                
                if ~cancel
                    % set UUID
                    eye.uuid = generateUUID();
                    
                    % set metadata history
                    eye.metadataHistory = MetadataHistoryEntry(userName, Eye.empty);
                    
                    % set navigation listbox label
                    eye.naviListboxLabel = eye.generateListboxLabel();
                    
                    % make directory/metadata file
                    eye = eye.createDirectories(toSubjectPath, projectPath);
                    
                    % set toPath
                    eye.toPath = toSubjectPath;
                    
                    % save metadata
                    saveToBackup = true;
                    eye.saveMetadata(makePath(toSubjectPath, eye.dirName), projectPath, saveToBackup);
                else
                    eye = Eye.empty;
                end
            end
        end
        
        function eye = editMetadata(eye, projectPath, toSubjectPath, userName, dataFilename, existingSampleNumbers, existingEyeNumbers)
            isEdit = true;
            
            [cancel,...
                eyeId,...
                eyeType,...
                sampleNumber,...
                eyeNumber,...
                dissectionDate,...
                dissectionDoneBy,...
                notes,...
                source,...
                timeOfRemoval,...
                timeOfProcessing,...
                dateReceived,...
                storingLocation,...
                initialFixative,...
                initialFixativePercent,...
                initialFixingTime,...
                secondaryFixative,...
                secondaryFixativePercent,...
                secondaryFixingTime] =...
            EyeMetadataEntry([], existingSampleNumbers, [], existingEyeNumbers, userName, '', isEdit, eye);
            
            if ~cancel
                eye = updateMetadataHistory(eye, userName);
                                
                oldDirName = eye.dirName;
                oldFilenameSection = eye.generateFilenameSection();                
                
                %Assigning values to Eye Properties
                eye.eyeId = eyeId;
                eye.eyeType = eyeType;
                eye.sampleNumber = sampleNumber;
                eye.eyeNumber = eyeNumber;
                eye.dissectionDate = dissectionDate;
                eye.dissectionDoneBy = dissectionDoneBy;
                eye.notes = notes;
                eye.source = source;
                eye.timeOfRemoval = timeOfRemoval;
                eye.timeOfProcessing = timeOfProcessing;
                eye.dateReceived = dateReceived;
                eye.storageLocation = storingLocation;
                eye.initialFixative = initialFixative;
                eye.initialFixativePercent = initialFixativePercent;
                eye.initialFixingTime = initialFixingTime;
                eye.secondaryFixative = secondaryFixative;
                eye.secondaryFixativePercent = secondaryFixativePercent;
                eye.secondaryFixingTime = secondaryFixingTime;
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                newDirName = eye.generateDirName();
                newFilenameSection = eye.generateFilenameSection(); 
                
                renameDirectory(toSubjectPath, projectPath, oldDirName, newDirName, updateBackupFiles);
                renameFiles(toSubjectPath, projectPath, dataFilename, oldFilenameSection, newFilenameSection, updateBackupFiles);
                
                eye.dirName = newDirName;
                eye.naviListboxLabel = eye.generateListboxLabel();
                
                eye = eye.updateFileSelectionEntries(makePath(projectPath, toSubjectPath)); %incase files renamed
                
                eye.saveMetadata(makePath(toSubjectPath, eye.dirName), projectPath, updateBackupFiles);
            end
        end
        
        
        function dirName = generateDirName(eye)            
            dirSubtitle = eye.eyeType.displayString;
            
            dirName = createDirName(EyeNamingConventions.DIR_PREFIX, eye.eyeNumber, dirSubtitle, EyeNamingConventions.DIR_NUM_DIGITS);
        end
        
        
        function label = generateListboxLabel(eye)                    
            subtitle = eye.eyeType.displayString;
            
            label = createNavigationListboxLabel(EyeNamingConventions.NAVI_LISTBOX_PREFIX, eye.eyeNumber, subtitle);
        end
        
        
        function section = generateFilenameSection(eye)
            section = createFilenameSection(EyeNamingConventions.DATA_FILENAME_LABEL, num2str(eye.eyeNumber));
        end
        
        
        function eye = updateFileSelectionEntries(eye, toPath)
            quarters = eye.quarters;
            
            toPath = makePath(toPath, eye.dirName);
            
            for i=1:length(quarters)
                eye.quarters{i} = quarters{i}.updateFileSelectionEntries(toPath);
            end
        end
        
        
        function eye = loadObject(eye, eyePath)            
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
        
        function eye = importSample(eye, toEyeProjectPath, eyeImportPath, projectPath, dataFilename, userName, subjectType)  
            dirList = getAllFolders(eyeImportPath);
            
            filenameSection = eye.generateFilenameSection();
            dataFilename = [dataFilename, filenameSection];
            
            for i=1:length(dirList)
                folderName = dirList{i};
                
                quarterImportPath = makePath(eyeImportPath, folderName);
                
                prompt = ['Select the quarter to which the data being imported from ', quarterImportPath, ' belongs to.'];
                title = 'Select Quarter';
                choices = eye.getQuarterChoices();
                
                [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                
                if ~cancel
                    if createNew
                        suggestedQuarterNumber = eye.nextQuarterNumber();
                        
                        quarter = Quarter(suggestedQuarterNumber, eye.getQuarterNumbers(), toEyeProjectPath, projectPath, quarterImportPath, userName);
                    else
                        quarter = eye.getQuarterFromChoice(choice);
                    end
                    
                    if ~isempty(quarter)
                        quarterProjectPath = makePath(toEyeProjectPath, quarter.dirName);
                        
                        quarter = quarter.importQuarter(quarterProjectPath, quarterImportPath, projectPath, dataFilename, userName, subjectType, eye.eyeType);
                        
                        eye = eye.updateQuarter(quarter);
                    end
                end
            end
        end
        
        function quarter = getQuarterFromChoice(eye, choice)
            quarter = eye.quarters{choice};
        end
        
        function quarterChoices = getQuarterChoices(eye)
            quarters = eye.quarters;
            numQuarters = length(quarters);
            
            quarterChoices = cell(numQuarters, 1);
            
            for i=1:numQuarters
                quarterChoices{i} = quarters{i}.naviListboxLabel;
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
        
        function eye = updateSelectedQuarter(eye, quarter)
            eye.quarters{eye.quarterIndex} = quarter;
        end
                
        function eye = updateSelectedLocation(eye, location)
            quarter = eye.quarters{eye.quarterIndex};
            
            quarter = quarter.updateSelectedLocation(location);
                        
            eye.quarters{eye.quarterIndex} = quarter;
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
            quarters = eye.quarters;
            numQuarters = length(quarters);
            
            quarterNumbers = zeros(numQuarters, 1); % want this to be an matrix, not cell array
                        
            for i=1:numQuarters
                quarterNumbers(i) = quarters{i}.quarterNumber;                
            end
        end
        
        function nextNumber = nextQuarterNumber(eye)
            quarterNumbers = eye.getQuarterNumbers();
            
            if isempty(quarterNumbers)
                nextNumber = 1;
            else
                lastNumber = max(quarterNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        function subSampleNumber = getSubSampleNumber(eye)
            subSampleNumber = eye.eyeNumber;
        end
                
        function [cancel, eye] = enterMetadata(eye, suggestedSampleNumber, existingSampleNumbers, suggestedEyeNumber, existingEyeNumbers, importPath, userName)
            
            %Call to EyeMetadataEntry GUI
            isEdit = false;
            
            [cancel,...
                eyeId,...
                eyeType,...
                sampleNumber,...
                eyeNumber,...
                dissectionDate,...
                dissectionDoneBy,...
                notes,...
                source,...
                timeOfRemoval,...
                timeOfProcessing,...
                dateReceived,...
                storingLocation,...
                initialFixative,...
                initialFixativePercent,...
                initialFixingTime,...
                secondaryFixative,...
                secondaryFixativePercent,...
                secondaryFixingTime] =...
            EyeMetadataEntry(suggestedSampleNumber, existingSampleNumbers, suggestedEyeNumber, existingEyeNumbers, userName, importPath, isEdit);
            
            if ~cancel
                %Assigning values to Eye Properties
                eye.eyeId = eyeId;
                eye.eyeType = eyeType;
                eye.sampleNumber = sampleNumber;
                eye.eyeNumber = eyeNumber;
                eye.dissectionDate = dissectionDate;
                eye.dissectionDoneBy = dissectionDoneBy;
                eye.notes = notes;
                eye.source = source;
                eye.timeOfRemoval = timeOfRemoval;
                eye.timeOfProcessing = timeOfProcessing;
                eye.dateReceived = dateReceived;
                eye.storageLocation = storingLocation;
                eye.initialFixative = initialFixative;
                eye.initialFixativePercent = initialFixativePercent;
                eye.initialFixingTime = initialFixingTime;
                eye.secondaryFixative = secondaryFixative;
                eye.secondaryFixativePercent = secondaryFixativePercent;
                eye.secondaryFixingTime = secondaryFixingTime;
            end
        end
        
        function eye = wipeoutMetadataFields(eye)
            eye.dirName = '';
            eye.quarters = [];            
            eye.toPath = '';
        end
        
        function quarter = getSelectedQuarter(eye)
            quarter = [];
            
            if eye.quarterIndex ~= 0
                quarter = eye.quarters{eye.quarterIndex};
            end
        end
        
        function handles = updateNavigationListboxes(eye, handles)
            numQuarters = length(eye.quarters);
            
            if numQuarters == 0
                disableNavigationListboxes(handles, handles.subSampleSelect);
            else            
                quarterOptions = cell(numQuarters, 1);
                
                for i=1:numQuarters
                    quarterOptions{i} = eye.quarters{i}.naviListboxLabel;
                end
                
                set(handles.subSampleSelect, 'String', quarterOptions, 'Value', eye.quarterIndex, 'Enable', 'on');
                
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
            
            set(handles.sampleMetadata, 'String', metadataString);
        end 
        
        
        function metadataString = getMetadataString(eye)
            
            [sampleNumberString, notesString] = eye.getSampleMetadataString();
            [sourceString, timeOfRemovalString, timeOfProcessingString, dateReceivedString, storageLocationString] = eye.getTissueSampleMetadataString();
            [initFixativeString, initFixPercentString, initFixTimeString, secondFixativeString, secondFixPercentString, secondFixTimeString] = eye.getFixedSampleMetadataString();
            
            eyeIdString = ['Eye ID: ', eye.eyeId];
            eyeTypeString = ['Eye Type: ', displayType(eye.eyeType)];
            eyeNumberString = ['Eye Number: ', num2str(eye.eyeNumber)];
            dissectionDateString = ['Dissection Date: ', displayDate(eye.dissectionDate)];
            dissectionDoneByString = ['Dissection Done By: ', eye.dissectionDoneBy];
            metadataHistoryStrings = generateMetadataHistoryStrings(eye.metadataHistory);
            
            
            metadataString = ...
                ['Eye:',...
                sampleNumberString,...
                eyeNumberString,...
                eyeIdString,...
                eyeTypeString,...
                dissectionDateString,...
                dissectionDoneByString,...
                sourceString,...
                timeOfRemovalString,...
                timeOfProcessingString,...
                dateReceivedString,...
                storageLocationString,...
                initFixativeString,...
                initFixPercentString,...
                initFixTimeString,...
                secondFixativeString,...
                secondFixPercentString,...
                secondFixTimeString,...
                notesString];
            metadataString = [metadataString, metadataHistoryStrings];
            
        end
        
        function eye = updateSubSampleIndex(eye, index)
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
        
        function eye = importLegacyData(eye, toEyeProjectPath, legacyImportPaths, displayImportPath, localProjectPath, dataFilename, userName, subjectType)
            filenameSection = eye.generateFilenameSection();
            dataFilename = [dataFilename, filenameSection];
            
            prompt = ['Select the quarter to which the data being imported from ', displayImportPath, ' belongs to.'];
            title = 'Select Quarter';
            choices = eye.getQuarterChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    suggestedQuarterNumber = eye.nextQuarterNumber();
                    
                    quarter = Quarter(suggestedQuarterNumber, eye.getQuarterNumbers(), toEyeProjectPath, localProjectPath, displayImportPath, userName);
                else
                    quarter = eye.getQuarterFromChoice(choice);
                end
                
                if ~isempty(quarter)
                    toQuarterProjectPath = makePath(toEyeProjectPath, quarter.dirName);
                    
                    quarter = quarter.importLegacyData(toQuarterProjectPath, legacyImportPaths, displayImportPath, localProjectPath, dataFilename, userName, subjectType, eye.eyeType);
                    
                    eye = eye.updateQuarter(quarter);
                end
            end
        end
        
        function eye = editSelectedQuarterMetadata(eye, projectPath, toEyePath, userName, dataFilename)
            quarter = eye.getSelectedQuarter();
            
            if ~isempty(quarter)
                existingQuarterNumbers = eye.getQuarterNumbers();
                filenameSection = eye.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                quarter = quarter.editMetadata(projectPath, toEyePath, userName, dataFilename, existingQuarterNumbers);
            
                eye = eye.updateSelectedQuarter(quarter);
            end
        end
        
        function eye = editSelectedLocationMetadata(eye, projectPath, toEyePath, userName, dataFilename, subjectType)
            quarter = eye.getSelectedQuarter();
            
            if ~isempty(quarter)
                toQuarterPath = makePath(toEyePath, quarter.dirName);
                filenameSection = eye.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                quarter = quarter.editSelectedLocationMetadata(projectPath, toQuarterPath, userName, dataFilename, eye.eyeType, subjectType);
            
                eye = eye.updateSelectedQuarter(quarter);
            end
        end
        
        function eye = editSelectedSessionMetadata(eye, projectPath, toEyePath, userName, dataFilename)
            quarter = eye.getSelectedQuarter();
            
            if ~isempty(quarter)
                toQuarterPath = makePath(toEyePath, quarter.dirName);
                filenameSection = eye.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                quarter = quarter.editSelectedSessionMetadata(projectPath, toQuarterPath, userName, dataFilename);
            
                eye = eye.updateSelectedQuarter(quarter);
            end
        end
               
        function eye = createNewQuarter(eye, projectPath, toPath, userName)
            suggestedQuarterNumber = eye.nextQuarterNumber();
            existingQuarterNumbers = eye.getQuarterNumbers();
            
            toEyePath = makePath(toPath, eye.dirName);
            importDir = '';
            
            quarter = Quarter(suggestedQuarterNumber, existingQuarterNumbers, toEyePath, projectPath, importDir, userName);
            
            if ~isempty(quarter)
                eye = eye.updateQuarter(quarter);
            end
        end  
        
        function eye = createNewLocation(eye, projectPath, toPath, userName, subjectType)
            quarter = eye.getSelectedQuarter();
            
            if ~isempty(quarter)
                toPath = makePath(toPath, eye.dirName);
                
                eyeType = eye.eyeType;
                
                quarter = quarter.createNewLocation(projectPath, toPath, userName, subjectType, eyeType);
                
                eye = eye.updateQuarter(quarter);
            end
        end
                
        function eye = createNewSession(eye, projectPath, toPath, userName, sessionType)
            quarter = eye.getSelectedQuarter();
            
            if ~isempty(quarter)
                toPath = makePath(toPath, eye.dirName);
                
                quarter = quarter.createNewSession(projectPath, toPath, userName, sessionType);
                
                eye = eye.updateQuarter(quarter);
            end
        end
        
        function filenameSections = getFilenameSections(eye, indices)
            if isempty(indices)
                filenameSections = eye.generateFilenameSection();
            else
                index = indices(1);
                
                quarter = eye.quarters{index};
                
                if length(indices) == 1
                    indices = [];
                else
                    indices = indices(2:length(indices));
                end
                
                filenameSections = [eye.generateFilenameSection(), quarter.getFilenameSections(indices)];
            end
        end
        
        % ******************************************
        % FUNCTIONS FOR POLARIZATION ANALYSIS MODULE
        % ******************************************
        
        function [hasValidSession, selectStructureForEye] = createSelectStructure(eye, indices, sessionClass)
            quarters = eye.quarters;
            
            selectStructureForEye = {};
            hasValidSession = false;
            
            for i=1:length(quarters)
                newIndices = [indices, i];
                
                [newHasValidLocation, selectStructureForQuarter] = quarters{i}.createSelectStructure(newIndices, sessionClass);
                
                if newHasValidLocation
                    selectStructureForEye = [selectStructureForEye, selectStructureForQuarter];
                    
                    hasValidSession = true;
                end
            end
            
            if hasValidSession
                switch sessionClass
                    case class(PolarizationAnalysisSession)
                        selectionEntry = PolarizationAnalysisModuleSelectionEntry(eye.naviListboxLabel, indices);
                    case class(SubsectionStatisticsAnalysisSession)
                        selectionEntry = SubsectionStatisticsModuleSelectionEntry(eye.naviListboxLabel, indices);
                    case class(SensitivityAndSpecificityAnalysisSession)
                        selectionEntry = SensitivityAndSpecificityModuleSelectionEntry(eye.naviListboxLabel, indices);
                end
                
                selectStructureForEye = [{selectionEntry}, selectStructureForEye];
            else
                selectStructureForEye = {};
            end
            
        end
           
        
        function [isValidated, toPath] = validateSession(eye, indices, toPath)
            quarter = eye.quarters{indices(1)};
            
            newIndices = indices(2:length(indices));
            toPath = makePath(toPath, eye.dirName);
            
            [isValidated, toPath] = quarter.validateSession(newIndices, toPath);
        end
               
        
        function [eye, selectStructure] = runPolarizationAnalysis(eye, indices, defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName)
            quarter = eye.quarters{indices(1)};
            
            newIndices = indices(2:length(indices));
            toPath = makePath(toPath, eye.dirName);
            fileName = [fileName, eye.generateFilenameSection];
            
            [quarter, selectStructure] = quarter.runPolarizationAnalysis(newIndices, defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName);
            
            eye = eye.updateQuarter(quarter);
        end
        
        function [location, toLocationPath, toLocationFilename] = getSelectedLocation(sample)
            quarter = sample.getSelectedQuarter();
            
            if isempty(quarter)            
                location = [];
            else
                location = quarter.getSelectedLocation();
                
                toLocationPath = makePath(quarter.dirName, location.dirName);
                toLocationFilename = [quarter.generateFilenameSection, location.generateFilenameSection];
            end
        end
        
        function session = getSelectedSession(sample)
            quarter = sample.getSelectedQuarter();
            
            if isempty(quarter)            
                session = [];
            else
                session = quarter.getSelectedSession();
            end
        end
        
                        
        
        % ******************************************
        % FUNCTIONS FOR SUBSECTION STATISTICS MODULE
        % ******************************************
        
        function [data, locationString, sessionString] = getPolarizationAnalysisData(eye, subsectionSession, toIndices, toPath, fileName)
            quarter = eye.quarters{toIndices(1)};
            
            newIndices = toIndices(2:length(toIndices));
            toPath = makePath(toPath, eye.dirName);
            fileName = [fileName, eye.generateFilenameSection];
            
            [data, locationString, sessionString] = quarter.getPolarizationAnalysisData(subsectionSession, newIndices, toPath, fileName);
        end
        
        function mask = getFluoroMask(eye, subsectionSession, toIndices, toPath, fileName)
            quarter = eye.quarters{toIndices(1)};
            
            newIndices = toIndices(2:length(toIndices));
            toPath = makePath(toPath, eye.dirName);
            fileName = [fileName, eye.generateFilenameSection];
            
            mask = quarter.getFluoroMask(subsectionSession, newIndices, toPath, fileName);
        end
        
    end
    
end

