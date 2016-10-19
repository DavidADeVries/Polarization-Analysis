classdef CSLOSession < DataCollectionSession
    %CSLOSession
    %holds metadata for images taken in a CSLO
    
    properties
        magnification
        pixelSizeMicrons % size of pixel in microns (used for generating scale bars)
        instrument = 'CSLO';
        confocalPinholeSizeMicrons = 200; %diameter of confocal pinhole in microns
        lightLevelMicroWatts %laser output level in microwatts
        fieldOfViewDegrees %field of view in degrees
        entrancePinholeSizeMicrons %diameter of entrance pinhole in microns
        
        % these three describe how the deposit was found
        fluoroSignature = false; % T/F
        crossedSignature = false; % T/F
        visualSignature = false; % T/F
    end
    
    methods
        
        function session = CSLOSession(sessionNumber, dataCollectionSessionNumber, toLocationPath, projectPath, importDir, userName, lastSession, toFilename)
            if nargin > 0
                [cancel, session] = session.enterMetadata(importDir, userName, lastSession);
                
                if ~cancel
                    % set session numbers
                    session.sessionNumber = sessionNumber;
                    session.dataCollectionSessionNumber = dataCollectionSessionNumber;
                    
                    % set navigation listbox label
                    session.naviListboxLabel = session.generateListboxLabel();
                    
                    % set metadata history
                    session.metadataHistory = MetadataHistoryEntry(userName, MicroscopeSession.empty);
                    
                    % make directory/metadata file
                    session = session.createDirectories(toLocationPath, projectPath);
                    
                    % set toPath
                    session.toPath = toLocationPath;
                    
                    % set toFilename
                    session.toFilename = toFilename;
                    
                    % set projectPath
                    session.projectPath = projectPath;
                    
                    % save metadata
                    saveToBackup = true;
                    session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, saveToBackup);
                else
                    session = CSLOSession.empty;
                end
            end
        end
        
        function session = editMetadata(session, projectPath, toLocationPath, userName, dataFilename, sessionChoices)
            isEdit = true;
            
            [cancel,...
             magnification,...
             pixelSizeMicrons,...
             instrument,...
             entrancePinholeSizeMicrons,...
             confocalPinholeSizeMicrons,...
             lightLevelMicroWatts,...
             fieldOfViewDegrees,...
             sessionDate,...
             sessionDoneBy,...
             fluoroSignature,...
             crossedSignature,...
             visualSignature,...
             rejected,...
             rejectedReason,...
             rejectedBy,...
             notes]...
             = CSLOSessionMetadataEntry(userName, '', isEdit, session);
            
            if ~cancel
                session = updateMetadataHistory(session, userName);
                
                oldDirName = session.dirName;
                oldFilenameSection = session.generateFilenameSection();
                
                %Assigning values to Legacy Registration Session Properties
                session.magnification = magnification;
                session.pixelSizeMicrons = pixelSizeMicrons;
                session.instrument = instrument;
                session.entrancePinholeSizeMicrons = entrancePinholeSizeMicrons;
                session.confocalPinholeSizeMicrons = confocalPinholeSizeMicrons;
                session.lightLevelMicroWatts = lightLevelMicroWatts;
                session.fieldOfViewDegrees = fieldOfViewDegrees;
                session.sessionDate = sessionDate;
                session.sessionDoneBy = sessionDoneBy;
                session.fluoroSignature = fluoroSignature;
                session.crossedSignature = crossedSignature;
                session.visualSignature = visualSignature;
                session.rejected = rejected;
                session.rejectedReason = rejectedReason;
                session.rejectedBy = rejectedBy;
                session.notes = notes; 
                
                session.linkedSessionNumbers = getSelectedSessionNumbers(sessionChoices, selectedChoices);
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                newDirName = session.generateDirName();
                newFilenameSection = session.generateFilenameSection();
                
                renameDirectory(toLocationPath, projectPath, oldDirName, newDirName, updateBackupFiles);
                renameFiles(toLocationPath, projectPath, dataFilename, oldFilenameSection, newFilenameSection, updateBackupFiles);
                
                session.dirName = newDirName;
                session.naviListboxLabel = session.generateListboxLabel();
                
                session = session.updateFileSelectionEntries(makePath(projectPath, toLocationPath)); %incase files renamed
                
                session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, updateBackupFiles);
            end
        end
        
        function [cancel, session] = enterMetadata(session, importPath, userName, lastSession)
            
            isEdit = false;
            %Call to CSLO Session Metadata Entry GUI
            [cancel,...
             magnification,...
             pixelSizeMicrons,...
             instrument,...
             entrancePinholeSizeMicrons,...
             confocalPinholeSizeMicrons,...
             lightLevelMicroWatts,...
             fieldOfViewDegrees,...
             sessionDate,...
             sessionDoneBy,...
             fluoroSignature,...
             crossedSignature,...
             visualSignature,...
             rejected,...
             rejectedReason,...
             rejectedBy,...
             notes]...
             = CSLOSessionMetadataEntry(userName, importPath, isEdit, lastSession);
            
            if ~cancel
                %Assigning values to CSLO Session Properties
                session.magnification = magnification;
                session.pixelSizeMicrons = pixelSizeMicrons;
                session.instrument = instrument;
                session.entrancePinholeSizeMicrons = entrancePinholeSizeMicrons;
                session.confocalPinholeSizeMicrons = confocalPinholeSizeMicrons;
                session.lightLevelMicroWatts = lightLevelMicroWatts;
                session.fieldOfViewDegrees = fieldOfViewDegrees;
                session.sessionDate = sessionDate;
                session.sessionDoneBy = sessionDoneBy;
                session.fluoroSignature = fluoroSignature;
                session.crossedSignature = crossedSignature;
                session.visualSignature = visualSignature;
                session.rejected = rejected;
                session.rejectedReason = rejectedReason;
                session.rejectedBy = rejectedBy;
                session.notes = notes; 
            end
            
        end
        
        function session = importSession(session, sessionProjectPath, importPath, projectPath, dataFilename)
            dataFilename = strcat(dataFilename, session.generateFilenameSection());
                        
            waitText = 'Importing session data. Please wait.';
            waitTitle = 'Importing Data';
            
            waitHandle = popupMessage(waitText, waitTitle);
            
            
            suggestedDirectoryName = MicroscopeNamingConventions.MM_DIR.getSingularProjectTag();
            suggestedDirectoryTag = MicroscopeNamingConventions.MM_FILENAME_LABEL;
            
            namingConventions = MicroscopeNamingConventions.getMMNamingConventions();
            
            recurse = false; %don't go into subfolders
            [filenames, filenamePaths, filenameExtensions] = generateImportFilenames(importPath, recurse);
            
            suggestedFilenameTags = createSuggestedFilenameTags(filenames, namingConventions);
            extensionStrings = createFilenameExtensionStrings(filenameExtensions);
                        
            [cancel, newDir, directoryTag, filenameTags] = SelectProjectTags(importPath, filenames, extensionStrings, suggestedDirectoryName, suggestedDirectoryTag, suggestedFilenameTags);
                        
            if ~cancel
                filenameSection = createFilenameSection(directoryTag, '');
                
                % import the files
                dataFilename = strcat(dataFilename, filenameSection);
                
                importFiles(sessionProjectPath, projectPath, dataFilename, filenames, filenamePaths, filenameExtensions, filenameTags, newDir);
            end
            
            delete(waitHandle);
            
        end
        
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = CSLONamingConventions.SESSION_DIR_SUBTITLE;
        end
        
        function bool = shouldCreateBackup(session)
            bool = true;
        end
        
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString] = getSessionMetadataString(session);
            
            magnificationString = ['Magnification: ' num2str(session.magnification)];
            pixelSizeMicronsString  = ['Pixel Size (microns): ', num2str(session.pixelSizeMicrons)];
            instrumentString = ['Instrument: ', session.instrument];
            fluoroSignatureString = ['Fluoro Signature: ', booleanToString(session.fluoroSignature)];
            crossedSignatureString = ['Crossed Signature: ', booleanToString(session.crossedSignature)];
            visualSignatureString = ['Visual Signature: ', booleanToString(session.visualSignature)];
            entrancePinholeSizeMicronsString = ['Entrance Pinhole Size (microns): ', num2str(session.entrancePinholeSizeMicrons)];
            confocalPinholeSizeMicronsString = ['Confocal Pinhole Size (microns): ', num2str(session.confocalPinholeSizeMicrons)];
            lightLevelMicroWattsString = ['Laser Power (microWatts): ', num2str(session.lightLevelMicroWatts)];
            fieldOfViewDegreesString = ['Field of View (degrees): ', num2str(session.fieldOfViewDegrees)];
            
            metadataString = [sessionDateString, sessionDoneByString, sessionNumberString, magnificationString, pixelSizeMicronsString, instrumentString, entrancePinholeSizeMicronsString, confocalPinholeSizeMicronsString, lightLevelMicroWattsString, fieldOfViewDegreesString, fluoroSignatureString, crossedSignatureString, visualSignatureString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString];
            
        end
        
        function preppedSession = prepForAutofill(session)
            preppedSession = CSLOSession;
            
            % these are the values to carry over
            preppedSession.sessionDate = session.sessionDate;
            preppedSession.sessionDoneBy = session.sessionDoneBy;
        end
        
        function [images, filenames] = getMMImages(session, toSessionPath)
            mmPath = makePath(toSessionPath, CSLORegistrationNamingConventions.MM_DIR.getSingularProjectTag());
            
            filenames = getAllFiles(mmPath);
            
            filenames = getFilesByExtension(filenames, Constants.BMP_EXT);
            
            images = {};
            
            for i=1:length(filenames)
                images{i} = openImage(makePath(mmPath, filenames{i}));
            end
        end
    end
    
end
