classdef Quarter
    % Quarter 
    % stores information about about a quarter of a retina
    
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
        mountingDate
        mountingDoneBy        
        stain
        slideMaterial        
        quarterType % one of [S,T,I,N] (superior, temporal, inferior, nasal, unknown]
        quarterNumber %1, 2, 3, 4 (used for imaging)
        quarterArbitrary % False if which quarter is which is truly known, true otherwise (choosing S,T,I,N is arbitrary, but consistent)
        notes
        
        % locations list and index
        locations
        locationIndex = 0
                
        % for use with select structures
        isSelected = [];
        selectStructureFields = [];
    end
    
    methods
        function quarter = Quarter(suggestedQuarterNumber, existingQuarterNumbers, toEyePath, projectPath, importDir, userName, toFilename)
            [cancel, quarter] = quarter.enterMetadata(suggestedQuarterNumber, existingQuarterNumbers, importDir, userName);
            
            if ~cancel
                % set UUID
                quarter.uuid = generateUUID();
                
                % set metadata history
                quarter.metadataHistory = MetadataHistoryEntry(userName, Quarter.empty);
                
                % set navigation listbox label
                quarter.naviListboxLabel = quarter.generateListboxLabel();
                
                % make directory/metadata file
                quarter = quarter.createDirectories(toEyePath, projectPath);
                
                % set toPath
                quarter.toPath = toEyePath;
                
                % set toFilename
                quarter.toFilename = toFilename;
                
                % save metadata
                saveToBackup = true;
                quarter.saveMetadata(makePath(toEyePath, quarter.dirName), projectPath, saveToBackup);
            else
                quarter = Quarter.empty;
            end              
        end
        
        
        function quarter = editMetadata(quarter, projectPath, toEyePath, userName, dataFilename, existingQuarterNumbers)
            [cancel, stain, slideMaterial, quarterType, quarterArbitrary, quarterNumber, mountingDate, mountingDoneBy, notes] = QuarterMetadataEntry([], existingQuarterNumbers, '', userName, quarter);
            
            if ~cancel
                quarter = updateMetadataHistory(quarter, userName);
                
                oldDirName = quarter.dirName;
                oldFilenameSection = quarter.generateFilenameSection();                
                
                %Assigning values to Quarter Properties
                quarter.stain = stain;
                quarter.slideMaterial = slideMaterial;
                quarter.quarterType = quarterType;
                quarter.quarterArbitrary = quarterArbitrary;
                quarter.quarterNumber = quarterNumber;
                quarter.mountingDate = mountingDate;
                quarter.mountingDoneBy = mountingDoneBy;
                quarter.notes = notes;
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                newDirName = quarter.generateDirName();
                newFilenameSection = quarter.generateFilenameSection();  
                
                renameDirectory(toEyePath, projectPath, oldDirName, newDirName, updateBackupFiles);
                renameFiles(toEyePath, projectPath, dataFilename, oldFilenameSection, newFilenameSection, updateBackupFiles);
                
                quarter.dirName = newDirName;
                quarter.naviListboxLabel = quarter.generateListboxLabel();
                
                quarter = quarter.updateFileSelectionEntries(makePath(projectPath, toEyePath)); %incase files renamed
                
                quarter.saveMetadata(makePath(toEyePath, quarter.dirName), projectPath, updateBackupFiles);
            end
            
        end
        
        
        function dirName = generateDirName(quarter)
            dirSubtitle = quarter.quarterType.displayString;
            
            dirName = createDirName(QuarterNamingConventions.DIR_PREFIX, quarter.quarterNumber, dirSubtitle, QuarterNamingConventions.DIR_NUM_DIGITS);
        end
        
        
        function label = generateListboxLabel(quarter) 
            subtitle = quarter.quarterType.displayString;
            
            label = createNavigationListboxLabel(QuarterNamingConventions.NAVI_LISTBOX_PREFIX, quarter.quarterNumber, subtitle);
        end
        
        
        function section = generateFilenameSection(quarter)
            section = createFilenameSection(QuarterNamingConventions.DATA_FILENAME_LABEL, num2str(quarter.quarterNumber));
        end
        
        
        function filename = getFilename(quarter)
            filename = [quarter.toFilename, quarter.generateFilenameSection()];
        end  
        
        
        function toPath = getToPath(quarter)
            toPath = makePath(quarter.toPath, quarter.dirName);
        end
        
        
        function toPath = getFullPath(quarter)
            toPath = makePath(quarter.projectPath, quarter.getToPath());
        end
        
        
        function quarter = updateFileSelectionEntries(quarter, toPath)
            locations = quarter.locations;
            
            toPath = makePath(toPath, quarter.dirName);
            
            for i=1:length(locations)
                quarter.locations{i} = locations{i}.updateFileSelectionEntries(toPath);
            end
        end
        
        
        function quarter = loadObject(quarter)            
            % load locations            
            [objects, objectIndex] = loadObjects(quarter, LocationNamingConventions.METADATA_FILENAME);
            
            quarter.locations = objects;
            quarter.locationIndex = objectIndex;
            
        end
        
        function quarter = importQuarter(quarter, toQuarterProjectPath, quarterImportPath, projectPath, dataFilename, userName, subjectType, eyeType)
            dirList = getAllFolders(quarterImportPath);
            
            filenameSection = quarter.generateFilenameSection();
            dataFilename = [dataFilename, filenameSection];
            
            for i=1:length(dirList)
                folderName = dirList{i};
                
                locationImportPath = makePath(quarterImportPath, folderName);
                
                prompt = ['Select the location to which the data being imported from ', locationImportPath, ' belongs to.'];
                title = 'Select Location';
                choices = quarter.getLocationChoices();
                
                [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                
                if ~cancel
                    if createNew
                        suggestedLocationNumber = getNumberFromFolderName(folderName);
                        
                        if isnan(suggestedLocationNumber)
                            suggestedLocationNumber = quarter.nextLocationNumber();
                        end
                        
                        locationNumbers = quarter.getLocationNumbers();
                        rejectSelectedLocation = false;
                        locationCoordsWithLabels = quarter.generateLocationCoordsWithLabels(rejectSelectedLocation);
                        
                        location = Location(suggestedLocationNumber, locationNumbers, locationCoordsWithLabels, toQuarterProjectPath, projectPath, locationImportPath, userName, subjectType, eyeType, quarter.quarterType); 
                    else
                        location = quarter.getLocationFromChoice(choice);
                    end
                    
                    if ~isempty(location)
                        locationProjectPath = makePath(toQuarterProjectPath, location.dirName);
                        
                        location = location.importLocation(locationProjectPath, locationImportPath, projectPath, dataFilename, userName, quarter.locations);
                        
                        quarter = quarter.updateLocation(location);
                    end
                end
            end
        end

        function location = getLocationFromChoice(quarter, choice)
            location = quarter.locations{choice};
        end
        
        function locationChoices = getLocationChoices(quarter)
            locations = quarter.locations;
            numLocations = length(locations);
            
            locationChoices = cell(numLocations, 1);
            
            for i=1:numLocations
                locationChoices{i} = locations{i}.naviListboxLabel;
            end
        end
        
        function quarter = updateLocation(quarter, location)
            locations = quarter.locations;
            numLocations = length(locations);
            updated = false;
            
            for i=1:numLocations
                if locations{i}.locationNumber == location.locationNumber
                    quarter.locations{i} = location;
                    updated = true;
                    break;
                end
            end
            
            if ~updated
                quarter.locations{numLocations + 1} = location;
                
                if quarter.locationIndex == 0
                    quarter.locationIndex = 1;
                end
            end   
        end
        
        function quarter = updateSelectedLocation(quarter, location)
            quarter.locations{quarter.locationIndex} = location;
        end
        
        function location = getLocationByNumber(quarter, number)
            locations = quarter.locations;
            
            location = Location.empty;
            
            for i=1:length(locations)
                if locations{i}.locationNumber == number
                    location = locations{i};
                    break;
                end
            end
        end
        
        function locationNumbers = getLocationNumbers(quarter)
            locations = quarter.locations;
            numLocations = length(locations);
            
            locationNumbers = zeros(numLocations, 1); % want this to be an matrix, not cell array
            
            for i=1:numLocations
                locationNumbers(i) = locations{i}.locationNumber;                
            end
        end    
        
        function nextNumber = nextLocationNumber(quarter)
            locationNumbers = quarter.getLocationNumbers();
            
            if isempty(locationNumbers)
                nextNumber = 1;
            else
                lastNumber = max(locationNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        function [cancel, quarter] = enterMetadata(quarter, suggestedQuarterNumber, existingQuarterNumbers, importPath, userName)
            %Call to QuarterMetadataEntry GUI
            [cancel, stain, slideMaterial, quarterType, quarterArbitrary, quarterNumber, mountingDate, mountingDoneBy, notes] = QuarterMetadataEntry(suggestedQuarterNumber, existingQuarterNumbers, importPath, userName);
            
            if ~cancel
                %Assigning values to Quarter Properties
                quarter.stain = stain;
                quarter.slideMaterial = slideMaterial;
                quarter.quarterType = quarterType;
                quarter.quarterArbitrary = quarterArbitrary;
                quarter.quarterNumber = quarterNumber;
                quarter.mountingDate = mountingDate;
                quarter.mountingDoneBy = mountingDoneBy;
                quarter.notes = notes;
            end
            
        end
        
        function quarter = createDirectories(quarter, toEyePath, projectPath)
             
            quarterDirectory = quarter.generateDirName();
            
            createBackup = true;
            
            createObjectDirectories(projectPath, toEyePath, quarterDirectory, createBackup);
                        
            quarter.dirName = quarterDirectory;
        end
        
        function [] = saveMetadata(quarter, toQuarterPath, projectPath, saveToBackup)
            saveObjectMetadata(quarter, projectPath, toQuarterPath, QuarterNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function quarter = wipeoutMetadataFields(quarter)
            quarter.dirName = '';
            quarter.locations = [];
            quarter.toPath = '';
            quarter.toFilename = '';
        end
        
        function location = getSelectedLocation(quarter)
            location = [];
            
            if quarter.locationIndex ~= 0
                location = quarter.locations{quarter.locationIndex};
            end
        end
        
        function handles = updateNavigationListboxes(quarter, handles)
            numLocations = length(quarter.locations);
            
            if numLocations == 0
                disableNavigationListboxes(handles, handles.locationSelect);
            else            
                locationOptions = cell(numLocations, 1);
                
                for i=1:numLocations
                    locationOptions{i} = quarter.locations{i}.naviListboxLabel;
                end
                
                set(handles.locationSelect, 'String', locationOptions, 'Value', quarter.locationIndex, 'Enable', 'on');
                
                handles = quarter.getSelectedLocation().updateNavigationListboxes(handles);
            end
        end
        
        function handles = updateMetadataFields(quarter, handles)
            location = quarter.getSelectedLocation();
                        
            if isempty(location)
                disableMetadataFields(handles, handles.locationMetadata);
            else
                metadataString = location.getMetadataString();
                
                set(handles.locationMetadata, 'String', metadataString);
                
                handles = location.updateMetadataFields(handles);
            end
        end
       
        function metadataString = getMetadataString(quarter)
            
            mountingDateString = ['Mounting Date: ', displayDate(quarter.mountingDate)];
            mountingDoneByString = ['Mounting Done By: ', quarter.mountingDoneBy];
            stainString = ['Stain: ', quarter.stain];
            slideMaterialString = ['Slide Material: ', quarter.slideMaterial];
            quarterTypeString = ['Quarter Type: ', displayType(quarter.quarterType)];
            quarterNumberString = ['Quarter number: ', num2str(quarter.quarterNumber)];
            quarterArbitraryString = ['Quarter Arbitrary: ', booleanToString(quarter.quarterArbitrary)];
            quarterNotesString = ['Notes: ', formatMultiLineTextForDisplay(quarter.notes)];
            metadataHistoryStrings = generateMetadataHistoryStrings(quarter.metadataHistory);
            
            metadataString = ['Quarter:', mountingDateString, mountingDoneByString, stainString, slideMaterialString, quarterTypeString, quarterNumberString, quarterArbitraryString, quarterNotesString];
            metadataString = [metadataString, metadataHistoryStrings];
        end
        
        function quarter = updateLocationIndex(quarter, index)
            quarter.locationIndex = index;
        end
        
        function quarter = updateSessionIndex(quarter, index)
            location = quarter.getSelectedLocation();
            
            location = location.updateSessionIndex(index);
            
            quarter = quarter.updateLocation(location);
        end
        
        function quarter = updateSubfolderIndex(quarter, index)
            location = quarter.getSelectedLocation();
            
            location = location.updateSubfolderIndex(index);
            
            quarter = quarter.updateLocation(location);
        end
        
        function quarter = updateFileIndex(quarter, index)
            location = quarter.getSelectedLocation();
            
            location = location.updateFileIndex(index);
            
            quarter = quarter.updateLocation(location);
        end
        
        function fileSelection = getSelectedFile(quarter)
            location = quarter.getSelectedLocation();
            
            if ~isempty(location)
                fileSelection = location.getSelectedFile();
            else
                fileSelection = [];
            end
        end
        
        function quarter = incrementFileIndex(quarter, increment)            
            location = quarter.getSelectedLocation();
            
            location = location.incrementFileIndex(increment);
            
            quarter = quarter.updateLocation(location);
        end
        
        function coordsWithLabels = generateLocationCoordsWithLabels(quarter, rejectSelectedLocation)
            locations = quarter.locations;
            
            selectedLocation = quarter.getSelectedLocation();
            
            coordsWithLabels = {};
            counter = 1;
            
            for i=1:length(locations)
                location = locations{i};
                
                if (~rejectSelectedLocation || location.locationNumber ~= selectedLocation.locationNumber) && (~isempty(location.locationCoords))
                    coordsWithLabels{counter} = struct('coords', location.locationCoords, 'label', num2str(location.locationNumber));
                    
                    counter = counter + 1;
                end
            end
        end
        
        function quarter = importLegacyData(quarter, toQuarterProjectPath, legacyImportPaths, displayImportPath, localProjectPath, dataFilename, userName, subjectType, eyeType)
            filenameSection = quarter.generateFilenameSection();
            dataFilename = [dataFilename, filenameSection];
            
            prompt = ['Select the location to which the data being imported from ', displayImportPath, ' belongs to.'];
            title = 'Select Location';
            choices = quarter.getLocationChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    suggestedLocationNumber = quarter.nextLocationNumber();
                    
                    locationNumbers = quarter.getLocationNumbers();
                    rejectSelectedLocation = false;
                    locationCoordsWithLabels = quarter.generateLocationCoordsWithLabels(rejectSelectedLocation);
                    
                    location = Location(suggestedLocationNumber, locationNumbers, locationCoordsWithLabels, toQuarterProjectPath, localProjectPath, displayImportPath, userName, subjectType, eyeType, quarter.quarterType);
                else
                    location = quarter.getLocationFromChoice(choice);
                end
                
                if ~isempty(location)
                    toLocationProjectPath = makePath(toQuarterProjectPath, location.dirName);
                                        
                    location = location.importLegacyData(toLocationProjectPath, legacyImportPaths, localProjectPath, dataFilename, userName, quarter.locations);
                    
                    quarter = quarter.updateLocation(location);
                end
            end
        end
        
        
        function quarter = editSelectedLocationMetadata(quarter, projectPath, toQuarterPath, userName, dataFilename, eyeType, subjectType)
            location = quarter.getSelectedLocation();
            
            if ~isempty(location)
                existingLocationNumbers = quarter.getLocationNumbers();
                filenameSection = quarter.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                rejectSelectedLocation = true;
                locationCoordsWithLabels = quarter.generateLocationCoordsWithLabels(rejectSelectedLocation);
                
                location = location.editMetadata(projectPath, toQuarterPath, userName, dataFilename, existingLocationNumbers, locationCoordsWithLabels, eyeType, subjectType, quarter.quarterType);
            
                quarter = quarter.updateSelectedLocation(location);
            end
        end
        
        function quarter = editSelectedSessionMetadata(quarter, projectPath, toQuarterPath, userName, dataFilename)
            location = quarter.getSelectedLocation();
            
            if ~isempty(location)
                toLocationPath = makePath(toQuarterPath, location.dirName);
                filenameSection = quarter.generateFilenameSection();
                dataFilename = [dataFilename, filenameSection];
                
                location = location.editSelectedSessionMetadata(projectPath, toLocationPath, userName, dataFilename);
            
                quarter = quarter.updateSelectedLocation(location);
            end
        end
        
        function quarter = createNewLocation(quarter, projectPath, toPath, userName, subjectType, eyeType)
            suggestedLocationNumber = quarter.nextLocationNumber();
            existingLocationNumbers = quarter.getLocationNumbers();
            
            rejectSelectedLocation = false;
            locationCoordsWithLabels = quarter.generateLocationCoordsWithLabels(rejectSelectedLocation);
            
            toQuarterPath = makePath(toPath, quarter.dirName);
            quarterType = quarter.quarterType;
            
            importDir = '';
            
            location = Location(suggestedLocationNumber, existingLocationNumbers, locationCoordsWithLabels, toQuarterPath, projectPath, importDir, userName, subjectType, eyeType, quarterType, quarter.getFilename());
            
            if ~isempty(location)
                quarter = quarter.updateLocation(location);
            end
        end
                        
        function quarter = createNewSession(quarter, projectPath, toPath, userName, sessionType)
            location = quarter.getSelectedLocation();
            
            if ~isempty(location)
                toPath = makePath(toPath, quarter.dirName);
                
                locations = quarter.locations;
                
                location = location.createNewSession(projectPath, toPath, userName, sessionType, locations);
                
                quarter = quarter.updateLocation(location);
            end
        end
        
        function filenameSections = getFilenameSections(quarter, indices)
            if isempty(indices)
                filenameSections = quarter.generateFilenameSection();
            else
                index = indices(1);
                
                location = quarter.locations{index};
                
                if length(indices) == 1
                    indices = [];
                else
                    indices = indices(2:length(indices));
                end
                
                filenameSections = [quarter.generateFilenameSection(), location.getFilenameSections(indices)];
            end
        end        
        
        function quarter = applySelection(quarter, indices, isSelected, additionalFields)
            index = indices(1);
            
            len = length(indices);
            
            selectedObject = quarter.locations{index};
            
            if len > 1
                indices = indices(2:len);
                
                selectedObject = selectedObject.applySelection(indices, isSelected, additionalFields);
            else
                selectedObject.isSelected = isSelected;
                selectedObject.selectStructureFields = additionalFields;
            end           
            
            quarter.locations{index} = selectedObject;
        end
        
        % ************************************************
        % FUNCTIONS FOR SENSITIVITY AND SPECIFICITY MODULE
        % ************************************************
        
        function [dataSheetOutput, rowIndex, locationRowIndices] = placeSensitivityAndSpecificityData(quarter, dataSheetOutput, rowIndex)
            colHeaders = getExcelColHeaders();
            
            locations = quarter.locations;
            
            locationRowIndices = [];
            rowCounter = 1;
            
            for i=1:length(locations)
                location = locations{i};
                
                if ~isempty(location.isSelected)                        
                    % write data
                    dataSheetOutput{rowIndex, 1} = location.uuid;
                    dataSheetOutput{rowIndex, 2} = location.getFilename();
                        
                    if location.isSelected
                        microscopeSession = location.getMicroscopeSession();
                        rowIndexString = num2str(rowIndex);
                        
                        % add row index
                        locationRowIndices(rowCounter) = rowIndex;
                        rowCounter = rowCounter + 1;
                        
                        % write data
                        dataSheetOutput{rowIndex, 3} = ' '; % no AD positive value to give
                        dataSheetOutput{rowIndex, 4} = convertBoolToExcelBool(microscopeSession.fluoroSignature);
                        dataSheetOutput{rowIndex, 5} = convertBoolToExcelBool(microscopeSession.crossedSignature);
                        dataSheetOutput{rowIndex, 6} = ['=INT(AND(',    colHeaders{4},rowIndexString,',',       colHeaders{5},rowIndexString,'))'];
                        dataSheetOutput{rowIndex, 7} = ['=INT(AND(NOT(',colHeaders{4},rowIndexString,'),',      colHeaders{5},rowIndexString,'))'];
                        dataSheetOutput{rowIndex, 8} = ['=INT(AND(',    colHeaders{4},rowIndexString,',NOT(',   colHeaders{5},rowIndexString,')))'];
                        dataSheetOutput{rowIndex, 9} = ['=INT(AND(NOT(',colHeaders{4},rowIndexString,'),NOT(',  colHeaders{5},rowIndexString,')))'];
                    else
                        reason = location.selectStructureFields.exclusionReason;
                        
                        if isempty(reason)
                            reason = SensitivityAndSpecificityConstants.NO_REASON_TAG;
                        end
                        dataSheetOutput{rowIndex, 3} = [SensitivityAndSpecificityConstants.NOT_RUN_TAG, reason];
                    end
                        
                    % increment row index
                    rowIndex = rowIndex + 1;
                end
            end
        end
        
        
        % ******************************************
        % FUNCTIONS FOR POLARIZATION ANALYSIS MODULE
        % ******************************************
        
        function [hasValidSession, selectStructureForQuarter] = createSelectStructure(quarter, indices, sessionClass)
            locations = quarter.locations;
            
            selectStructureForQuarter = {};
            hasValidSession = false;
            
            for i=1:length(locations)
                newIndices = [indices, i];
                
                [newHasValidLocation, selectStructureForLocation] = locations{i}.createSelectStructure(newIndices, sessionClass);
                
                if newHasValidLocation
                    selectStructureForQuarter = [selectStructureForQuarter, selectStructureForLocation];
                    
                    hasValidSession = true;
                end
            end
            
            if hasValidSession
                switch sessionClass
                    case class(PolarizationAnalysisSession)
                        selectionEntry = PolarizationAnalysisModuleSelectionEntry(quarter.naviListboxLabel, indices);
                    case class(SubsectionStatisticsAnalysisSession)
                        selectionEntry = SubsectionStatisticsModuleSelectionEntry(quarter.naviListboxLabel, indices);
                    case class(SensitivityAndSpecificityAnalysisSession)
                        selectionEntry = SensitivityAndSpecificityModuleSelectionEntry(quarter.naviListboxLabel, indices, quarter);
                end
                
                selectStructureForQuarter = [{selectionEntry}, selectStructureForQuarter];
            else
                selectStructureForQuarter = {};
            end
            
        end
           
        
        function [isValidated, toPath] = validateSession(quarter, indices, toPath)
            location = quarter.locations{indices(1)};
            
            newIndices = indices(2:length(indices));
            toPath = makePath(toPath, quarter.dirName);
            
            [isValidated, toPath] = location.validateSession(newIndices, toPath);
        end
        
        
        function [quarter, selectStructure] = runPolarizationAnalysis(quarter, indices, defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName)
            location = quarter.locations{indices(1)};
            
            newIndices = indices(2:length(indices));
            toPath = makePath(toPath, quarter.dirName);
            fileName = [fileName, quarter.generateFilenameSection];
            
            [location, selectStructure] = location.runPolarizationAnalysis(newIndices, defaultSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName);
            
            quarter = quarter.updateLocation(location);
        end
        
        
        function session = getSelectedSession(quarter)
            location = quarter.getSelectedLocation();
            
            if isempty(location)            
                session = [];
            else
                session = location.getSelectedSession();
            end
        end
        
        
        
        % ******************************************
        % FUNCTIONS FOR SUBSECTION STATISTICS MODULE
        % ******************************************
        
        function [data, locationString, sessionString] = getPolarizationAnalysisData(quarter, subsectionSession, toIndices, toPath, fileName)
            location = quarter.locations{toIndices(1)};
            
            toPath = makePath(toPath, quarter.dirName);
            fileName = [fileName, quarter.generateFilenameSection];
            
            [data, locationString, sessionString] = location.getPolarizationAnalysisData(subsectionSession, toPath, fileName);
        end
        
        function mask = getFluoroMask(quarter, subsectionSession, toIndices, toPath, fileName)
            location = quarter.locations{toIndices(1)};
            
            toPath = makePath(toPath, quarter.dirName);
            fileName = [fileName, quarter.generateFilenameSection];
            
            mask = location.getFluoroMask(subsectionSession, toPath, fileName);
        end
        
    end
    
end

