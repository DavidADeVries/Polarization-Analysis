% This is a complete overhaul of the MM program that was used pre summer of
% 2014
% Author: David DeVries (ddv993@gmail.com)
% Date:   July 22, 2014
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

function[MM_pixelwise_norm, MM_m00_max_norm] = compute_MM_corrected(filename)

%input for 3 variables

%the extension of the image file type

%4 registered images in order of 45, 00, 30, 60

%file naming convention: filename_XXYY.bmp
%  XX -> Generator QWP Position (45 is actually -45)
%  YY -> Generator QWP Position (45 is actually -45)



try
    image1_1=imread(strcat(filename, '_4545.bmp'));
    image1_2=imread(strcat(filename, '_4500.bmp'));
    image1_3=imread(strcat(filename, '_4530.bmp'));
    image1_4=imread(strcat(filename, '_4560.bmp'));
    image2_1=imread(strcat(filename, '_0045.bmp'));
    image2_2=imread(strcat(filename, '_0000.bmp'));
    image2_3=imread(strcat(filename, '_0030.bmp'));
    image2_4=imread(strcat(filename, '_0060.bmp'));
    image3_1=imread(strcat(filename, '_3045.bmp'));
    image3_2=imread(strcat(filename, '_3000.bmp'));
    image3_3=imread(strcat(filename, '_3030.bmp'));
    image3_4=imread(strcat(filename, '_3060.bmp'));
    image4_1=imread(strcat(filename, '_6045.bmp'));
    image4_2=imread(strcat(filename, '_6000.bmp'));
    image4_3=imread(strcat(filename, '_6030.bmp'));
    image4_4=imread(strcat(filename, '_6060.bmp'));
catch exception
    image1_1=imread(strcat(filename, '_4545.tif'));
    image1_2=imread(strcat(filename, '_4500.tif'));
    image1_3=imread(strcat(filename, '_4530.tif'));
    image1_4=imread(strcat(filename, '_4560.tif'));
    image2_1=imread(strcat(filename, '_0045.tif'));
    image2_2=imread(strcat(filename, '_0000.tif'));
    image2_3=imread(strcat(filename, '_0030.tif'));
    image2_4=imread(strcat(filename, '_0060.tif'));
    image3_1=imread(strcat(filename, '_3045.tif'));
    image3_2=imread(strcat(filename, '_3000.tif'));
    image3_3=imread(strcat(filename, '_3030.tif'));
    image3_4=imread(strcat(filename, '_3060.tif'));
    image4_1=imread(strcat(filename, '_6045.tif'));
    image4_2=imread(strcat(filename, '_6000.tif'));
    image4_3=imread(strcat(filename, '_6030.tif'));
    image4_4=imread(strcat(filename, '_6060.tif'));
end

[~, dimCheck] = size(size(image1_1));

if dimCheck > 2
    image1_1 = rgb2gray(image1_1);
    image1_2 = rgb2gray(image1_2);
    image1_3 = rgb2gray(image1_3);
    image1_4 = rgb2gray(image1_4);
    image2_1 = rgb2gray(image2_1);
    image2_2 = rgb2gray(image2_2);
    image2_3 = rgb2gray(image2_3);
    image2_4 = rgb2gray(image2_4);
    image3_1 = rgb2gray(image3_1);
    image3_2 = rgb2gray(image3_2);
    image3_3 = rgb2gray(image3_3);
    image3_4 = rgb2gray(image3_4);
    image4_1 = rgb2gray(image4_1);
    image4_2 = rgb2gray(image4_2);
    image4_3 = rgb2gray(image4_3);
    image4_4 = rgb2gray(image4_4);
end

matrixSize=size(image1_1); %size of image found
N=matrixSize(1,1); %y size
M=matrixSize(1,2); %x size

