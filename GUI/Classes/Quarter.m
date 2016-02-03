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
        
        function quarter = importQuarter(quarter, quarterProjectPath, quarterImportPath, projectPath, dataFilename)
            dirList = getAllFolders(quarterImportPath);
            
            importLocationNumbers = getNumbersFromFolderNames(dirList);
            
            filenameSection = createFilenameSection(QuarterNamingConventions.DATA_FILENAME_LABEL, num2str(quarter.quarterNumber));
            dataFilename = strcat(dataFilename, filenameSection);
                
            for i=1:length(dirList)
                indices = findInArray(importLocationNumbers{i}, quarter.getLocationNumbers());
                
                if isempty(indices) % new location
                    location = Location;
                    
                    location = location.enterMetadata(importLocationNumbers{i});
                    
                    % make directory/metadata file
                    location = location.createDirectories(quarterProjectPath, projectPath);
                    
                    saveToBackup = true;
                    location.saveMetadata(makePath(quarterProjectPath, location.dirName), projectPath, saveToBackup);
                else % old location
                    location = quarter.getLocationByNumber(importLocationNumbers{i});
                end
                
                locationProjectPath = makePath(quarterProjectPath, location.dirName);
                locationImportPath = makePath(quarterImportPath, dirList{i});
                
                location = location.importLocation(locationProjectPath, locationImportPath, projectPath, dataFilename);
                
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
        
        function quarter = enterMetadata(quarter, suggestedQuarterNumber)
                       
            %stain
            prompt = 'Enter Quarter stain:';
            title = 'Quarter Stain';
            
            response = inputdlg(prompt, title);
            quarter.stain = response{1};
            
            %slideMaterial
            prompt = 'Enter Quarter slide material:';
            title = 'Quarter Slide Material';
            
            response = inputdlg(prompt, title);
            quarter.slideMaterial = response{1};
            
            %quarterLabel % one of [S,T,I,N] (superior, temporal, inferior, nasal, unknown]
            prompt = 'Choose Quarter label:';
            selectionMode = 'single';
            title = 'Quarter Type';
            
            [choices, choiceStrings] = choicesFromEnum('QuarterTypes');
            
            [selection, ok] = listdlg('ListString', choiceStrings, 'SelectionMode', selectionMode, 'Name', title, 'PromptString', prompt);
            
            quarter.quarterType = choices(selection);
            
            
            %quarterArbitrary % False if which quarter is which is truly known, true otherwise (choosing S,T,I,N is arbitrary, but consistent)
            prompt = 'Do you know the true quarter location, or are did you arbitrarily decide which one would be which?';
            selectionMode = 'single';
            title = 'Quarter Type';
            choices = {'I know the true quarter labels','I arbitrarily decided the quarter labels'};
            
            [selection, ok] = listdlg('ListString', choices, 'SelectionMode', selectionMode, 'Name', title, 'PromptString', prompt);
            
            if selection == 1
                arbitrary = false;
            else
                arbitrary = true;
            end               
                
            quarter.quarterArbitrary = arbitrary;
                     
            
            %quarterNumber
            prompt = {'Enter Quarter Number:'};
            title = 'Quarter Number';
            numLines = 1;
            defaultAns = {num2str(suggestedQuarterNumber)};
            
            quarter.quarterNumber = str2double(inputdlg(prompt, title, numLines, defaultAns));
            
            %fixingDate
            %fixingDoneBy
            
            prompt = {'Enter Quarter fixing date (e.g. Jan 1, 2016):', 'Enter Quarter fixing done by:'};
            title = 'Quarter Fixing Information';
            numLines = 2;
            
            responses = inputdlg(prompt, title, numLines);
            
            quarter.fixingDate = responses{1};
            quarter.fixingDoneBy = responses{2};
            
            %notes
            
            prompt = 'Enter Quarter notes:';
            title = 'Quarter Notes';
            
            response = inputdlg(prompt, title);
            quarter.notes = response{1}; 
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
                
                quarter.getSelectedLocation().updateNavigationListboxes(handles);
            end
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
    end
    
end

