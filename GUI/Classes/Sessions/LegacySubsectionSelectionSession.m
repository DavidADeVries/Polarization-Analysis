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
            [cancel, sessionDate, sessionDoneBy, notes, croppingType, coords, rejected, rejectedReason, rejectedBy] = LegacySubsectionSelectionSessionMetadataEntry(userName, importPath);
            
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
            
            waitText = 'Importing session data. Please wait.';
            waitTitle = 'Importing Data';
            
            waitHandle = popupMessage(waitText, waitTitle);
                        
            % import the files
            filename = strcat(dataFilename, filenameSection);
            
            newDir = LegacySubsectionSelectionNamingConventions.MM_DIR;
            namingConventions = LegacyRegistrationNamingConventions.getMMNamingConventions();
            
            createObjectDirectories(projectPath, sessionProjectPath, newDir);
            
            fileExtensions = {Constants.BMP_EXT};
            
            importBmpFiles(sessionProjectPath, importPath, projectPath, filename, namingConventions, newDir, fileExtensions);

            delete(waitHandle);     
        end
        
         
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = [session.croppingType.displayString, ' ', SessionNamingConventions.LEGACY_SUBSECTION_SELECTION_DIR_SUBTITLE];
        end
        
               
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString] = getSessionMetadataString(session);
            
            croppingTypeString = ['Cropping Type: ', session.croppingType.displayString];
            coordsString = ['Cropping Coords [x,y,w,h]: ' coordsToString(session.coords)];
            
            
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, croppingTypeString, coordsString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            
        end        
        
    end
    
end

