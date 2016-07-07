classdef BrainSection < FixedSample
    %BrainSection
    
    properties
        sectionAnatomy = ''; %the anatomy of where the brain section is from
        brainSectionNumber
    end
    
    methods
        
        function section = BrainSection(sampleNumber, existingSampleNumbers, brainSectionNumber, existingBrainSectionNumbers, toSubjectPath, projectPath, importPath, userName)
            if nargin > 0
                [cancel, section] = section.enterMetadata(sampleNumber, existingSampleNumbers, brainSectionNumber, existingBrainSectionNumbers, importPath, userName);
                
                if ~cancel
                    % set UUID
                    section.uuid = generateUUID();
                    
                    % set navigation listbox label
                    section.naviListboxLabel = section.generateListboxLabel();
                    
                    % make directory/metadata file
                    section = section.createDirectories(toSubjectPath, projectPath);
                    
                    % set metadata history
                    section.metadataHistory = MetadataHistoryEntry(userName, BrainSection.empty);
                    
                    % set toPath
                    section.toPath = toSubjectPath;
                    
                    % save metadata
                    saveToBackup = true;
                    section.saveMetadata(makePath(toSubjectPath, section.dirName), projectPath, saveToBackup);
                else
                    section = BrainSection.empty;
                end
            end
        end
        
        function [cancel, section] = enterMetadata(section, suggestedSampleNumber, existingSampleNumbers, suggestedBrainSectionNumber, existingBrainSectionNumbers, importPath, userName)
            isEdit = false;
            
            %Call to BrainSectionMetadataEntry GUI
            [...
                cancel,...
                sampleNumber,...
                brainSectionNumber,...
                source,...
                timeOfRemoval,...
                timeOfProcessing,...
                dateReceived,...
                storageLocation,...
                anatomy,...
                initFixative,...
                initPercent,...
                initTime,...
                secondFixative,...
                secondPercent,...
                secondTime,...
                notes]...
                = BrainSectionMetadataEntry(suggestedSampleNumber, existingSampleNumbers, suggestedBrainSectionNumber, existingBrainSectionNumbers, userName, importPath, isEdit);
            
            if ~cancel
                %Assigning values to Brain Section Properties
                section.sampleNumber = sampleNumber;
                section.brainSectionNumber = brainSectionNumber;
                section.source = source;
                section.timeOfRemoval = timeOfRemoval;
                section.timeOfProcessing = timeOfProcessing;
                section.dateReceived = dateReceived;
                section.storageLocation = storageLocation;
                section.sectionAnatomy = anatomy;
                section.initialFixative = initFixative;
                section.initialFixativePercent = initPercent;
                section.initialFixingTime = initTime;
                section.secondaryFixative = secondFixative;
                section.secondaryFixativePercent = secondPercent;
                section.secondaryFixingTime = secondTime;
                section.notes = notes;
            end
        end
        
        function section = editMetadata(section, projectPath, toSubjectPath, userName, dataFilename, existingSampleNumbers, existingBrainSectionNumbers)
            isEdit = true;
            importPath = '';
            
            [...
                cancel,...
                sampleNumber,...
                brainSectionNumber,...
                source,...
                timeOfRemoval,...
                timeOfProcessing,...
                dateReceived,...
                storageLocation,...
                anatomy,...
                initFixative,...
                initPercent,...
                initTime,...
                secondFixative,...
                secondPercent,...
                secondTime,...
                notes]...
                = BrainSectionMetadataEntry([], existingSampleNumbers, [], existingBrainSectionNumbers, userName, importPath, isEdit, section);
            
            if ~cancel
                section = updateMetadataHistory(section, userName);
                
                oldDirName = section.dirName;
                oldFilenameSection = section.generateFilenameSection();
                
                %Assigning values to Brain Section Properties
                section.sampleNumber = sampleNumber;
                section.brainSectionNumber = brainSectionNumber;
                section.source = source;
                section.timeOfRemoval = timeOfRemoval;
                section.timeOfProcessing = timeOfProcessing;
                section.dateReceived = dateReceived;
                section.storageLocation = storageLocation;
                section.sectionAnatomy = anatomy;
                section.initialFixative = initFixative;
                section.initialFixativePercent = initPercent;
                section.initialFixingTime = initTime;
                section.secondaryFixative = secondFixative;
                section.secondaryFixativePercent = secondPercent;
                section.secondaryFixingTime = secondTime;
                section.notes = notes;
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                newDirName = section.generateDirName();
                newFilenameSection = section.generateFilenameSection();
                
                renameDirectory(toSubjectPath, projectPath, oldDirName, newDirName, updateBackupFiles);
                renameFiles(toSubjectPath, projectPath, dataFilename, oldFilenameSection, newFilenameSection, updateBackupFiles);
                
                section.dirName = newDirName;
                section.naviListboxLabel = section.generateListboxLabel();
                
                %section = section.updateFileSelectionEntries(makePath(projectPath, toSubjectPath)); %incase files renamed - NOT NEEDED AT THIS TIME
                
                section.saveMetadata(makePath(toSubjectPath, section.dirName), projectPath, updateBackupFiles);
            end
        end
        
        function dirName = generateDirName(section)
            dirSubtitle = section.sectionAnatomy;
            
            dirName = createDirName(BrainSectionNamingConventions.DIR_PREFIX, section.brainSectionNumber, dirSubtitle, BrainSectionNamingConventions.DIR_NUM_DIGITS);
        end
        
        
        function label = generateListboxLabel(section)
            subtitle = section.sectionAnatomy;
            
            label = createNavigationListboxLabel(BrainSectionNamingConventions.NAVI_LISTBOX_PREFIX, section.brainSectionNumber, subtitle);
        end
        
        
        function section = generateFilenameSection(section)
            section = createFilenameSection(BrainSectionNamingConventions.DATA_FILENAME_LABEL, num2str(section.brainSectionNumber));
        end
        
        function section = loadObject(section, sectionPath)
        end
        
        function subSampleNumber = getSubSampleNumber(section)
            subSampleNumber = section.brainSectionNumber;
        end
        
        function section = wipeoutMetadataFields(section)
            section.dirName = '';
            section.toPath = '';
        end
        
        function metadataString = getMetadataString(section)
            
            [sampleNumberString, notesString] = section.getSampleMetadataString();
            [sourceString, timeOfRemovalString, timeOfProcessingString, dateReceivedString, storageLocationString] = section.getTissueSampleMetadataString();
            [initFixativeString, initFixPercentString, initFixTimeString, secondFixativeString, secondFixPercentString, secondFixTimeString] = section.getFixedSampleMetadataString();
            
            brainSectionNumberString = ['Brain Section Number: ', num2str(section.brainSectionNumber)];
            sectionAnatomyString = ['Section Anatomy: ', section.sectionAnatomy];
            metadataHistoryStrings = generateMetadataHistoryStrings(section.metadataHistory);
            
            
            metadataString = ...
                {'Brain Section:',...
                sampleNumberString,...
                brainSectionNumberString,...
                sectionAnatomyString,...
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
                notesString};
            metadataString = [metadataString, metadataHistoryStrings];
            
        end
        
                
        function handles = updateMetadataFields(section, handles, sectionMetadataString)
            
            metadataString = sectionMetadataString;
            
            disableMetadataFields(handles, handles.locationMetadata);
            
            set(handles.sampleMetadata, 'String', metadataString);
        end
        
        
        function section = updateSubSampleIndex(section, index)
        end
        
        function handles = updateNavigationListboxes(section, handles)
        	disableNavigationListboxes(handles, handles.subSampleSelect);
        end
        
        function section = createNewQuarter(section, projectPath, toPath, userName)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function section = editSelectedQuarterMetadata(section, projectPath, toEyePath, userName, dataFilename)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function section = createNewLocation(section, projectPath, toPath, userName, subjectType)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function section = editSelectedLocationMetadata(section, projectPath, toSamplePath, userName, dataFilename, subjectType)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function section = editSelectedSessionMetadata(section, projectPath, toSamplePath, userName, dataFilename)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function section = createNewSession(section, projectPath, toPath, userName, sessionType)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function location = getSelectedLocation(sample)
            location = [];
        end
        
        function session = getSelectedSession(sample)
            session = [];
        end
        
        function [data, locationString, sessionString] = getPolarizationAnalysisData(sample, subsectionSession, toIndices, toPath, fileName)
            data = [];
            locationString = '';
            sessionString = '';
        end
        
        % ******************************************
        % FUNCTIONS FOR POLARIZATION ANALYSIS MODULE
        % ******************************************
        
        function [hasValidSession, selectStructureForSample] = createSelectStructure(sample, indices, sessionClass)
            hasValidSession = false;
            selectStructureForSample = {};
        end
        
    end
    
end