%>>>>>> VALUES ARE CONVERTED INTO DOUBLE
img1=double(image1_1);
img2=double(image1_2);
img3=double(image1_3);
img4=double(image1_4);
img5=double(image2_1);
img6=double(image2_2);
img7=double(image2_3);
img8=double(image2_4);
img9=double(image3_1);
img10=double(image3_2);
img11=double(image3_3);
img12=double(image3_4);
img13=double(image4_1);
img14=double(image4_2);
img15=double(image4_3);
img16=double(image4_4);

%clear original images out of RAM
clear image1_1;
clear image1_2;
clear image1_3;
clear image1_4;
clear image2_1;
clear image2_2;
clear image2_3;
clear image2_4;
clear image3_1;
clear image3_2;
clear image3_3;
clear image3_4;
clear image4_1;
clear image4_2;
clear image4_3;
clear image4_4;

% Calculation of M_A in correspondance of Bueno/Campbell Paper
% each M_AX is the first row of the MM of an analyzer state, that is the
% MM of a HLP multiplied by the MM of a rotated QWP
M_A1 = [0.5  0  0  0.5]; %QWP at -45
M_A2 = [0.5  0.5      0       0]; %QWP at 0
M_A3 = [0.5 0.125   -0.2165   -0.433]; %QWP at 30
M_A4 = [0.5 0.125   0.2165    -0.433]; %QWP at 60
M_A = [M_A1; M_A2; M_A3; M_A4]; %combine to make M_A
inv_M_A = inv(M_A); %take the inverse, as is required

% Calculation of M_G, as outlined in Bueno/Campbell Paper
% each column is the Stokes vector of light exiting from the 4 generator
% states. The input light into the generator is unpolarized light: 
% S = [1;0;0;0;]
% Then to find S_out, S_out = MM_QWP * MM_HLP * S
M_G1 = [0.5;  0; 0; -0.5;]; %QWP at -45
M_G2 = [0.5;  0.5; 0; 0;]; %QWP at 0
M_G3 = [0.5;  0.125; -0.2165; 0.433;]; %QWP at 30
M_G4 = [0.5;  0.125; 0.2165; 0.433;]; %QWP at 60
M_G = [M_G1 M_G2 M_G3 M_G4]; %combine to make M_G

MM_pixelwise_norm = zeros(N,M,4,4); %allocate memory for the image's MMs, each pixel have an associated 4x4 MM
MM_m00_max_norm = zeros(N,M,4,4);

%loop through image, calculating the MM at each point
for y=1:N
    for x=1:M
        image = zeros(4);
        
        image(1,1) = img1(y,x); %the imgX chosen for each of these corresponds to the image given in Eqn (2) of Bueno/Campbell paper
        image(1,2) = img5(y,x);
        image(1,3) = img9(y,x);
        image(1,4) = img13(y,x);
        
        image(2,1) = img2(y,x);
        image(2,2) = img6(y,x);
        image(2,3) = img10(y,x);
        image(2,4) = img14(y,x);
        
        image(3,1) = img3(y,x);
        image(3,2) = img7(y,x);
        image(3,3) = img11(y,x);
        image(3,4) = img15(y,x);
        
        image(4,1) = img4(y,x);
        image(4,2) = img8(y,x);
        image(4,3) = img12(y,x);
        image(4,4) = img16(y,x);
                
        M_out = inv_M_A * image; % following eqn (2) in Bueno/Campbell
        
        MM_image = M_out / M_G; %following eqn (3) in Bueno/Campbell
        
        MM_m00_max_norm(y,x,:,:) = MM_image; %don't worry, it'll be normalized later
        
        MM_image = MM_image ./ MM_image(1,1); %normalize (can also normalize over all indices ie find max MM value in whole image, and divide all pixels' MMs by that value
        
        MM_pixelwise_norm(y,x,:,:) = MM_image; % store to pixel
    end
end

max_m00 = max(max(MM_m00_max_norm(:,:,1,1)));

MM_m00_max_norm = MM_m00_max_norm ./ max_m00;