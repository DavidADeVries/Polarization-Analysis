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
        
        function [cancel, session] = enterMetadata(session, importPath, userName)
            
            %Call to Microscope Session Metadata Entry GUI
            [cancel, magnification, pixelSizeMicrons, instrument, fluoroSignature, crossedSignature, visualSignature, sessionDate, sessionDoneBy, notes, rejected, rejectedReason] = MicroscopeSessionMetadataEntry(userName, importPath);
            
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
            end
        
        end
        
        function session = importSession(session, sessionProjectPath, locationImportPath, projectPath, dataFilename)            
            filenameSection = createFilenameSection(SessionNamingConventions.DATA_FILENAME_LABEL, num2str(session.sessionNumber));
            dataFilename = strcat(dataFilename, filenameSection);
            
            waitText = 'Importing session data. Please wait.';
            waitTitle = 'Importing Data';
            
            waitHandle = popupMessage(waitText, waitTitle);

            % get list of folders
            dirList = getAllFolders(locationImportPath);
            
            for i=1:length(dirList)
                dirName = dirList{i};
                
                if dirName == MicroscopeNamingConventions.FLUORO_DIR.import
                    filenameSection = createFilenameSection(MicroscopeNamingConventions.FLUORO_FILENAME_LABEL, '');
                    
                    namingConventions = MicroscopeNamingConventions.FLUORO_IMAGES;
                    
                    newDir = MicroscopeNamingConventions.FLUORO_DIR.project;
                    
                elseif dirName == MicroscopeNamingConventions.MM_DIR.import
                    filenameSection = createFilenameSection(MicroscopeNamingConventions.MM_FILENAME_LABEL, '');
                    
                    namingConventions = MicroscopeNamingConventions.getMMNamingConventions();
                    
                    newDir = MicroscopeNamingConventions.MM_DIR.project;
                    
                elseif dirName == MicroscopeNamingConventions.TR_DIR.import
                    filenameSection = createFilenameSection(MicroscopeNamingConventions.TR_FILENAME_LABEL, '');
                    
                    namingConventions = MicroscopeNamingConventions.TR_IMAGES;
                    
                    newDir = MicroscopeNamingConventions.TR_DIR.project;
                    
                elseif dirName == MicroscopeNamingConventions.LPO_DIR.import
                    filenameSection = createFilenameSection(MicroscopeNamingConventions.LPO_FILENAME_LABEL, '');
                    
                    namingConventions = MicroscopeNamingConventions.getLPONamingConventions();
                    
                    newDir = MicroscopeNamingConventions.LPO_DIR.project;
                    
                else
                    error('Invalid folder found in import directory');
                end
                
                % import the files
                filename = strcat(dataFilename, filenameSection);
                importPath = makePath(locationImportPath, dirName);
                
                importBmpNd2Files(sessionProjectPath, importPath, projectPath, filename, namingConventions, newDir);
            end      

            delete(waitHandle);     
            
        end
         
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = SessionNamingConventions.MICROSCOPE_DIR_SUBTITLE;
        end
               
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString] = getSessionMetadataString(session);
            
            magnificationString = ['Magnification: ', num2str(session.magnification)];
            pixelSizeMicronsString = ['Pixel Size (microns): ', num2str(session.pixelSizeMicrons)];
            instrumentString = ['Instrument: ', session.instrument];
            fluoroSignatureString = ['Fluoro Signature: ', booleanToString(session.fluoroSignature)];
            crossedSignatureString = ['Crossed Signature: ', booleanToString(session.crossedSignature)];
            visualSignatureString = ['Visual Signature: ', booleanToString(session.visualSignature)];
            
            
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, magnificationString, pixelSizeMicronsString, instrumentString, fluoroSignatureString, crossedSignatureString, visualSignatureString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            
        end
        
    end
    
end

function [] = importBmpNd2Files(sessionProjectPath, importPath, projectPath, dataFilename, namingConventions, newDir)



% create folder to hold data to be imported
createObjectDirectories(projectPath, sessionProjectPath, newDir);
projectToPath = makePath(sessionProjectPath, newDir);

% import files
filenames = getAllFiles(importPath);

bmpFilenames = getFilesByExtension(filenames, Constants.BMP_EXT);
nd2Filenames = getFilesByExtension(filenames, Constants.ND2_EXT);

numBmpFiles = length(bmpFilenames);
numNd2Files = length(nd2Filenames);

if numBmpFiles == numNd2Files && length(filenames) == numBmpFiles + numNd2Files    
    counts = zeros(length(namingConventions), 1); % this will keep track of the number of each type of image we get (easy check for duplicate)
    
    for i=1:numBmpFiles
        importFilenameBmp = bmpFilenames{i};
        
        [namingConvention, index] = getNamingConventionFromImportFilename(importFilenameBmp, namingConventions);
        
        filenameSection = createFilenameSection(namingConvention.project, '');
        finalFilename = strcat(dataFilename, filenameSection); %just needs extension
        
        if counts(index) ~= 0 % in case there are multiple images of the same series
            filenameSection = createFilenameSection('', num2str(counts(index)+1));
            finalFilename = strcat(finalFilename, filenameSection);
        end
        
        % import .bmp
        projectFilename = strcat(finalFilename, Constants.BMP_EXT);
        importFile(projectToPath, importPath, projectPath, importFilenameBmp, projectFilename);
        
        % import .nd2
        projectFilename = strcat(finalFilename, Constants.ND2_EXT);
        importFilenameNd2 = findSameFilenameWithDifferentExtension(nd2Filenames, importFilenameBmp);
        
        importFile(projectToPath, importPath, projectPath, importFilenameNd2, projectFilename);
        
        
        counts(index) = counts(index) + 1;
        
    end
else
    error('Missing bmp/nd2 files!');
end

end