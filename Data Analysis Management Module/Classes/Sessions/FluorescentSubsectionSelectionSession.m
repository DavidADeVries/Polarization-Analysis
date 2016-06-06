classdef FluorescentSubsectionSelectionSession < DataProcessingSession
    % FluorescentSubsectionSelectionSession
    % holds metadata for subsection selection session
    
    properties
        fluorescentTransformParams % [x,y,rot]
        cropCoords %MM and fluoro images both need to be cropped incase there are no invalid pixels
    end
    
    methods
        function session = FluorescentSubsectionSelectionSession(sessionNumber, dataProcessingSessionNumber, toLocationPath, projectPath, userName, transformParams, cropCoords)
            if nargin > 0
                % set session numbers
                session.sessionNumber = sessionNumber;
                session.dataProcessingSessionNumber = dataProcessingSessionNumber;
                
                % set navigation listbox label
                session.naviListboxLabel = session.generateListboxLabel();
                
                % set some fields
                session.fluorescentTransformParams = transformParams;
                session.cropCoords = cropCoords;
                
                % set metadata history
                session.metadataHistory = MetadataHistoryEntry(userName, LegacyRegistrationSession.empty);
                
                % make directory/metadata file
                session = session.createDirectories(toLocationPath, projectPath);
                
                % save metadata
                saveToBackup = true;
                session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, saveToBackup);
            else
                session = FluorescentSubsectionSelectionSession.empty;
            end
        end
        
               
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = FluorescentSubsectionSelectionNamingConventions.SESSION_DIR_SUBTITLE;
        end
        
        
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString, metadataHistoryStrings] = getSessionMetadataString(session);
            [dataProcessingSessionNumberString, linkedSessionsString] = session.getProcessingSessionMetadataString();
            
            fluoroTransformParamString = ['Fluorescent Transform Parameters: ', coordsToString(session.fluorescentTransformParams)];
            cropCoordsString = ['Crop Coords Parameters: ', coordsToString(session.cropCoords)];
                        
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, dataProcessingSessionNumberString, linkedSessionsString, fluoroTransformParamString, cropCoordsString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            metadataString = [metadataString, metadataHistoryStrings];
        end
        
        
        function [images, filenames] = getMMImages(session, toSessionPath)
            mmPath = makePath(toSessionPath, FluorescentSubsectionSelectionSession.MM_DIR.getSingularProjectTag());
            
            filenames = getAllFiles(mmPath);
            
            filenames = getFilesByExtension(filenames, Constants.BMP_EXT);
            
            images = {};
            
            for i=1:length(filenames)
                images{i} = openImage(makePath(mmPath, filenames{i}));
            end
        end
        
        function session = writeMMImages(session, toLocationPath, toLocationFilename, mmImages, mmFilenames)
            writePath = makePath(toLocationPath, session.dirName, FluorescentSubsectionNamingConventions.MM_DIR);
            
            mkdir(writePath);
            
            mmFilenameSection = createFilenameSection(FluorescentSubsectionSelectionNamingConvention);
            
            toSessionFilename = [toLocationPath, session.generateFilenameSection(), mmFilenameSection];
            
            mmNamingConventions = FluorescentSubsectionSelectionNamingConvention.getMMNamingConventions();
            
            for i=1:length(mmImages)
                image = mmImages{i};
                imageFilename = mmFilenames{i};
                
                filenameSections = extractFilenameSections(imageFilename);
                
                namingConvention = findMatchingNamingConvention(filenameSections, mmNamingConventions);
            end
        end
        
    end
    
end

