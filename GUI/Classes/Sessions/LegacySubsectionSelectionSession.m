classdef LegacySubsectionSelectionSession < DataProcessingSession
    % LegacySubsectionSelectionSession
    % holds metadata for cropping session for which the results were
    % directly imported into this application
    
    properties
        croppingType
        coords % [xTopLeftCorner, yTopLeftCorner, width, height]
    end
    
    methods
        
        function session = LegacySubsectionSelectionSession(sessionNumber, dataProcessingSessionNumber, toLocationPath, projectPath, importDir, userName)
            [cancel, session] = session.enterMetadata(importDir, userName);
            
            if ~cancel
                % set session numbers
                session.sessionNumber = sessionNumber;
                session.dataProcessingSessionNumber = dataProcessingSessionNumber;
                
                % set navigation listbox label
                session.naviListboxLabel = createNavigationListboxLabel(SessionNamingConventions.DATA_PROCESSING_NAVI_LISTBOX_PREFIX, session.dataProcessingSessionNumber, session.getDirSubtitle());
                
                % set metadata history
                session.metadataHistory = {MetadataHistoryEntry(userName)};
                
                % make directory/metadata file
                session = session.createDirectories(toLocationPath, projectPath);
                
                % save metadata
                saveToBackup = true;
                session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, saveToBackup);
            else
                session = LegacySubsectionSelectionSession.empty;
            end              
        end
        
        
        function [cancel, session] = enterMetadata(session, importPath, userName)
            
            %Call to Legacy Subsection Selection Session Metadata Entry GUI
            [cancel, sessionDate, sessionDoneBy, notes, croppingType, coords, rejected, rejectedReason, rejectedBy] = LegacySubsectionSelectionSessionMetadataEntry(importPath, userName);
            
            if ~cancel
                %Assigning values to Legacy Subsection Selection Session Properties
                session.croppingType = croppingType;
                session.coords = coords;
                session.sessionDate = sessionDate;
                session.sessionDoneBy = sessionDoneBy;
                session.notes = notes;
                session.rejected = rejected;
                session.rejectedReason = rejectedReason;
                session.rejectedBy = rejectedBy;
            end
        
        end
        
        
        function session = importSession(session, sessionProjectPath, importPath, projectPath, dataFilename) 
            
            filenameSection = createFilenameSection(SessionNamingConventions.DATA_FILENAME_LABEL, num2str(session.sessionNumber));
            dataFilename = strcat(dataFilename, filenameSection);
            
            filenameExtensions = {Constants.BMP_EXT};
            
            waitText = 'Importing session data. Please wait.';
            waitTitle = 'Importing Data';
            
            waitHandle = popupMessage(waitText, waitTitle);
                        
            
            suggestedDirectoryName = MicroscopeNamingConventions.MM_DIR.getSingularProjectTag();
            suggestedDirectoryTag = MicroscopeNamingConventions.MM_FILENAME_LABEL;
            
            namingConventions = MicroscopeNamingConventions.getMMNamingConventions();
                                                        
            extensionImportPaths = getExtensionImportPaths(importPath, filenameExtensions, 'Subsection Selection');
                
            [filenames, pathIndicesForFilenames] = getFilenamesForTagAssignment(extensionImportPaths);
            
            suggestedFilenameTags = createSuggestedFilenameTags(filenames, namingConventions);
            
            
            [cancel, newDir, directoryTag, filenameTags] = SelectProjectTags(importPath, filenames, suggestedDirectoryName, suggestedDirectoryTag, suggestedFilenameTags);
            
            
            if ~cancel
                filenameSection = createFilenameSection(directoryTag, '');
                
                % import the files
                dataFilename = strcat(dataFilename, filenameSection);
                
                importFiles(sessionProjectPath, extensionImportPaths, projectPath, dataFilename, filenames, pathIndicesForFilenames, filenameExtensions, filenameTags, newDir);
            end

            delete(waitHandle);    
              
        end
        
         
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = [LegacySubsectionSelectionNamingConventions.SESSION_DIR_SUBTITLE, ' ', session.croppingType.displayString];
        end
        
               
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString] = getSessionMetadataString(session);
            
            croppingTypeString = ['Cropping Type: ', session.croppingType.displayString];
            coordsString = ['Cropping Coords [x,y,w,h]: ' coordsToString(session.coords)];
            
            
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, croppingTypeString, coordsString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            
        end        
        
    end
    
end

