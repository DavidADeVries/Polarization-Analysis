classdef Quarter
    % Quarter 
    % stores information about about a quarter of a retina
    
    properties
        dirName
        
        fixingDate
        fixingDoneBy
        
        stain
        slideMaterial
        
        quarterType % one of [S,T,I,N] (superior, temporal, inferior, nasal, unknown]
        quarterNumber %1, 2, 3, 4 (used for imaging)
        quarterArbitrary % False if which quarter is which is truly known, true otherwise (choosing S,T,I,N is arbitrary, but consistent)
        
        locations
        locationIndex = 0
        
        metadataHistory
        
        notes
    end
    
    methods
        function quarter = loadQuarter(quarter, toQuarterPath, quarterDir)
            quarterPath = makePath(toQuarterPath, quarterDir);
            
            % load metadata            
            vars = load(makePath(quarterPath, QuarterNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
            quarter = vars.metadata;
            
            % load dirName            
            quarter.dirName = quarterDir;
            
            % load locations            
            locationsDirs = getMetadataFolders(quarterPath, LocationNamingConventions.METADATA_FILENAME);
            
            numLocations = length(locationsDirs);
            
            quarter.locations = createEmptyCellArray(Location, numLocations);
                        
            for i=1:numLocations
                quarter.locations{i} = quarter.locations{i}.loadLocation(quarterPath, locationsDirs{i});
            end
            
            if ~isempty(quarter.locations)
                quarter.locationIndex = 1;
            end
        end
        
        function quarter = importQuarter(quarter, quarterProjectPath, quarterImportPath, projectPath, dataFilename, userName, subjectType, eyeType)
            dirList = getAllFolders(quarterImportPath);
            
            importLocationNumbers = getNumbersFromFolderNames(dirList);
            
            filenameSection = createFilenameSection(QuarterNamingConventions.DATA_FILENAME_LABEL, num2str(quarter.quarterNumber));
            dataFilename = strcat(dataFilename, filenameSection);
                
            for i=1:length(dirList)
                indices = findInArray(importLocationNumbers{i}, quarter.getLocationNumbers());
                
                locationImportPath = makePath(quarterImportPath, dirList{i});
                
                if isempty(indices) % new location
                    location = Location;
                    
                    location = location.enterMetadata(importLocationNumbers{i}, subjectType, eyeType, quarter.quarterType, locationImportPath);
                    
                    % make directory/metadata file
                    location = location.createDirectories(quarterProjectPath, projectPath);
                    
                    saveToBackup = true;
                    location.saveMetadata(makePath(quarterProjectPath, location.dirName), projectPath, saveToBackup);
                else % old location
                    location = quarter.getLocationByNumber(importLocationNumbers{i});
                end
                
                locationProjectPath = makePath(quarterProjectPath, location.dirName);
                
                location = location.importLocation(locationProjectPath, locationImportPath, projectPath, dataFilename, userName);
                
                quarter = quarter.updateLocation(location);
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
            locationNumbers = zeros(length(quarter.locations), 1); % want this to be an matrix, not cell array
            
            for i=1:length(quarter.locations)
                locationNumbers(i) = quarter.locations{i}.locationNumber;                
            end
        end
        
        function nextLocationNumber = getNextLocationNumber(quarter)
            lastLocationNumber = max(quarter.getLocationNumbers());
            nextLocationNumber = lastLocationNumber + 1;
        end
        
        function quarter = enterMetadata(quarter, suggestedQuarterNumber, importPath, userName)
              
            %Call to QuarterMetadataEntry GUI
            [stain, slideMaterial, quarterType, quarterArbitrary, quarterNumber, fixingDate, fixingDoneBy, notes] = QuarterMetadataEntry(suggestedQuarterNumber, importPath, userName);
            
            %Assigning values to Quarter Properties
            quarter.stain = stain;
            quarter.slideMaterial = slideMaterial;
            quarter.quarterType = quarterType;
            quarter.quarterArbitrary = quarterArbitrary;
            quarter.quarterNumber = quarterNumber;
            quarter.fixingDate = displayDate(fixingDate);
            quarter.fixingDoneBy = fixingDoneBy;
            quarter.notes = notes;
            
        end
        
        function quarter = createDirectories(quarter, toEyePath, projectPath)
            dirSubtitle = quarter.quarterType.displayString;
            
            quarterDirectory = createDirName(QuarterNamingConventions.DIR_PREFIX, num2str(quarter.quarterNumber), dirSubtitle);
            
            createObjectDirectories(projectPath, toEyePath, quarterDirectory);
                        
            quarter.dirName = quarterDirectory;
        end
        
        function [] = saveMetadata(quarter, toQuarterPath, projectPath, saveToBackup)
            saveObjectMetadata(quarter, projectPath, toQuarterPath, QuarterNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function quarter = wipeoutMetadataFields(quarter)
            quarter.dirName = '';
            quarter.locations = [];
        end
        
        function location = getSelectedLocation(quarter)
            location = [];
            
            if quarter.locationIndex ~= 0
                location = quarter.locations{quarter.locationIndex};
            end
        end
        
        function handles = updateNavigationListboxes(quarter, handles)
            numLocations = length(quarter.locations);
            
            locationOptions = cell(numLocations, 1);
            
            if numLocations == 0
                disableNavigationListboxes(handles, handles.locationSelect);
            else
                for i=1:numLocations
                    locationOptions{i} = quarter.locations{i}.dirName;
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
            
            fixingDateString = ['Fixing Date: ', quarter.fixingDate];
            fixingDoneByString = ['Fixing Done By: ', quarter.fixingDoneBy];
            stainString = ['Stain: ', quarter.stain];
            slideMaterialString = ['Slide Material: ', quarter.slideMaterial];
            quarterTypeString = ['Quarter Type: ', quarter.quarterType.displayString];
            quarterNumberString = ['Quarter number: ', num2str(quarter.quarterNumber)];
            quarterArbitraryString = ['Quarter Arbitrary: ', booleanToString(quarter.quarterArbitrary)];
            quarterNotesString = ['Notes: ', quarter.notes];
            
            metadataString = {'Quarter:', fixingDateString, fixingDoneByString, stainString, slideMaterialString, quarterTypeString, quarterNumberString, quarterArbitraryString, quarterNotesString};
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
    end
    
end

