classdef MicroscopeSession < DataCollectionSession
    %MicroscopeSession
    %holds metadata for images taken in the microscope
    
    properties
        % set by metadata entry
        magnification
        pixelSizeMicrons % size of pixel in microns (used for generating scale bars)
        instrument
        
        % these three describe how the deposit was found
        fluoroSignature % T/F
        crossedSignature % T/F
        visualSignature % T/F
    end
    
    methods
        function session = MicroscopeSession(sessionNumber, dataCollectionSessionNumber, toLocationPath, projectPath, importDir, userName)
            [cancel, session] = session.enterMetadata(importDir, userName);
            
            if ~cancel
                % set session numbers
                session.sessionNumber = sessionNumber;
                session.dataCollectionSessionNumber = dataCollectionSessionNumber;
                
                % set navigation listbox label
                session.naviListboxLabel = createNavigationListboxLabel(SessionNamingConventions.DATA_COLLECTION_NAVI_LISTBOX_PREFIX, session.dataCollectionSessionNumber, session.getDirSubtitle());
                
                % set metadata history
                session.metadataHistory = {MetadataHistoryEntry(userName)};
                
                % make directory/metadata file
                session = session.createDirectories(toLocationPath, projectPath);
                
                % save metadata
                saveToBackup = true;
                session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, saveToBackup);
            else
                session = MicroscopeSession.empty;
            end              
        end
        
        function session = editMetadata(session, projectPath, toLocationPath, userName, ~, ~) %last two params are sessionChoices, sessionNumbers
            [cancel, magnification, pixelSizeMicrons, instrument, fluoroSignature, crossedSignature, visualSignature, sessionDate, sessionDoneBy, notes, rejected, rejectedReason, rejectedBy] = MicroscopeSessionMetadataEntry(userName, '', session);
            
            if ~cancel
                %Assigning values to Microscope Session Properties
                session.magnification = magnification;
                session.pixelSizeMicrons = pixelSizeMicrons;
                session.instrument = instrument;
                session.fluoroSignature = fluoroSignature;
                session.crossedSignature = crossedSignature;
                session.visualSignature = visualSignature;
                session.sessionDate = sessionDate;
                session.sessionDoneBy = sessionDoneBy;
                session.notes = notes;
                session.rejected = rejected;
                session.rejectedReason = rejectedReason;
                session.rejectedBy = rejectedBy;
                
                session = session.updateMetadataHistory(userName);
                
                updateBackupFiles = updateBackupFilesQuestionGui();
                
                session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, updateBackupFiles);
            end
        end
        
        function [cancel, session] = enterMetadata(session, importPath, userName)
            
            %Call to Microscope Session Metadata Entry GUI
            [cancel, magnification, pixelSizeMicrons, instrument, fluoroSignature, crossedSignature, visualSignature, sessionDate, sessionDoneBy, notes, rejected, rejectedReason, rejectedBy] = MicroscopeSessionMetadataEntry(userName, importPath);
            
            if ~cancel
                %Assigning values to Microscope Session Properties
                session.magnification = magnification;
                session.pixelSizeMicrons = pixelSizeMicrons;
                session.instrument = instrument;
                session.fluoroSignature = fluoroSignature;
                session.crossedSignature = crossedSignature;
                session.visualSignature = visualSignature;
                session.sessionDate = sessionDate;
                session.sessionDoneBy = sessionDoneBy;
                session.notes = notes;
                session.rejected = rejected;
                session.rejectedReason = rejectedReason;
                session.rejectedBy = rejectedBy;
            end
        
        end
        
        function session = importSession(session, sessionProjectPath, locationImportPath, projectPath, dataFilename)            
            dataFilename = strcat(dataFilename, session.getFilenameSection());
            
            filenameExtensions = {Constants.BMP_EXT, Constants.ND2_EXT}; %expect .bmps and .nd2s
            
            waitText = 'Importing session data. Please wait.';
            waitTitle = 'Importing Data';
            
            waitHandle = popupMessage(waitText, waitTitle);

            % get list of folders
            dirList = getAllFolders(locationImportPath);
            
            for i=1:length(dirList)
                dirName = dirList{i};
                
                 if MicroscopeNamingConventions.FLUORO_DIR.importMatches(dirName)
                    
                    suggestedDirectoryName = MicroscopeNamingConventions.FLUORO_DIR.getSingularProjectTag();
                    suggestedDirectoryTag = MicroscopeNamingConventions.FLUORO_FILENAME_LABEL;
                    
                    namingConventions = MicroscopeNamingConventions.getFluoroNamingConventions();
                    
                elseif MicroscopeNamingConventions.MM_DIR.importMatches(dirName)
                    
                    suggestedDirectoryName = MicroscopeNamingConventions.MM_DIR.getSingularProjectTag();
                    suggestedDirectoryTag = MicroscopeNamingConventions.MM_FILENAME_LABEL;
                    
                    namingConventions = MicroscopeNamingConventions.getMMNamingConventions();
                    
                elseif MicroscopeNamingConventions.TR_DIR.importMatches(dirName)
                    
                    suggestedDirectoryName = MicroscopeNamingConventions.TR_DIR.getSingularProjectTag();
                    suggestedDirectoryTag = MicroscopeNamingConventions.TR_FILENAME_LABEL;
                    
                    namingConventions = MicroscopeNamingConventions.getTRNamingConventions();
                    
                elseif MicroscopeNamingConventions.LPO_DIR.importMatches(dirName)
                    
                    suggestedDirectoryName = MicroscopeNamingConventions.LPO_DIR.getSingularProjectTag();
                    suggestedDirectoryTag = MicroscopeNamingConventions.LPO_FILENAME_LABEL;
                    
                    namingConventions = MicroscopeNamingConventions.getLPONamingConventions();
                    
                else % the folder name did not match one the expected                    
                    suggestedDirectoryName = dirName;
                    suggestedDirectoryTag = '';
                    
                    namingConventions = NamingConvention.empty;
                end
                
                importPath = makePath(locationImportPath, dirName);
                                    
                extensionImportPaths = getExtensionImportPaths(importPath, filenameExtensions, dirName);
                
                [filenames, pathIndicesForFilenames] = getFilenamesForTagAssignment(extensionImportPaths);
                
                if isempty(namingConventions)
                    suggestedFilenameTags = {};
                else
                    suggestedFilenameTags = createSuggestedFilenameTags(filenames, namingConventions);
                end
                
                [cancel, newDir, directoryTag, filenameTags] = SelectProjectTags(importPath, filenames, suggestedDirectoryName, suggestedDirectoryTag, suggestedFilenameTags);
                
                if ~cancel                    
                    filenameSection = createFilenameSection(directoryTag, '');
                    
                    % import the files
                    finalFilename = strcat(dataFilename, filenameSection);
                    
                    importFiles(sessionProjectPath, extensionImportPaths, projectPath, finalFilename, filenames, pathIndicesForFilenames, filenameExtensions, filenameTags, newDir);
                end                
               
            end      

            delete(waitHandle);     
            
        end
         
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = MicroscopeNamingConventions.SESSION_DIR_SUBTITLE;
        end
               
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString, metadataHistoryStrings] = session.getSessionMetadataString();
            [dataCollectionSessionNumberString] = session.getCollectionSessionMetadataString();
            
            magnificationString = ['Magnification: ', num2str(session.magnification)];
            pixelSizeMicronsString = ['Pixel Size (microns): ', num2str(session.pixelSizeMicrons)];
            instrumentString = ['Instrument: ', session.instrument];
            fluoroSignatureString = ['Fluoro Signature: ', booleanToString(session.fluoroSignature)];
            crossedSignatureString = ['Crossed Signature: ', booleanToString(session.crossedSignature)];
            visualSignatureString = ['Visual Signature: ', booleanToString(session.visualSignature)];
            
            
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, dataCollectionSessionNumberString, magnificationString, pixelSizeMicronsString, instrumentString, fluoroSignatureString, crossedSignatureString, visualSignatureString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            metadataString = [metadataString, metadataHistoryStrings];
        end
        
    end
    
end