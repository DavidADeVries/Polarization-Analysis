classdef MicroscopeSession < DataCollectionSession
    %MicroscopeSession
    %holds metadata for images taken in the microscope
    
    properties
        magnification
        pixelSizeMicrons % size of pixel in microns (used for generating scale bars)
        instrument
        
        % these three describe how the deposit was found
        fluoroSignature % T/F
        crossedSignature % T/F
        visualSignature % T/F
    end
    
    methods
        function session = enterMetadata(session)
            
            %magnification
            prompt = {'Enter Magnification (decimal):'};
            title = 'Magnification';
            
            session.magnification = str2double(inputdlg(prompt, title));
            
            %pixelSizeMicrons
            prompt = {'Enter Pixel Size in microns (decimal):'};
            title = 'Pixel Size';
            
            session.pixelSizeMicrons = str2double(inputdlg(prompt, title));
            
            %instrument
            prompt = {'Enter instrument used:'};
            title = 'Instrument Used';
            
            response = inputdlg(prompt, title);
            session.instrument = response{1};
            
            %fluoroSignature
            session.fluoroSignature = true;
            
            %crossedSignature
            session.crossedSignature = false;
            
            %visualSignature % T/F
            session.visualSignature = false;
            
            %sessionDate
            %sessionDoneBy
            prompt = {'Enter imaginge date (e.g. Jan 1, 2016):', 'Enter imaging done by:'};
            title = 'Imaging Information';
            numLines = 2;
            
            responses = inputdlg(prompt, title, numLines);
            
            session.sessionDate = responses{1};
            session.sessionDoneBy = responses{2};
            
            %notes
            
            prompt = 'Enter Session notes:';
            title = 'Session Notes';
            
            response = inputdlg(prompt, title);
            session.notes = response{1}; 
            
            
            %rejected % T/F, will exclude data from being included in analysis
            %rejectedReason % reason that this data was rejected (suspected poor imaging, out of focus
            
            session.rejected = false;
            session.rejectedReason = 'N/A';
                   
        
        end
        
        function [] = importData(session, sessionProjectPath, locationImportPath, projectPath, localPath, dataFilename)
                       
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
                
                importBmpNd2Files(sessionProjectPath, importPath, projectPath, localPath, filename, namingConventions, newDir);
            end           
            
        end
         
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = SessionNamingConventions.MICROSCOPE_DIR_SUBTITLE;
        end
    end
    
end

function [] = importBmpNd2Files(sessionProjectPath, importPath, projectPath, localPath, dataFilename, namingConventions, newDir)

% create folder to hold data to be imported
createObjectDirectories(projectPath, localPath, sessionProjectPath, newDir);
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
        importFile(projectToPath, importPath, projectPath, localPath, importFilenameBmp, projectFilename);
        
        % import .nd2
        projectFilename = strcat(finalFilename, Constants.ND2_EXT);
        importFilenameNd2 = findSameFilenameWithDifferentExtension(nd2Filenames, importFilenameBmp);
        
        importFile(projectToPath, importPath, projectPath, localPath, importFilenameNd2, projectFilename);
        
        
        counts(index) = counts(index) + 1;
        
    end
else
    error('Missing bmp/nd2 files!');
end

end