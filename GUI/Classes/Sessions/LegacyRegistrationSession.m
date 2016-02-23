classdef LegacyRegistrationSession < DataProcessingSession
    % LegacyRegistrationSession
    % holds metadata for registration session for which the results were
    % directly imported into this application
    
    properties
        registrationType % registrationType
        registrationParams
    end
    
    methods
        function session = LegacyRegistrationSession(sessionNumber, dataProcessingSessionNumber, toLocationPath, projectPath, importDir, userName)
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
                session = LegacyRegistrationSession.empty;
            end              
        end
        
        function [cancel, session] = enterMetadata(session, importPath, userName)
            
            %Call to Legacy Registration Session Metadata Entry GUI
            [cancel, sessionDate, sessionDoneBy, notes, registrationType, registrationParams, rejected, rejectedReason, rejectedBy] = LegacyRegistrationSessionMetadataEntry(importPath, userName);
            
            if ~cancel
                %Assigning values to Legacy Registration Session Properties
                session.registrationType = registrationType;
                session.registrationParams = registrationParams;
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
                        
            
            suggestedDirectoryName = MicroscopeNamingConventions.MM_DIR.project;
            suggestedDirectoryTag = MicroscopeNamingConventions.MM_FILENAME_LABEL;
            
            namingConventions = MicroscopeNamingConventions.getMMNamingConventions();
                                                        
            extensionImportPaths = getExtensionImportPaths(importPath, filenameExtensions, 'Registration');
                
            [filenames, pathIndicesForFilenames] = getFilenamesForTagAssignment(extensionImportPaths);
            
            suggestedFilenameTags = createSuggestedFilenameTags(filenames, namingConventions);
            
            
            [cancel, newDir, directoryTag, filenameTags] = UnexpectedImportDirectory(importPath, filenames, suggestedDirectoryName, suggestedDirectoryTag, suggestedFilenameTags);
            
            
            if ~cancel
                filenameSection = createFilenameSection(directoryTag, '');
                
                % import the files
                dataFilename = strcat(dataFilename, filenameSection);
                
                importFiles(sessionProjectPath, extensionImportPaths, projectPath, dataFilename, filenames, pathIndicesForFilenames, filenameExtensions, filenameTags, newDir);
            end

            delete(waitHandle);     
            
        end
        
        
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = [SessionNamingConventions.LEGACY_REGISTRATION_DIR_SUBTITLE];
        end
        
               
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString] = getSessionMetadataString(session);
            
            registrationTypeString = ['Registration Type: ', session.registrationType.displayString];
            registrationParamsString = ['Registration Parameters: ' session.registrationParams];
            
            
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, registrationTypeString, registrationParamsString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            
        end        
        
        
    end
    
end

