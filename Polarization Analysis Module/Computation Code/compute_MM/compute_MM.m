% I am not totally sure, but to run this program
% you will probably need one of the lastest versions
% of MATLAB (6.something)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% WARNING %%%%%%%%%%%%%%%%%%%%%
% The configuraiton of the system needs to be
% Generator: vertical polarizer + rotatory retarder
% Analyzer: rotatory retarder + vertical polarizer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[complete_MM] = compute_MM(filename)

%input for 3 variables

%the extension of the image file type

%4 registered images in order of 45, 00, 30, 60



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

matrixSize=size(image1_1);
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

%% ===============================================================
%% This little bit was added by Aden Seaman to get rid of the image
%% variables that are no longer used.  It saves on memory when using
%% large images

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
%% ===============================================================

%% ===============================================================
%>>>>>> WE MAKE A MATRIX 12x(N*M) TO SPEED THE CALCULATION
%N=size(img1,1);
im(1,:)=reshape(img1,1,N*M);
im(2,:)=reshape(img2,1,N*M);
im(3,:)=reshape(img3,1,N*M);
im(4,:)=reshape(img4,1,N*M);
im(5,:)=reshape(img5,1,N*M);
im(6,:)=reshape(img6,1,N*M);
im(7,:)=reshape(img7,1,N*M);
im(8,:)=reshape(img8,1,N*M);
im(9,:)=reshape(img9,1,N*M);
im(10,:)=reshape(img10,1,N*M);
im(11,:)=reshape(img11,1,N*M);
im(12,:)=reshape(img12,1,N*M);
im(13,:)=reshape(img13,1,N*M);
im(14,:)=reshape(img14,1,N*M);
im(15,:)=reshape(img15,1,N*M);
im(16,:)=reshape(img16,1,N*M);

%=======================================================================
%============================= MAIN PROGRAM ============================
% This part of the program was heavily re-written by Aden Seaman to take
% advantage of the fast matrix and vector multiplication abilities of Matlab.
% The pixel-by-pixel FOR loop has been replaced by operations that work on
% all pixels simultaneously.
% I also added some things to minimize the memory usage when using large images
%=======================================================================

% clear the img[1-16] variables
clear img1;
clear img2;
clear img3;
clear img4;
clear img5;
clear img6;
clear img7;
clear img8;
clear img9;
clear img10;
clear img11;
clear img12;
clear img13;
clear img14;
clear img15;
clear img16;

maxintensity = max(max(im)); % use this later to set the max intensity of the output images

time1 = clock; % start timing, to see how long it takes to process the images

% invert some matrices that are used later
% these were taken directly from the original program

% Spsa1=[0.5  0       0      -0.5];
% Spsa2=[0.5 -0.5     0       0];
% Spsa3=[0.5 -0.125  -0.2165  0.433];
% Spsa4=[0.5 -0.125   0.2165  0.433];
% mp_psaV=[Spsa1; Spsa2; Spsa3; Spsa4];
% inv_psaV = inv(mp_psaV);

% Spsg1=[-1;  0; 0; -1];
% Spsg2=[-1; 1; 0; 0];
% Spsg3=[-1; 0.25; 0.433; 0.866];
% Spsg4=[-1; 0.25; -0.433; 0.866];
% m_psgV=[Spsg1 Spsg2 Spsg3 Spsg4];
% inv_psgV = inv(m_psgV);

% Spsg1=[1;  0; 0; 1];
% Spsg2=[1; -1; 0; 0];
% Spsg3=[1; -0.25; -0.433; -0.866];
% Spsg4=[1; -0.25; 0.433; -0.866];
% m_psgV=[Spsg1 Spsg2 Spsg3 Spsg4];
% inv_psgV = inv(m_psgV);

% Spsa1=[1  0      0       1];
% Spsa2=[1  1      0       0];
% Spsa3=[1  0.25   0.433  -0.866];
% Spsa4=[1  0.25   -0.433 -0.866];
% mp_psaV=0.5 .* [Spsa1; Spsa2; Spsa3; Spsa4];
% inv_psaV = inv(mp_psaV);
% 
% Spsg1=[1;  0; 0; -1;];
% Spsg2=[1;  1; 0; 0;];
% Spsg3=[1;  0.25; 0.433; 0.866;];
% Spsg4=[1;  0.25; -0.433; 0.866;];
% m_psgV=[Spsg1 Spsg2 Spsg3 Spsg4];
% inv_psgV = inv(m_psgV);

