% This is a reorganzation of the MM computation function
% Author: David DeVries (ddv993@gmail.com)
% Date:   April 12, 2016
%
% Input: filename that leads to 16 images, 1 for each of 16 configurations
% of the polarimetry imaging setup
%
% Output: Two Mueller Matrix images of dimensions N x M x 4 x 4, where N is
% the height of the images, M is the width of the images, and the 4 x 4 is
% your Mueller Matrix for each pixel in the image. 'MM_pixelwise_norm' is
% normalized such that each pixel's MM is divided out by m00. This leads to
% m00 being all 1s. 'MM_m00_max_norm' is normalized such that the max of
% the m00 image is found, and all pixel's MMs are divided out by this max
% value. This leads to m00 showing an image of what the sample would like
% in non-polarized light.
%
% How it works: This function follows the Bueno/Campbell paper "Confocal scanning laser ophthalmoscopy improvement by use
% of Mueller-matrix polarimetry" quite exactly.
% The polarimeter system it is built for follows this setup in order:
% 1) Light Source
% 2) Horizontal Linear Polarizer
% 3) Quarter Wave Plate: 0 degrees corresponds to the slow axis being
% aligned with the transmission axis of the above HLP. The QWP is set to
% -45, 0, 30 and 60 degress. These are mesured on a scale that FACES the
% light source, and so is the opposite of the notation found in Collett's
% "Polarized Light". The calculations done reflect this difference.
% 4) Sample (by transmission)
% 5) Quarter Wave Plate, same as 3). Is set to -45, 0, 30 and 60 as well.
% 6) Horizontal Linear Polarizer
% 7) Monochrome Imager

function MM_norm = computeMMFromPolarizationData(session, toLocationPath, normalizationType, mmComputationType)

% find MM fileSelectionEntry

entries = session.fileSelectionEntries;

mmEntry = [];

for i=1:length(entries)
    if stcmp(entries{i}.dirName, MicroscopNamingConventions.MM_DIR.project)
        mmEntry = entries{i};
    end
end


namingConventions = MicroscopeNamingConventions.getMMNamingConventions();

baseName = makePath(toLocationPath, session.dirName, mmEntry.dirName);

files = mmEntry.filesInDir;

% read in images
images = {};
counter = 1;

for i=1:length(namingconventions)
    projectNamingConventions = namingConventions{i}.project;
    
    fileNameEnding = [createFilenameString(projectNamingConventions, []), Constants.BMP_EXT];
            
    for j=1:length(files)
        indices = containsSubstring(files.dirName, fileNameEnding);
        
        if length(indices) == 1
            index = indices(1);
            
            % delete the match
            file = files{index};
            
            fileName = file.dirName;
            
            images{counter} = imread(makePath(baseName, fileName));
            counter = counter + 1;
        end
    end
    
end


dims = size(images{1}); %size of image found
N = dims(1); %y size
M = dims(2); %x size


[M_G, M_A] = getGeneratorAndAnalyzerMatrices(mmComputationType);

MM = zeros(N,M,4,4); %allocate memory for the image's MMs, each pixel have an associated 4x4 MM

%loop through image, calculating the MM at each point
for y=1:N
    for x=1:M
        I = zeros(4);
        
        I(1,1) = images{1}(y,x); %the imgX chosen for each of these corresponds to the image given in Eqn (2) of Bueno/Campbell paper
        I(1,2) = images{5}(y,x);
        I(1,3) = images{9}(y,x);
        I(1,4) = images{13}(y,x);
        
        I(2,1) = images{2}(y,x);
        I(2,2) = images{6}(y,x);
        I(2,3) = images{10}(y,x);
        I(2,4) = images{14}(y,x);
        
        I(3,1) = images{3}(y,x);
        I(3,2) = images{7}(y,x);
        I(3,3) = images{11}(y,x);
        I(3,4) = images{15}(y,x);
        
        I(4,1) = images{4}(y,x);
        I(4,2) = images{8}(y,x);
        I(4,3) = images{12}(y,x);
        I(4,4) = images{16}(y,x);
                
        M_out = I / M_A; % following eqn (2) in Bueno/Campbell
        
        MM(y,x,:,:) = M_out / M_G; %following eqn (3) in Bueno/Campbell
    end
end

% allocate memory for normalized MM
MM_norm = zeros(N,M,4,4);

% normalize the MM
switch normalizationType
    case pixelWise
        for y=1:N
            for x=1:M
                pixelMM = MM(y,x,:,:);
                
                maxVal = max(max(pixelMM));
                
                pixelMM_norm = pixelMM ./ maxVal;
                
                MM_norm(y,x,:,:) = pixelMM_norm;
            end
        end        
    case mm00Max
        mm00 = MM(:,:,1,1);
        
        maxVal = max(max(mm00));
        
        MM_norm = MM ./ maxVal;
        
    otherwise
        error('Invalid Normalization Type');
end
