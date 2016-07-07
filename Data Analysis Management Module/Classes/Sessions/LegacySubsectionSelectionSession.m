classdef LegacySubsectionSelectionSession < DataProcessingSession
    % LegacySubsectionSelectionSession
    % holds metadata for cropping session for which the results were
    % directly imported into this application
    
    properties
        croppingType = [];
        coords = []; % [xTopLeftCorner, yTopLeftCorner, width, height]
    end
    
    methods
        
        function session = LegacySubsectionSelectionSession(sessionNumber, dataProcessingSessionNumber, toLocationPath, projectPath, importDir, userName, sessionChoices, lastSession)
            if nargin > 0
                [cancel, session] = session.enterMetadata(importDir, userName, sessionChoices, lastSession);
                
                if ~cancel
                    % set session numbers
                    session.sessionNumber = sessionNumber;
                    session.dataProcessingSessionNumber = dataProcessingSessionNumber;
                    
                    % set navigation listbox label
                    session.naviListboxLabel = session.generateListboxLabel();
                    
                    % set metadata history
                    session.metadataHistory = MetadataHistoryEntry(userName, LegacySubsectionSelectionSession.empty);
                    
                    % make directory/metadata file
                    session = session.createDirectories(toLocationPath, projectPath);
                    
                    % set toPath
                    session.toPath = toLocationPath;
                    
                    % save metadata
                    saveToBackup = true;
                    session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, saveToBackup);
                else
                    session = LegacySubsectionSelectionSession.empty;
                end
            end
        end
        
        
        function session = editMetadata(session, projectPath, toLocationPath, userName, dataFilename, sessionChoices)
            isEdit = true;
            
            [cancel, sessionDate, sessionDoneBy, notes, croppingType, coords, rejected, rejectedReason, rejectedBy, selectedChoices] = LegacySubsectionSelectionSessionMetadataEntry('', userName, sessionChoices, isEdit, session);
            
            if ~cancel
                session = updateMetadataHistory(session, userName);
                
                oldDirName = session.dirName;
                oldFilenameSection = session.generateFilenameSection();  
                
                %Assigning values to Legacy Registration Session Properties
                session.croppingType = croppingType;
                session.coords = coords;
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
            
            %Call to Legacy Subsection Selection Session Metadata Entry GUI
            [cancel,...
             sessionDate,...
             sessionDoneBy,...
             notes,...
             croppingType,...
             coords,...
             rejected,...
             rejectedReason,...
             rejectedBy,...
             selectedChoices]...
             = LegacySubsectionSelectionSessionMetadataEntry(importPath, userName, sessionChoices, isEdit, lastSession);
            
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
            dirSubtitle = [LegacySubsectionSelectionNamingConventions.SESSION_DIR_SUBTITLE, ' ', session.croppingType.displayString];
        end
        
        
        function bool = shouldCreateBackup(session)
            bool = true;
        end
        
               
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString, metadataHistoryStrings] = getSessionMetadataString(session);            
            [dataProcessingSessionNumberString, linkedSessionsString] = session.getProcessingSessionMetadataString();
            
            croppingTypeString = ['Cropping Type: ', displayType(session.croppingType)];
            coordsString = ['Cropping Coords [x,y,w,h]: ' coordsToString(session.coords)];
            
            
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, dataProcessingSessionNumberString, linkedSessionsString, croppingTypeString, coordsString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            metadataString = [metadataString, metadataHistoryStrings];
        end
        
        
        function preppedSession = prepForAutofill(session)
            preppedSession = LegacySubsectionSelectionSession;
            
            % these are the values to carry over
            preppedSession.sessionDate = session.sessionDate;
            preppedSession.sessionDoneBy = session.sessionDoneBy;
            preppedSession.linkedSessionNumbers = session.linkedSessionNumbers;
        end     
        
    end
    
end