Spsa1=[1  0      0       -1];
Spsa2=[1  1      0       0];
Spsa3=[1  0.25   0.433   0.866];
Spsa4=[1  0.25   -0.433  0.866];
mp_psaV=0.5 .* [Spsa1; Spsa2; Spsa3; Spsa4];
inv_psaV = inv(mp_psaV);

Spsg1=[1;  0; 0; 1;];
Spsg2=[1;  1; 0; 0;];
Spsg3=[1;  0.25; 0.433; -0.866;];
Spsg4=[1;  0.25; -0.433; -0.866;];
m_psgV=0.5 .* [Spsg1 Spsg2 Spsg3 Spsg4];
inv_psgV = inv(m_psgV);

% It may seem a little funny to do these matrix multiplications manually, but it saves on
% a lot of intermediate variables which will suck up memory.  This is especially important
% when the matrices get really large.
% The variable names begin assigned here are the same as in the original program

Sp1=zeros(4,N*M);
Sp1(1,:) = inv_psaV(1,1)*im(1,:) + inv_psaV(1,2)*im(2,:) + inv_psaV(1,3)*im(3,:) + inv_psaV(1,4)*im(4,:);
Sp1(2,:) = inv_psaV(2,1)*im(1,:) + inv_psaV(2,2)*im(2,:) + inv_psaV(2,3)*im(3,:) + inv_psaV(2,4)*im(4,:);
Sp1(3,:) = inv_psaV(3,1)*im(1,:) + inv_psaV(3,2)*im(2,:) + inv_psaV(3,3)*im(3,:) + inv_psaV(3,4)*im(4,:);
Sp1(4,:) = inv_psaV(4,1)*im(1,:) + inv_psaV(4,2)*im(2,:) + inv_psaV(4,3)*im(3,:) + inv_psaV(4,4)*im(4,:);

Sp2=zeros(4,N*M);
Sp2(1,:) = inv_psaV(1,1)*im(5,:) + inv_psaV(1,2)*im(6,:) + inv_psaV(1,3)*im(7,:) + inv_psaV(1,4)*im(8,:);
Sp2(2,:) = inv_psaV(2,1)*im(5,:) + inv_psaV(2,2)*im(6,:) + inv_psaV(2,3)*im(7,:) + inv_psaV(2,4)*im(8,:);
Sp2(3,:) = inv_psaV(3,1)*im(5,:) + inv_psaV(3,2)*im(6,:) + inv_psaV(3,3)*im(7,:) + inv_psaV(3,4)*im(8,:);
Sp2(4,:) = inv_psaV(4,1)*im(5,:) + inv_psaV(4,2)*im(6,:) + inv_psaV(4,3)*im(7,:) + inv_psaV(4,4)*im(8,:);

Sp3=zeros(4,N*M);
Sp3(1,:) = inv_psaV(1,1)*im(9,:) + inv_psaV(1,2)*im(10,:) + inv_psaV(1,3)*im(11,:) + inv_psaV(1,4)*im(12,:);
Sp3(2,:) = inv_psaV(2,1)*im(9,:) + inv_psaV(2,2)*im(10,:) + inv_psaV(2,3)*im(11,:) + inv_psaV(2,4)*im(12,:);
Sp3(3,:) = inv_psaV(3,1)*im(9,:) + inv_psaV(3,2)*im(10,:) + inv_psaV(3,3)*im(11,:) + inv_psaV(3,4)*im(12,:);
Sp3(4,:) = inv_psaV(4,1)*im(9,:) + inv_psaV(4,2)*im(10,:) + inv_psaV(4,3)*im(11,:) + inv_psaV(4,4)*im(12,:);

Sp4=zeros(4,N*M);
Sp4(1,:) = inv_psaV(1,1)*im(13,:) + inv_psaV(1,2)*im(14,:) + inv_psaV(1,3)*im(15,:) + inv_psaV(1,4)*im(16,:);
Sp4(2,:) = inv_psaV(2,1)*im(13,:) + inv_psaV(2,2)*im(14,:) + inv_psaV(2,3)*im(15,:) + inv_psaV(2,4)*im(16,:);
Sp4(3,:) = inv_psaV(3,1)*im(13,:) + inv_psaV(3,2)*im(14,:) + inv_psaV(3,3)*im(15,:) + inv_psaV(3,4)*im(16,:);
Sp4(4,:) = inv_psaV(4,1)*im(13,:) + inv_psaV(4,2)*im(14,:) + inv_psaV(4,3)*im(15,:) + inv_psaV(4,4)*im(16,:);

