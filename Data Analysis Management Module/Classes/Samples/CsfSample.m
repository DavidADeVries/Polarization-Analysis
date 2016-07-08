classdef CsfSample < FrozenSample
    %CsfSample
    
    properties
        amountMl = []; % numeric in millilitres
        csfSampleNumber
    end
    
    methods
        
        function sample = CsfSample(sampleNumber, existingSampleNumbers, csfSampleNumber, existingCsfSampleNumbers, toSubjectPath, projectPath, importPath, userName)
            if nargin > 0
                [cancel, sample] = sample.enterMetadata(sampleNumber, existingSampleNumbers, csfSampleNumber, existingCsfSampleNumbers, importPath, userName);
                
                if ~cancel
                    % set UUID
                    sample.uuid = generateUUID();
                    
                    % set navigation listbox label
                    sample.naviListboxLabel = sample.generateListboxLabel();
                    
                    % make directory/metadata file
                    sample = sample.createDirectories(toSubjectPath, projectPath);
                    
                    % set metadata history
                    sample.metadataHistory = MetadataHistoryEntry(userName, CsfSample.empty);
                    
                    % set toPath
                    sample.toPath = toSubjectPath;
                    
                    % save metadata
                    saveToBackup = true;
                    sample.saveMetadata(makePath(toSubjectPath, sample.dirName), projectPath, saveToBackup);
                else
                    sample = CsfSample.empty;
                end
            end
        end
        
        function [cancel, sample] = enterMetadata(sample, suggestedSampleNumber, existingSampleNumbers, suggestedCsfSampleNumber, existingCsfSampleNumbers, importPath, userName)
            isEdit = false;
            
            %Call to CsfSampleMetadataEntry GUI
            [...
                cancel,...
                amountMl,...
                csfSampleNumber,...
                sampleNumber,...
                storageTemp,...
                storageLocation,...
                source,...
                timeOfRemoval,...
                timeOfProcessing,...
                dateReceived,...
                notes]...
                = CsfSampleMetadataEntry(suggestedSampleNumber, existingSampleNumbers, suggestedCsfSampleNumber, existingCsfSampleNumbers, userName, importPath, isEdit);
            
            if ~cancel
                %Assigning values to Csf Sample Properties
                sample.amountMl = amountMl;
                sample.csfSampleNumber = csfSampleNumber;
                sample.sampleNumber = sampleNumber;
                sample.storageTemp = storageTemp;
                sample.storageLocation = storageLocation;
                sample.source = source;
                sample.timeOfRemoval = timeOfRemoval;
                sample.timeOfProcessing = timeOfProcessing;
                sample.dateReceived = dateReceived;
                sample.notes = notes;
            end
        end
        
        function sample = editMetadata(sample, projectPath, toSubjectPath, userName, dataFilename, existingSampleNumbers, existingCsfSampleNumbers)
            isEdit = true;
            importPath = '';
            
            [...
                cancel,...
                amountMl,...
                csfSampleNumber,...
                sampleNumber,...
                storageTemp,...
                storageLocation,...
                source,...
                timeOfRemoval,...
                timeOfProcessing,...
                dateReceived,...
                notes]...
                = CsfSampleMetadataEntry([], existingSampleNumbers, [], existingCsfSampleNumbers, userName, importPath, isEdit, sample);
            
            if ~cancel
                sample = updateMetadataHistory(sample, userName);
                
                oldDirName = sample.dirName;
                oldFilenameSection = sample.generateFilenameSection();
                
                %Assigning values to Csf Sample Properties
                sample.amountMl = amountMl;
                sample.csfSampleNumber = csfSampleNumber;
                sample.sampleNumber = sampleNumber;
                sample.storageTemp = storageTemp;
                sample.storageLocation = storageLocation;
                sample.source = source;
                sample.timeOfRemoval = timeOfRemoval;
                sample.timeOfProcessing = timeOfProcessing;
                sample.dateReceived = dateReceived;
                sample.notes = notes;
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                newDirName = sample.generateDirName();
                newFilenameSection = sample.generateFilenameSection();
                
                renameDirectory(toSubjectPath, projectPath, oldDirName, newDirName, updateBackupFiles);
                renameFiles(toSubjectPath, projectPath, dataFilename, oldFilenameSection, newFilenameSection, updateBackupFiles);
                
                sample.dirName = newDirName;
                sample.naviListboxLabel = sample.generateListboxLabel();
                
                %section = section.updateFileSelectionEntries(makePath(projectPath, toSubjectPath)); %incase files renamed - NOT NEEDED AT THIS TIME
                
                sample.saveMetadata(makePath(toSubjectPath, sample.dirName), projectPath, updateBackupFiles);
            end
        end
        
        function dirName = generateDirName(sample)
            dirSubtitle = ''; % No subtitle for CSF sample
            
            dirName = createDirName(CsfSampleNamingConventions.DIR_PREFIX, sample.csfSampleNumber, dirSubtitle, CsfSampleNamingConventions.DIR_NUM_DIGITS);
        end
        
        function label = generateListboxLabel(sample)
            subtitle = ''; % No subtitle for CSF sample
            
            label = createNavigationListboxLabel(CsfSampleNamingConventions.NAVI_LISTBOX_PREFIX, sample.csfSampleNumber, subtitle);
        end
        
        function sample = generateFilenameSection(sample)
            sample = createFilenameSection(CsfSampleNamingConventions.DATA_FILENAME_LABEL, num2str(sample.csfSampleNumber));
        end
        
        function sample = loadObject(sample, samplePath)
        end
        
        function subSampleNumber = getSubSampleNumber(sample)
            subSampleNumber = sample.csfSampleNumber;
        end
        
        function sample = wipeoutMetadataFields(sample)
            sample.dirName = '';
            sample.toPath = '';
        end
        
        function metadataString = getMetadataString(sample)
            
            [sampleNumberString, notesString] = sample.getSampleMetadataString();
            [sourceString, timeOfRemovalString, timeOfProcessingString, dateReceivedString, storageLocationString] = sample.getTissueSampleMetadataString();
            [storageTempString] = sample.getFrozenSampleMetadataString();
            
            amountMlString = ['Sample Amount (mL): ', num2str(sample.amountMl)];
            csfSampleNumberString = ['CSF Sample Number: ', num2str(sample.csfSampleNumber)];
            metadataHistoryStrings = generateMetadataHistoryStrings(sample.metadataHistory);
            
            
            metadataString = ...
                ['CSF Sample:',...
                sampleNumberString,...
                csfSampleNumberString,...
                amountMlString,...
                sourceString,...
                timeOfRemovalString,...
                timeOfProcessingString,...
                dateReceivedString,...
                storageLocationString,...
                storageTempString,...
                notesString];
            metadataString = [metadataString, metadataHistoryStrings];
            
        end
        
        function handles = updateMetadataFields(sample, handles, sampleMetadataString)
            
            metadataString = sampleMetadataString;
            
            disableMetadataFields(handles, handles.locationMetadata);
            
            set(handles.sampleMetadata, 'String', metadataString);
        end
        
        function sample = updateSubSampleIndex(sample, index)
        end
        
        function handles = updateNavigationListboxes(sample, handles)
            disableNavigationListboxes(handles, handles.subSampleSelect);
        end
        
        function sample = createNewQuarter(sample, projectPath, toPath, userName)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function sample = editSelectedQuarterMetadata(sample, projectPath, toEyePath, userName, dataFilename)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function sample = createNewLocation(sample, projectPath, toPath, userName, subjectType)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function sample = editSelectedLocationMetadata(sample, projectPath, toSamplePath, userName, dataFilename, subjectType)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function sample = editSelectedSessionMetadata(sample, projectPath, toSamplePath, userName, dataFilename)
            % DO NOTHING, NO QUARTERS FOR BRAIN SECTION
        end
        
        function sample = createNewSession(sample, projectPath, toPath, userName, sessionType)
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

