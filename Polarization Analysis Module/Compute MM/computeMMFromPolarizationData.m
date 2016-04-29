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

function MM_norm = computeMMFromPolarizationData(session, toSessionPath, normalizationType, mmComputationType)

% find MM fileSelectionEntry

entries = session.fileSelectionEntries;

mmEntry = [];

for i=1:length(entries)
    if strcmp(entries{i}.dirName, MicroscopeNamingConventions.MM_DIR.getSingularProjectTag())
        mmEntry = entries{i};
    end
end


namingConventions = MicroscopeNamingConventions.getMMNamingConventions();

toDataPath = makePath(toSessionPath, mmEntry.dirName);

files = mmEntry.filesInDir;

% read in images
images = {};
counter = 1;

for i=1:length(namingConventions)
    projectNamingConventions = namingConventions{i}.project;
    
    fileNameEnding = [createFilenameString(projectNamingConventions, []), Constants.BMP_EXT];
    
    numFiles = length(files);
    
    dirNames = cell(numFiles,1);
    
    for j=1:numFiles
        dirNames{j} = files{j}.dirName;
    end
    
    indices = containsSubstring(dirNames, fileNameEnding);
    
    if length(indices) == 1
        index = indices(1);
        
%         % delete the match
%         dirNames(index) = [];
%         files(index) = [];
        
        file = files{index};
        
        fileName = file.dirName;
        
        images{counter} = imread(makePath(toDataPath, fileName));
        counter = counter + 1;
    else
        error('Multiple file matches!!');
    end
    
end


dims = size(images{1}); %size of image found
height = dims(1); %y size
width = dims(2); %x size

% rgb to grayscale values
if length(dims) == 3 %must have been saved as rgb
    for i=1:length(images)
        images{i} = rgb2gray(images{i});
    end
end

% double precision conversion
for i=1:length(images)
    images{i} = double(images{i});
end

% get rid of zeros
for i=1:length(images)
    image = images{i};
    
    zeroVals = (image == 0);
    
    images{i} = image + zeroVals;
end


colHeight = height * width;

[M_G, M_A] = getGeneratorAndAnalyzerMatrices(mmComputationType);

MM = zeros(colHeight,4,4); %allocate memory for the image's MMs, each pixel have an associated 4x4 MM

%reshape raw data in column vectors
reshapeImages = cell(length(images),1);

for i=1:length(images)
    reshapeImages{i} = reshape(images{i}, colHeight, 1);
end


%loop through image, calculating the MM at each point
parfor i=1:colHeight
    I = zeros(4);
    
    I(1,1) = reshapeImages{1}(i); %the imgX chosen for each of these corresponds to the image given in Eqn (2) of Bueno/Campbell paper
    I(1,2) = reshapeImages{5}(i);
    I(1,3) = reshapeImages{9}(i);
    I(1,4) = reshapeImages{13}(i);
    
    I(2,1) = reshapeImages{2}(i);
    I(2,2) = reshapeImages{6}(i);
    I(2,3) = reshapeImages{10}(i);
    I(2,4) = reshapeImages{14}(i);
    
    I(3,1) = reshapeImages{3}(i);
    I(3,2) = reshapeImages{7}(i);
    I(3,3) = reshapeImages{11}(i);
    I(3,4) = reshapeImages{15}(i);
    
    I(4,1) = reshapeImages{4}(i);
    I(4,2) = reshapeImages{8}(i);
    I(4,3) = reshapeImages{12}(i);
    I(4,4) = reshapeImages{16}(i);
    
    M_out = M_A \ I; % following eqn (2) in Bueno/Campbell
    
    MM(i,:,:) = M_out / M_G; %following eqn (3) in Bueno/Campbell
end

% allocate memory for normalized MM
MM_norm = zeros(colHeight,4,4);

% normalize the MM
switch normalizationType
    case MuellerMatrixNormalizationTypes.pixelWise
        parfor i=1:colHeight
            pixelMM = squeeze(MM(i,:,:));
            
            pixelMM_norm = pixelMM ./ pixelMM(1,1);
            
            MM_norm(i,:,:) = pixelMM_norm;
        end        
    case MuellerMatrixNormalizationTypes.mm00Max
        mm00 = MM(:,1,1);
        
        maxVal = max(mm00);
        
        MM_norm = MM ./ maxVal;
        
    otherwise
        error('Invalid Normalization Type');
end

% reshape back
 MM_norm = reshape(MM_norm, height, width, 4, 4);