% now clear the im matrix from memory

clear im;

% do the matrix multiplication m = m_out * inv_psgV the long way, since the added pixel
% dimension and the way in which the matrices are structured prevents it from being
% performed by a single Matlab operator
%
% You can see where this comes from very simply.  I used the formula for matrix multiplication
% m(i,k) = sum_j A(i,j)*B(j,k) and creating a simple UNIX script to spit this out as the full variable names
%
% for ((i=1;i<=4;i++));do for ((j=1;j<=4;j++));do echo m3d\("$i","$j",:\) = Sp1\("$i",:\)*inv_psgV\(1,"$j"\) + Sp2\("$i",:\)*inv_psgV\(2,"$j"\) + Sp3\("$i",:\)*inv_psgV\(3,"$j"\) + Sp4\("$i",:\)*inv_psgV\(4,"$j"\)\;;done;done
%
% then manually unwrapped the m3d matrix into a vector.  You can see how the vector unwraps
% simply by issuing these two matlab commands
%
% test = [1,2,3,4;5,6,7,8;9,10,11,12;,13,14,15,16]
% reshape(test,16,1)
%
% and then map the appropriate vector indices onto the matrix components, which come from the command above
% that's it!

matriz = zeros(16,N*M);

matriz(1,:) = Sp1(1,:)*inv_psgV(1,1) + Sp2(1,:)*inv_psgV(2,1) + Sp3(1,:)*inv_psgV(3,1) + Sp4(1,:)*inv_psgV(4,1);
matriz(5,:) = Sp1(1,:)*inv_psgV(1,2) + Sp2(1,:)*inv_psgV(2,2) + Sp3(1,:)*inv_psgV(3,2) + Sp4(1,:)*inv_psgV(4,2);
matriz(9,:) = Sp1(1,:)*inv_psgV(1,3) + Sp2(1,:)*inv_psgV(2,3) + Sp3(1,:)*inv_psgV(3,3) + Sp4(1,:)*inv_psgV(4,3);
matriz(13,:) = Sp1(1,:)*inv_psgV(1,4) + Sp2(1,:)*inv_psgV(2,4) + Sp3(1,:)*inv_psgV(3,4) + Sp4(1,:)*inv_psgV(4,4);
matriz(2,:) = Sp1(2,:)*inv_psgV(1,1) + Sp2(2,:)*inv_psgV(2,1) + Sp3(2,:)*inv_psgV(3,1) + Sp4(2,:)*inv_psgV(4,1);
matriz(6,:) = Sp1(2,:)*inv_psgV(1,2) + Sp2(2,:)*inv_psgV(2,2) + Sp3(2,:)*inv_psgV(3,2) + Sp4(2,:)*inv_psgV(4,2);
matriz(10,:) = Sp1(2,:)*inv_psgV(1,3) + Sp2(2,:)*inv_psgV(2,3) + Sp3(2,:)*inv_psgV(3,3) + Sp4(2,:)*inv_psgV(4,3);
matriz(14,:) = Sp1(2,:)*inv_psgV(1,4) + Sp2(2,:)*inv_psgV(2,4) + Sp3(2,:)*inv_psgV(3,4) + Sp4(2,:)*inv_psgV(4,4);
matriz(3,:) = Sp1(3,:)*inv_psgV(1,1) + Sp2(3,:)*inv_psgV(2,1) + Sp3(3,:)*inv_psgV(3,1) + Sp4(3,:)*inv_psgV(4,1);
matriz(7,:) = Sp1(3,:)*inv_psgV(1,2) + Sp2(3,:)*inv_psgV(2,2) + Sp3(3,:)*inv_psgV(3,2) + Sp4(3,:)*inv_psgV(4,2);
matriz(11,:) = Sp1(3,:)*inv_psgV(1,3) + Sp2(3,:)*inv_psgV(2,3) + Sp3(3,:)*inv_psgV(3,3) + Sp4(3,:)*inv_psgV(4,3);
matriz(15,:) = Sp1(3,:)*inv_psgV(1,4) + Sp2(3,:)*inv_psgV(2,4) + Sp3(3,:)*inv_psgV(3,4) + Sp4(3,:)*inv_psgV(4,4);
matriz(4,:) = Sp1(4,:)*inv_psgV(1,1) + Sp2(4,:)*inv_psgV(2,1) + Sp3(4,:)*inv_psgV(3,1) + Sp4(4,:)*inv_psgV(4,1);
matriz(8,:) = Sp1(4,:)*inv_psgV(1,2) + Sp2(4,:)*inv_psgV(2,2) + Sp3(4,:)*inv_psgV(3,2) + Sp4(4,:)*inv_psgV(4,2);
matriz(12,:) = Sp1(4,:)*inv_psgV(1,3) + Sp2(4,:)*inv_psgV(2,3) + Sp3(4,:)*inv_psgV(3,3) + Sp4(4,:)*inv_psgV(4,3);
matriz(16,:) = Sp1(4,:)*inv_psgV(1,4) + Sp2(4,:)*inv_psgV(2,4) + Sp3(4,:)*inv_psgV(3,4) + Sp4(4,:)*inv_psgV(4,4);

