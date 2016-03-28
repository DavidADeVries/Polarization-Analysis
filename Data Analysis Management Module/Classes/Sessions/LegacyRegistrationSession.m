classdef LegacyRegistrationSession < DataProcessingSession
    % LegacyRegistrationSession
    % holds metadata for registration session for which the results were
    % directly imported into this application
    
    properties
        registrationType = []; % registrationType
        registrationParams = '';
    end
    
    methods
        function session = LegacyRegistrationSession(sessionNumber, dataProcessingSessionNumber, toLocationPath, projectPath, importDir, userName, sessionChoices, lastSession)
            if nargin > 0
                [cancel, session] = session.enterMetadata(importDir, userName, sessionChoices, lastSession);
                
                if ~cancel
                    % set session numbers
                    session.sessionNumber = sessionNumber;
                    session.dataProcessingSessionNumber = dataProcessingSessionNumber;
                    
                    % set navigation listbox label
                    session.naviListboxLabel = session.generateListboxLabel();
                    
                    % set metadata history
                    session.metadataHistory = MetadataHistoryEntry(userName, LegacyRegistrationSession.empty);
                    
                    % make directory/metadata file
                    session = session.createDirectories(toLocationPath, projectPath);
                    
                    % save metadata
                    saveToBackup = true;
                    session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, saveToBackup);
                else
                    session = LegacyRegistrationSession.empty;
                end
            end
        end
        
        
        function session = editMetadata(session, projectPath, toLocationPath, userName, dataFilename, sessionChoices)
            isEdit = true;
            
            [cancel,...
                sessionDate,...
                sessionDoneBy,...
                notes,...
                registrationType,...
                registrationParams,...
                rejected,...
                rejectedReason,...
                rejectedBy,...
                selectedChoices]...
                = LegacyRegistrationSessionMetadataEntry('', userName, sessionChoices, isEdit, session);
            
            if ~cancel
                session = updateMetadataHistory(session, userName);
                
                oldDirName = session.dirName;
                oldFilenameSection = session.generateFilenameSection();
                
                %Assigning values to Legacy Registration Session Properties
                session.registrationType = registrationType;
                session.registrationParams = registrationParams;
                session.sessionDate = sessionDate;
                session.sessionDoneBy = sessionDoneBy;
                session.notes = notes;
                session.rejected = rejected;
                session.rejectedReason = rejectedReason;
                session.rejectedBy = rejectedBy;
                
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
        
        
        function [cancel, session] = enterMetadata(session, importPath, userName, sessionChoices, lastSession)
            isEdit = false;
            
            %Call to Legacy Registration Session Metadata Entry GUI
            [cancel,...
                sessionDate,...
                sessionDoneBy,...
                notes,...
                registrationType,...
                registrationParams,...
                rejected,...
                rejectedReason,...
                rejectedBy,...
                selectedChoices]...
                = LegacyRegistrationSessionMetadataEntry(importPath, userName, sessionChoices, isEdit, lastSession);
            
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
                
                session.linkedSessionNumbers = getSelectedSessionNumbers(sessionChoices, selectedChoices);
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
            dirSubtitle = [LegacyRegistrationNamingConventions.SESSION_DIR_SUBTITLE];
        end
        
        
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString, metadataHistoryStrings] = getSessionMetadataString(session);
            [dataProcessingSessionNumberString, linkedSessionsString] = session.getProcessingSessionMetadataString();
            
            registrationTypeString = ['Registration Type: ', displayType(session.registrationType)];
            registrationParamsString = ['Registration Parameters: ' session.registrationParams];
            
            
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, dataProcessingSessionNumberString, linkedSessionsString, registrationTypeString, registrationParamsString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            metadataString = [metadataString, metadataHistoryStrings];
        end
        
        
        function preppedSession = prepForAutofill(session)
            preppedSession = LegacyRegistrationSession;
            
            % these are the values to carry over
            preppedSession.sessionDate = session.sessionDate;
            preppedSession.sessionDoneBy = session.sessionDoneBy;
            preppedSession.registrationType = session.registrationType;
            preppedSession.linkedSessionNumbers = session.linkedSessionNumbers;
        end
        
    end
    
end

