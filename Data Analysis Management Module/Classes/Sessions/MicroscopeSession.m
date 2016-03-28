classdef MicroscopeSession < DataCollectionSession
    %MicroscopeSession
    %holds metadata for images taken in the microscope
    
    properties
        % set by metadata entry
        magnification = 40;
        bwPixelSizeMicrons = 0.16; % size of pixel in microns (used for generating scale bars) - for monochrome camera
        rgbPixelSizeMicrons = 0.17; % size of pixel in microns (used for generating scale bars) - for colour camera
        instrument = 'Nikon Eclipse Ti-U';
        
        % these three describe how the deposit was found
        fluoroSignature = false; % T/F
        crossedSignature = false; % T/F
        visualSignature = false; % T/F
    end
    
    methods
        function session = MicroscopeSession(sessionNumber, dataCollectionSessionNumber, toLocationPath, projectPath, importDir, userName, lastSession)
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
                    
                    % save metadata
                    saveToBackup = true;
                    session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, saveToBackup);
                else
                    session = MicroscopeSession.empty;
                end
            end
        end
        
        function session = editMetadata(session, projectPath, toLocationPath, userName, dataFilename, ~, ~) %last two params are sessionChoices, sessionNumbers
            isEdit = true;
            
            [cancel,...
             magnification,...
             bwPixelSizeMicrons,...
             rgbPixelSizeMicrons,...
             instrument,...
             fluoroSignature,...
             crossedSignature,...
             visualSignature,...
             sessionDate,...
             sessionDoneBy,...
             notes,...
             rejected,...
             rejectedReason,...
             rejectedBy]...
             = MicroscopeSessionMetadataEntry(userName, '', isEdit, session);
            
            if ~cancel
                session = updateMetadataHistory(session, userName);
                
                oldDirName = session.dirName;
                oldFilenameSection = session.generateFilenameSection();  
                
                %Assigning values to Microscope Session Properties
                session.magnification = magnification;
                session.bwPixelSizeMicrons = bwPixelSizeMicrons;
                session.rgbPixelSizeMicrons = rgbPixelSizeMicrons;
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
            %Call to Microscope Session Metadata Entry GUI
            isEdit = false;
            
            [cancel,...
             magnification,...
             bwPixelSizeMicrons,...
             rgbPixelSizeMicrons,...
             instrument,...
             fluoroSignature,...
             crossedSignature,...
             visualSignature,...
             sessionDate,...
             sessionDoneBy,...
             notes,...
             rejected,...
             rejectedReason,...
             rejectedBy]...
             = MicroscopeSessionMetadataEntry(userName, importPath, isEdit, lastSession);
            
            if ~cancel
                %Assigning values to Microscope Session Properties
                session.magnification = magnification;
                session.bwPixelSizeMicrons = bwPixelSizeMicrons;
                session.rgbPixelSizeMicrons = rgbPixelSizeMicrons;
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
            dataFilename = strcat(dataFilename, session.generateFilenameSection());
            
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
                
                recurse = true; %go into subfolders
                [filenames, filenamePaths, filenameExtensions] = generateImportFilenames(importPath, recurse);
                                
                if isempty(namingConventions)
                    suggestedFilenameTags = {};
                else
                    suggestedFilenameTags = createSuggestedFilenameTags(filenames, namingConventions);
                end
                
                extensionStrings = createFilenameExtensionStrings(filenameExtensions);
                        
                [cancel, newDir, directoryTag, filenameTags] = SelectProjectTags(importPath, filenames, extensionStrings, suggestedDirectoryName, suggestedDirectoryTag, suggestedFilenameTags);
                
                if ~cancel                    
                    filenameSection = createFilenameSection(directoryTag, '');
                    
                    % import the files
                    finalFilename = strcat(dataFilename, filenameSection);
                    
                    importFiles(sessionProjectPath, projectPath, finalFilename, filenames, filenamePaths, filenameExtensions, filenameTags, newDir);
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
            bwPixelSizeMicronsString = ['Monochrome Pixel Size (microns): ', num2str(session.bwPixelSizeMicrons)];            
            rgbPixelSizeMicronsString = ['Colour Pixel Size (microns): ', num2str(session.rgbPixelSizeMicrons)];
            instrumentString = ['Instrument: ', session.instrument];
            fluoroSignatureString = ['Fluoro Signature: ', booleanToString(session.fluoroSignature)];
            crossedSignatureString = ['Crossed Signature: ', booleanToString(session.crossedSignature)];
            visualSignatureString = ['Visual Signature: ', booleanToString(session.visualSignature)];
            
            
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, dataCollectionSessionNumberString, magnificationString, bwPixelSizeMicronsString, rgbPixelSizeMicronsString, instrumentString, fluoroSignatureString, crossedSignatureString, visualSignatureString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            metadataString = [metadataString, metadataHistoryStrings];
        end
                
        
    end
    
end