time2 = clock; % set the finishing time

% now clear the Sp[1-4] variables

clear Sp1;
clear Sp2;
clear Sp3;
clear Sp4;

% now rescale this matrix so that it starts at zero and goes to the maximum intensity value recorded previously
% it may seem a little funny to assign the variables "minvalue" and "maxvalue" however when issuing the command
% matriz = matriz*maxintensity/max(max(matriz)) the computer seems to go crazy for large images.
% I expect this is due to some way that it handles variables that are named in their own assignment.  It may create
% a copy of matriz, which would greatly increase the amount of memory used.
% I modified the way this section rescales the intensity values for the matrix.  In the old version of the code
% the intensity values could go negative, which is a no no when trying to write them to an image file.

% minvalue = min(min(matriz));
% matriz = matriz - minvalue;
% maxvalue = max(max(matriz));
% matriz = matriz*(maxintensity/maxvalue);

max_total=max(max(matriz));
matriz=matriz/max_total;

%=========================================================================
% This ends the modifications made to the program by Aden Seaman.  I performed
% some benchmarks on the original code and my modifications, with surprising
% results.
% On a 1.8 GHz Thinkpad T30 using GNU Octave, the calculation time versus
% image height goes like this:
% timeold(h) = -24.595 + 1.1912 * h - 0.018284 * h**2 + 0.00014703 * h**3
% and the new program goes like:
% timenew(h) = 0.067683 - 0.0013872 * h + 3.3449e-05 * h**2 + 4.233e-10 * h**3
% For a 1000x1000 image ( h=1000 ) the curve fit indicates the old program will
% take 130,000 seconds = 36 hours to run.  This is close to the amount of time
% that Chris has reported.
% For the new program, it will take 32.5 seconds.  When I ran it myself, it actually
% took 25 seconds, but it's close enough.
% This is a speed increase of 4,000 times.  I hope you enjoy it!
%===================== END OF THE MAIN PROGRAM ===========================
%=========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	%=== Individual spatially resolved MM elements
complete_MM = zeros(N,M,4,4); %(ySize,xSize,j,i) for the convention: m_yx
    
complete_MM(:,:,1,1) = reshape(matriz(1,:),N,M);
complete_MM(:,:,1,2) = reshape(matriz(2,:),N,M); 
complete_MM(:,:,1,3) = reshape(matriz(3,:),N,M);
complete_MM(:,:,1,4) = reshape(matriz(4,:),N,M);
complete_MM(:,:,2,1) = reshape(matriz(5,:),N,M);
complete_MM(:,:,2,2) = reshape(matriz(6,:),N,M);
complete_MM(:,:,2,3) = reshape(matriz(7,:),N,M);
complete_MM(:,:,2,4) = reshape(matriz(8,:),N,M);
complete_MM(:,:,3,1) = reshape(matriz(9,:),N,M);
complete_MM(:,:,3,2) = reshape(matriz(10,:),N,M);
complete_MM(:,:,3,3) = reshape(matriz(11,:),N,M);
complete_MM(:,:,3,4) = reshape(matriz(12,:),N,M);
complete_MM(:,:,4,1) = reshape(matriz(13,:),N,M);
complete_MM(:,:,4,2) = reshape(matriz(14,:),N,M);
complete_MM(:,:,4,3) = reshape(matriz(15,:),N,M);
complete_MM(:,:,4,4) = reshape(matriz(16,:),N,M);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% THIS IS THE END %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
