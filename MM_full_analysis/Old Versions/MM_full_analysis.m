function[] = MM_full_analysis(path, file)

% VERSION 1.0.0 %

%MM_full_analysis takes in a 'path' (ending in /) to a directory containing the 16 raw
%images taken by the microscope in the 16 PSA/PSG states (0000, 0030,
%etc.). The 'file' parameter refers to the filename of the raw images,
%minus the _XXXX.bmp suffix. That is to say, the expected name of the first
%file would be: "file_0000.bmp". As suggested, the expected file format is
%bitmap.
%MM_full_analysis has multiple steps, each of which is outlined below, and
%the status of each step is displayed as the function executes. The steps
%are as follows:
%1) Output directories are created
%2) Images are aligned using external functions. Matrices containing
%aligned images are returned.
%3) Aligned image matrices are written in the 'Alignment' directory in bmp
%and txt formats
%4) Aligned image matrices are passed to external functions to compute the
%Mueller Matrices (MMs). MMs are returned as matrices.
%5) MMs are then written to the 'MM' directory in a variety of formats
%including bmp, txt, and composites (4x4 matrix image)
%6) Return matrices are allocated in memory in order to make processing
%faster
%7) MMs are then processed to compute the various metrics using a loop that makes up a majority of this
%file. Results per pixel are stored in a vector as long as one column, and
%then these columns are inserted into the return matrices. This is done to
%conserve on disk I/O
%8) Return matrices are then written in a variety of ways to the
%'Depolarization', 'Diattenuation', and 'Retardance" directories. They are
%saved as txts, bmps, composites, and some pngs with colour scales.

format long;
disp('Analysis Start');

filename = strcat(path,file);

%CONVENTIONS:
%Vertical <-> y <-> j
%Horizontal <-> x <-> i
%MM(y,x) <-> MM(j,i)

disp('Creating Output Directories...');

mkdir(strcat(path, 'MM - Pixelwise Norm'));
mkdir(strcat(path, 'MM - Max m_00 Norm'));
mkdir(strcat(path, 'Depolarization'));
mkdir(strcat(path, 'Depolarization/MM'));
mkdir(strcat(path, 'Diattenuation'));
mkdir(strcat(path, 'Diattenuation/MM'));
mkdir(strcat(path, 'Retardance'));
mkdir(strcat(path, 'Retardance/MM'));
% mkdir(strcat(path, 'Stokes'));
mkdir(strcat(path, 'Metrics and Histograms'));
mkdir(strcat(path, 'Additional Retardance Calcs'));

disp('Complete!');

disp('Computing Mueller Matrices...');
%Compute the Mueller Matrices
[MM_pixelwise_norm, MM_m00_max_norm] = compute_MM_corrected(filename);

%Get horizontal and vertical dimensions
imageSizes = size(MM_pixelwise_norm);
ySize = imageSizes(1);
xSize = imageSizes(2);

disp('Complete!');
disp('Writing Mueller Matrix Files...');

write_MM_files(MM_pixelwise_norm, strcat(path,'MM - Pixelwise Norm/',file)); %both normalizations are outputted
write_MM_files(MM_m00_max_norm, strcat(path,'MM - Max m_00 Norm/',file));

%remove!
MM_pixelwise_norm = MM_m00_max_norm;

clear MM_m00_max_norm; %clear this image from RAM, it is no longer needed.

disp('Complete!');
disp('Validating Mueller Matrices for Analysis...');

%Ensure Valid MMs
for i=1:4
    for j=1:4
        MM_pixelwise_norm(:,:,j,i) = nonzero(MM_pixelwise_norm(:,:,j,i)); %pixelwise normalizations are used for calculations
    end
end

disp('Complete!');
disp('Allocating Memory...');

%Return Matrices:
retardance              = zeros(ySize,xSize);
opticalRotation         = zeros(ySize,xSize);
retardanceHorz          = zeros(ySize,xSize);
retardance45deg         = zeros(ySize,xSize);
retardanceCirc          = zeros(ySize,xSize);
retardanceLinear        = zeros(ySize,xSize);
diatten                 = zeros(ySize,xSize);
diattenLinear           = zeros(ySize,xSize);
diattenHorz             = zeros(ySize,xSize);
diatten45deg            = zeros(ySize,xSize);
diattenCirc             = zeros(ySize,xSize);
polarizance             = zeros(ySize,xSize);
polarizanceLinear       = zeros(ySize,xSize);
polarizanceHorz         = zeros(ySize,xSize);
polarizance45deg        = zeros(ySize,xSize);
polarizanceCirc         = zeros(ySize,xSize);
depolarizationIndex     = zeros(ySize,xSize);
degreeOfPolarization    = zeros(ySize,xSize);
qMetric                 = zeros(ySize,xSize);
% stokesDegreeOfPolarization = zeros(ySize,xSize);
% stokesRetardance           = zeros(ySize,xSize);
% stokesAzimuth              = zeros(ySize,xSize);
% maxTransmitance         = zeros(ySize,xSize);
% minTransmitance         = zeros(ySize,xSize);
retardanceMatrices      = zeros(ySize,xSize,4,4);
diattenMatrices         = zeros(ySize,xSize,4,4);
depolarMatrices         = zeros(ySize,xSize,4,4);
rho1 = zeros(ySize,xSize);
rhoApprox1 = zeros(ySize,xSize);
rho2 = zeros(ySize,xSize);
rhoApprox2 = zeros(ySize,xSize);
theta = zeros(ySize,xSize);
thetaApprox = zeros(ySize,xSize);
delta = zeros(ySize,xSize);
deltaApprox = zeros(ySize,xSize);

MM = zeros(4);

disp('Complete!');
disp('Computing Metrics...');

%Loop through each pixel
for pix_i = 1:xSize
    % insert by column, not individual indices to speed up memory accesses
    retardanceCol       = zeros(ySize, 1);
    opticalRotationCol  = zeros(ySize, 1);
    retardanceHorzCol   = zeros(ySize, 1);
    retardance45degCol  = zeros(ySize, 1);
    retardanceCircCol   = zeros(ySize, 1);
    retardanceLinearCol = zeros(ySize, 1);
    diattenCol          = zeros(ySize, 1);
    diattenLinearCol    = zeros(ySize, 1);
    diattenHorzCol      = zeros(ySize, 1);
    diatten45degCol     = zeros(ySize, 1);
    diattenCircCol      = zeros(ySize, 1);
    polarizanceCol      = zeros(ySize, 1);
    polarizanceLinearCol= zeros(ySize, 1);
    polarizanceHorzCol  = zeros(ySize, 1);
    polarizance45degCol = zeros(ySize, 1);
    polarizanceCircCol  = zeros(ySize, 1);
    depolarizationIndexCol   = zeros(ySize, 1);
    degreeOfPolarizationCol  = zeros(ySize, 1);
    qMetricCol          = zeros(ySize, 1);
%     stokesDegreeOfPolarizationCol = zeros(ySize,1);
%     stokesRetardanceCol           = zeros(ySize,1);
%     stokesAzimuthCol              = zeros(ySize,1);
%     maxTransmitanceCol  = zeros(ySize,1);
%     minTransmitanceCol  = zeros(ySize,1);
    retardanceMatricesCol   = zeros(ySize,1,4,4);
    diattenMatricesCol      = zeros(ySize,1,4,4);
    depolarMatricesCol      = zeros(ySize,1,4,4);
    rho1Col = zeros(ySize,1);
    rhoApprox1Col = zeros(ySize,1);
    rho2Col = zeros(ySize,1);
    rhoApprox2Col = zeros(ySize,1);
    thetaCol = zeros(ySize,1);
    thetaApproxCol = zeros(ySize,1);
    deltaCol = zeros(ySize,1);
    deltaApproxCol = zeros(ySize,1);
    
    for pix_j = 1: ySize
        
        %Get the MM for the pixel (j,i) in question
                
        for i = 1:4,
            for j = 1:4,
                MM(j,i) = MM_pixelwise_norm(pix_j,pix_i,j,i);
            end
        end
                                
        %Submatrix of original Mueller Matrix Elements
        
        mm = [  MM(2,2)  MM(2,3) MM(2,4);
                MM(3,2)  MM(3,3) MM(3,4);
                MM(4,2)  MM(4,3) MM(4,4)];
        
        D = (1/MM(1,1)) .* [MM(1,2); MM(1,3); MM(1,4)];
        
        P = (1/MM(1,1)) .* [MM(2,1); MM(3,1); MM(4,1)];
            
        D_mag_sqr = (1/(MM(1,1)^2)) .* (((MM(1,2))^2) + ((MM(1,3))^2) + ((MM(1,4))^2));
        
        I = eye(3);
        
        m_D = (sqrt(1 - D_mag_sqr) * I) + ((1 - sqrt(1 - D_mag_sqr)) * ((1/D_mag_sqr)*(D*D')));
        
        M_D = (1/MM(1,1)) .* [ 1 D(1) D(2) D(3);
                D(1) m_D(1,1) m_D(1,2) m_D(1,3);
                D(2) m_D(2,1) m_D(2,2) m_D(2,3);
                D(3) m_D(3,1) m_D(3,2) m_D(3,3);];
           
        M_prime = MM * inv(M_D);
        
        m_prime = [ M_prime(2,2) M_prime(2,3) M_prime(2,4);
                    M_prime(3,2) M_prime(3,3) M_prime(3,4);
                    M_prime(4,2) M_prime(4,3) M_prime(4,4);];
            
        P_delta = (P - (mm * D)) / (1- D_mag_sqr);
       
        eigens = eig(m_prime * m_prime');
        
        m_delta = inv((m_prime * m_prime') + ((sqrt(eigens(1)*eigens(2)) + sqrt(eigens(1)*eigens(3)) + sqrt(eigens(2)*eigens(3))) .* I)) * (((sqrt(eigens(1)) + sqrt(eigens(2)) + sqrt(eigens(3))) * (m_prime * m_prime')) + (sqrt(eigens(1)*eigens(2)*eigens(3)) .* I));
        
        if det(m_prime) < 0
           m_delta = -m_delta; 
        end
        
        M_delta = [ 1 0 0 0;
                    P_delta(1) m_delta(1,1) m_delta(1,2) m_delta(1,3);
                    P_delta(2) m_delta(2,1) m_delta(2,2) m_delta(2,3);
                    P_delta(3) m_delta(3,1) m_delta(3,2) m_delta(3,3);];
                               
        M_R = inv(M_delta) * M_prime;
                
        M_R = real(M_R);
                
        %STORE CALCULATED VALUES AT PIXEL TO RETURN MATRICES:
        
        %Calculates the retardance from the retardation mueller matrix according to
        %equation (17).
        
        radToDeg = 180/pi;
        
        MM_sqr = MM.^2; %each index squared, not MM*MM
        
        R = acos((trace(M_R)/2)-1);
        R_in_deg = R * radToDeg;
                
        retardanceCol(pix_j, 1) = real(R_in_deg);
        
        retardanceHorzCol   (pix_j, 1) = real((R_in_deg/(2*sin(R))).*(M_R(3,4) - M_R(4,3))); %according to Chipman eqn (17)
        retardance45degCol  (pix_j, 1) = real((R_in_deg/(2*sin(R))).*(M_R(4,2) - M_R(2,4))); %according to Chipman eqn (17)
        retardanceCircCol   (pix_j, 1) = real((R_in_deg/(2*sin(R))).*(M_R(2,3) - M_R(3,2))); %according to Chipman eqn (17)
        retardanceLinearCol (pix_j, 1) = sqrt((retardanceHorzCol(pix_j,1)^2) + (retardance45degCol(pix_j,1)^2)); %or: real(acos(((((M_R(2,2)+M_R(3,3)).^2)+((M_R(3,2)-M_R(2,3)).^2)).^0.5)-1)*radToDeg) 
        
        opticalRotationCol  (pix_j, 1) = real(atan2((M_R(3,2)-M_R(2,3)),(M_R(2,2)+M_R(3,3)))*radToDeg);
        
        diattenCol          (pix_j, 1) = sqrt(MM_sqr(1,2) + MM_sqr(1,3) + MM_sqr(1,4))./(MM(1,1)); %range: 0..1
        diattenLinearCol    (pix_j, 1) = sqrt(MM_sqr(1,2) + MM_sqr(1,3))./(MM(1,1));
        diattenHorzCol      (pix_j, 1) = MM(1,2)./MM(1,1); %range: -1..1
        diatten45degCol     (pix_j, 1) = MM(1,3)./MM(1,1); %range: -1..1
        diattenCircCol      (pix_j, 1) = MM(1,4)./MM(1,1); %range: -1..1
        
        polarizanceCol      (pix_j, 1) = sqrt(MM_sqr(2,1) + MM_sqr(3,1) + MM_sqr(4,1))./MM(1,1); %range: 0..1
        
        polarizanceLinearCol(pix_j, 1) = sqrt(MM_sqr(2,1) + MM_sqr(3,1))./(MM(1,1));
        polarizanceHorzCol  (pix_j, 1) = MM(2,1)./MM(1,1); %range: -1..1
        polarizance45degCol (pix_j, 1) = MM(3,1)./MM(1,1); %range: -1..1
        polarizanceCircCol  (pix_j, 1) = MM(4,1)./MM(1,1); %range: -1..1
        
        depolarizationIndexCol   (pix_j, 1) = sqrt(sum(sum(MM_sqr)) - MM_sqr(1,1))./(sqrt(3).*MM(1,1)); %Depolarization Index as outlined in the Handbook of Optics sect. 14.28
        degreeOfPolarizationCol  (pix_j, 1) = 1 - depolarizationIndexCol(pix_j, 1); %DOP as per Fran's code
        
        qMetricCol          (pix_j, 1) = (3*(depolarizationIndexCol(pix_j,1)^2) - (diattenCol(pix_j,1)^2)) / (1 + (diattenCol(pix_j,1)^2));
            
%         DOP = sqrt((S1^2) + (S2^2) + (S3^2)) / S0;
%                 stokesDegreeOfPolarizationCol(pix_j, 1) = DOP;
%         azimuth                       = 0.5 * atan2(-(DOP + S1),(S2));
%         stokesAzimuthCol(pix_j, 1)              = azimuth * radToDeg;
%         stokesRetardanceCol(pix_j, 1)           = acos(1 + ((2*S2)/(DOP*sin(4*azimuth)))) * radToDeg;        
        
%         maxTransmitanceCol  (pix_j, 1) = MM(1,1).*(1 + diattenCol(pix_j,1));
%         minTransmitanceCol  (pix_j, 1) = MM(1,1).*(1 - diattenCol(pix_j,1));
                
        for i=1:4
           for j=1:4
               retardanceMatricesCol    (pix_j,1,j,i) = M_R(j,i);
               diattenMatricesCol       (pix_j,1,j,i) = real(M_D(j,i));
               depolarMatricesCol       (pix_j,1,j,i) = real(M_delta(j,i));
           end
        end
        
        rho1Col(pix_j, 1) = 0.5 .* real(acos(MM(3,4) ./ sqrt(1 - MM(4,4) .^ 2))) .* radToDeg;
        rhoApprox1Col(pix_j, 1) = real(MM(3,4) ./ sqrt(1 - MM(4,4) .^ 2));
        rho2Col(pix_j, 1) = 0.5 .* real(atan2(MM(2,4),MM(3,4))) .* radToDeg;
        rhoApprox2Col(pix_j, 1) = MM(2,4) ./ MM(3,4);
        thetaCol(pix_j, 1) = 0.5 .* real(atan2((MM(2,3) - MM(3,2)),(MM(2,2) + MM(3,3)))) .* radToDeg;
        thetaApproxCol(pix_j, 1) = (MM(2,3) - MM(3,2)) ./ (MM(2,2) + MM(3,3));
        deltaCol(pix_j, 1) = real(acos(MM(4,4))) .* radToDeg;
        deltaApproxCol(pix_j, 1) = MM(4,4);
                                
    end
    
    retardance(:,pix_i)       = retardanceCol;
    opticalRotation(:,pix_i)  = opticalRotationCol;
    retardanceHorz(:,pix_i)   = retardanceHorzCol;
    retardance45deg(:,pix_i)  = retardance45degCol;
    retardanceCirc(:,pix_i)   = retardanceCircCol;
    retardanceLinear(:,pix_i) = retardanceLinearCol;
    diatten(:,pix_i)          = diattenCol;
    diattenLinear(:,pix_i)    = diattenLinearCol;
    diattenHorz(:,pix_i)      = diattenHorzCol;
    diatten45deg(:,pix_i)     = diatten45degCol;
    diattenCirc(:,pix_i)      = diattenCircCol;
    polarizance(:,pix_i)      = polarizanceCol;
    polarizanceLinear(:,pix_i)= polarizanceLinearCol;
    polarizanceHorz(:,pix_i)  = polarizanceHorzCol;
    polarizance45deg(:,pix_i) = polarizance45degCol;
    polarizanceCirc(:,pix_i)  = polarizanceCircCol;
    depolarizationIndex(:,pix_i)   = depolarizationIndexCol;
    degreeOfPolarization(:,pix_i)  = degreeOfPolarizationCol;
    qMetric(:,pix_i)          = qMetricCol;
%     stokesDegreeOfPolarization(:,pix_i) = stokesDegreeOfPolarizationCol;
%     stokesRetardance(:,pix_i) = stokesRetardanceCol;
%     stokesAzimuth(:,pix_i) = stokesAzimuthCol;
%     maxTransmitance(:,pix_i)  = maxTransmitanceCol;
%     minTransmitance(:,pix_i)  = minTransmitanceCol;
    retardanceMatrices   (:, pix_i,:,:) = retardanceMatricesCol;
    diattenMatrices      (:, pix_i,:,:) = diattenMatricesCol;
    depolarMatrices      (:, pix_i,:,:) = depolarMatricesCol;
    rho1(:,pix_i) = rho1Col;
    rhoApprox1(:,pix_i) = rhoApprox1Col;
    rho2(:,pix_i) = rho2Col;
    rhoApprox2(:,pix_i) = rhoApprox2Col;
    theta(:,pix_i) = thetaCol;
    thetaApprox(:,pix_i) = thetaApproxCol;
    delta(:,pix_i) = deltaCol;
    deltaApprox(:,pix_i) = deltaApproxCol;
end

disp('Complete!');
disp('Writing Analysis Files...');

%write metric results to text file

metric_labels = [
    cellstr('Diattenuation');
    cellstr('Linear Diattenuation'); 
    cellstr('Horizontal Diattenuation'); 
    cellstr('45 deg Diattenuation'); 
    cellstr('Circular Diattenuation');
    cellstr('Polarizance');
    cellstr('Linear Polarizance'); 
    cellstr('Horizontal Polarizance'); 
    cellstr('45 deg Polarizance'); 
    cellstr('Circular Polarizance');
    cellstr('Retardance (Circ)');
    cellstr('Linear Retardance (Circ)'); 
    cellstr('Horizontal Retardance (Circ)'); 
    cellstr('45 deg Retardance (Circ)'); 
    cellstr('Circular Retardance (Circ)');
    cellstr('Optical Rotation (Circ)');   
    cellstr('Retardance (Abs)');
    cellstr('Linear Retardance (Abs)'); 
    cellstr('Horizontal Retardance (Abs)'); 
    cellstr('45 deg Retardance (Abs)'); 
    cellstr('Circular Retardance (Abs)');
    cellstr('Optical Rotation (Abs)');
    cellstr('Depolarization Index');
    cellstr('Degree of Polarization');
    cellstr('Q Metric');
    cellstr('cos(2*Rho)');
    cellstr('tan(2*Rho)');
    cellstr('cos(Delta)');
    cellstr('tan(2*Theta)');
    cellstr('Rho 1 (Circ)');
    cellstr('Rho 2 (Circ)');    
    cellstr('Delta (Circ)');
    cellstr('Theta (Circ)');
    cellstr('Rho 1 (Abs)');
    cellstr('Rho 2 (Abs)');    
    cellstr('Delta (Abs)');
    cellstr('Theta (Abs)');];

m = xSize * ySize;

degToRad = pi ./ 180;

metric_datasets = [
    reshape(diatten,1,m); 
    reshape(diattenLinear,1,m); 
    reshape(diattenHorz,1,m); 
    reshape(diatten45deg,1,m); 
    reshape(diattenCirc,1,m);
    
    reshape(polarizance,1,m); 
    reshape(polarizanceLinear,1,m); 
    reshape(polarizanceHorz,1,m); 
    reshape(polarizance45deg,1,m); 
    reshape(polarizanceCirc,1,m); 
    
    reshape(retardance,1,m) .* degToRad; 
    reshape(retardanceLinear,1,m) .* degToRad; 
    reshape(retardanceHorz,1,m) .* degToRad; 
    reshape(retardance45deg,1,m) .* degToRad; 
    reshape(retardanceCirc,1,m) .* degToRad;
    reshape(opticalRotation,1,m) .* degToRad;
    
    abs(reshape(retardance,1,m)); 
    abs(reshape(retardanceLinear,1,m)); 
    abs(reshape(retardanceHorz,1,m)); 
    abs(reshape(retardance45deg,1,m)); 
    abs(reshape(retardanceCirc,1,m));
    abs(reshape(opticalRotation,1,m));
    
    reshape(depolarizationIndex,1,m);
    reshape(degreeOfPolarization,1,m);
    reshape(qMetric,1,m);
    
    reshape(rhoApprox1,1,m);
    reshape(rhoApprox2,1,m);
    reshape(deltaApprox,1,m);
    reshape(thetaApprox,1,m);
    
    reshape(rho1,1,m) .* degToRad;
    reshape(rho2,1,m)  .* degToRad;
    reshape(delta,1,m)  .* degToRad;
    reshape(theta,1,m)  .* degToRad;
    
    reshape(rho1,1,m);
    reshape(rho2,1,m);
    reshape(delta,1,m);
    reshape(theta,1,m);];

filepath = strcat(path, 'Metrics and Histograms/', file, '_metrics.csv');

write_metrics_file(metric_labels,metric_datasets,filepath);

% End writing metrics file

% Write Histograms

figure;
set(gcf,'Visible','off');

hist(reshape(diatten,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_diattenuation_histogram.png'));
hist(reshape(diattenLinear,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_linear_diattenuation_histogram.png'));
hist(reshape(diattenHorz,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_horizontal_diattenuation_histogram.png'));
hist(reshape(diatten45deg,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_45deg_diattenuation_histogram.png'));
hist(reshape(diattenCirc,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_circular_diattenuation_histogram.png'));

hist(reshape(polarizance,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_polarizance_histogram.png'));
hist(reshape(polarizanceLinear,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_linear_polarizance_histogram.png'));
hist(reshape(polarizanceHorz,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_horizontal_polarizance_histogram.png'));
hist(reshape(polarizance45deg,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_45deg_polarizance_histogram.png'));
hist(reshape(polarizanceCirc,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_circular_polarizance_histogram.png'));

hist(reshape(retardance,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_retardance_histogram.png'));
hist(reshape(retardanceLinear,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_linear_retardance_histogram.png'));
hist(reshape(retardanceHorz,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_horizontal_retardance_histogram.png'));
hist(reshape(retardance45deg,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_45deg_retardance_histogram.png'));
hist(reshape(retardanceCirc,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_circular_retardance_histogram.png'));

hist(reshape(rho1,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_rho1_histogram.png'));
% hist(reshape(rhoApprox1,1,m),100);
% saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_rho1_approx_histogram.png'));
hist(reshape(rho2,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_rho2_histogram.png'));
% hist(reshape(rhoApprox2,1,m),100);
% saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_rho2_approx_histogram.png'));
hist(reshape(delta,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_delta_histogram.png'));
% hist(reshape(deltaApprox,1,m),100);
% saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_delta_approx_histogram.png'));
hist(reshape(theta,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_theta_histogram.png'));
% hist(reshape(thetaApprox,1,m),100);
% saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_theta_approx_histogram.png'));


hist(reshape(opticalRotation,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_optical_rotation_histogram.png'));
hist(reshape(depolarizationIndex,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_depolarization_index_histogram.png'));
hist(reshape(degreeOfPolarization,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_degree_of_polarization_histogram.png'));
hist(reshape(qMetric,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_Q_metric_histogram.png'));

close;

% End Histograms

%Write Stokes files

% stokesPath = strcat(path, 'Stokes/', file);
% 
% dlmwrite(strcat(stokesPath, '_stokes_degree_of_polarization.txt'), (stokesDegreeOfPolarization));
% dlmwrite(strcat(stokesPath, '_stokes_retardance.txt'), (stokesRetardance));
% dlmwrite(strcat(stokesPath, '_stokes_azimuth.txt'), (stokesAzimuth));
% 
% imwrite((stokesDegreeOfPolarization/(2*255)+0.5), strcat(stokesPath, '_stokes_degree_of_polarization.bmp'));
% imwrite((stokesRetardance/(2*255)+0.5), strcat(stokesPath, '_stokes_retardance.bmp'));
% imwrite((stokesAzimuth/(2*255)+0.5), strcat(stokesPath, '_stokes_azimuth.bmp'));
% 
% write_colourbar_files(stokesDegreeOfPolarization, strcat(stokesPath, '_stokes_degree_of_polarization'), [0,1]);
% write_colourbar_files(stokesRetardance, strcat(stokesPath, '_stokes_retardance'),[0,180]);
% write_colourbar_files(stokesAzimuth, strcat(stokesPath, '_stokes_azimuth'),[-90,90]);

%End Stokes

%Write Retardance files

retardancePath = strcat(path, 'Retardance/', file);

dlmwrite(strcat(retardancePath, '_retardance.csv'), (retardance),'precision',7);
dlmwrite(strcat(retardancePath, '_optical_rotation.txt'), (opticalRotation));
dlmwrite(strcat(retardancePath, '_horizontal_retardance.txt'), (retardanceHorz));
dlmwrite(strcat(retardancePath, '_45deg_retardance.txt'), (retardance45deg));
dlmwrite(strcat(retardancePath, '_circular_retardance.txt'), (retardanceCirc));
dlmwrite(strcat(retardancePath, '_linear_retardance.txt'), (retardanceLinear));

imwrite((retardance/(2*255)+0.5), strcat(retardancePath, '_retardance.bmp'));
imwrite((opticalRotation/(2*255)+0.5), strcat(retardancePath, '_optical_rotation.bmp'));
imwrite((retardanceHorz/(2*255)+0.5), strcat(retardancePath, '_horizontal_retardance.bmp'));
imwrite((retardance45deg/(2*255)+0.5), strcat(retardancePath, '_45deg_retardance.bmp'));
imwrite((retardanceCirc/(2*255)+0.5), strcat(retardancePath, '_circular_retardance.bmp'));
imwrite((retardanceLinear/(2*255)+0.5), strcat(retardancePath, '_linear_retardance.bmp'));

write_colourbar_files(retardance, strcat(retardancePath, '_retardance'), [0,180]); %this axis bounds do not cover the mathematical range, though for our trials they cover the experimental range
write_colourbar_files(opticalRotation, strcat(retardancePath, '_optical_rotation'),[-180,180]);
write_colourbar_files(retardanceHorz, strcat(retardancePath, '_horizontal_retardance'),[-180,180]);
write_colourbar_files(retardance45deg, strcat(retardancePath, '_45deg_retardance'),[-180,180]);
write_colourbar_files(retardanceCirc, strcat(retardancePath, '_circular_retardance'),[-180,180]);
write_colourbar_files(retardanceLinear, strcat(retardancePath, '_linear_retardance'),[0,180]);

for i = 1:xSize
    for j=1:ySize
        if opticalRotation(j,i) < 0
            opticalRotation(j,i) = 360 + opticalRotation(j,i);
        end
        
        if retardanceHorz(j,i) < 0
            retardanceHorz(j,i) = 360 + retardanceHorz(j,i);
        end
        
        if retardance45deg(j,i) < 0
            retardance45deg(j,i) = 360 + retardance45deg(j,i);
        end
        
        if retardanceCirc(j,i) < 0
            retardanceCirc(j,i) = 360 + retardanceCirc(j,i);
        end
    end
end


write_colourbar_files(opticalRotation, strcat(retardancePath, '_optical_rotation_ADJ'),[0,360]);
write_colourbar_files(retardanceHorz, strcat(retardancePath, '_horizontal_retardance_ADJ'),[0,360]);
write_colourbar_files(retardance45deg, strcat(retardancePath, '_45deg_retardance_ADJ'),[0,360]);
write_colourbar_files(retardanceCirc, strcat(retardancePath, '_circular_retardance_ADJ'),[0,360]);

%Write Retardance Matrix files
mmRetardancePath = strcat(path, 'Retardance/MM/', file, '_retardance');
write_MM_files(retardanceMatrices, mmRetardancePath);

%End Retardance

%Write Diattenuation files

diattenPath = strcat(path, 'Diattenuation/', file);

dlmwrite(strcat(diattenPath, '_diattenuation.txt'), (diatten));
dlmwrite(strcat(diattenPath, '_linear_diattenuation.txt'), (diattenLinear));
dlmwrite(strcat(diattenPath, '_horizontal_diattenuation.txt'), (diattenHorz));
dlmwrite(strcat(diattenPath, '_45deg_diattenuation.txt'), (diatten45deg));
dlmwrite(strcat(diattenPath, '_circular_diattenuation.txt'), (diattenCirc));
dlmwrite(strcat(diattenPath, '_Q_metric.txt'), (qMetric));
%dlmwrite(strcat(diattenPath, '_max_transmitance.txt'), (maxTransmitance));
%dlmwrite(strcat(diattenPath, '_min_transmitance.txt'), (minTransmitance));

imwrite((diatten/(2)+0.5), strcat(diattenPath, '_diattenuation.bmp'));
imwrite((diattenLinear/(2)+0.5), strcat(diattenPath, '_linear_diattenuation.bmp'));
imwrite((diattenHorz/(2)+0.5), strcat(diattenPath, '_horizontal_diattenuation.bmp'));
imwrite((diatten45deg/(2)+0.5), strcat(diattenPath, '_45deg_diattenuation.bmp'));
imwrite((diattenCirc/(2)+0.5), strcat(diattenPath, '_circular_diattenuation.bmp'));
imwrite((qMetric/(2)+0.5), strcat(diattenPath, '_Q_metric.bmp'));
%imwrite((maxTransmitance/(2)+0.5), strcat(diattenPath, '_max_transmitance.bmp'));
%imwrite((minTransmitance/(2)+0.5), strcat(diattenPath, '_min_transmitance.bmp'));

write_colourbar_files(diatten, strcat(diattenPath, '_diattenuation'),[0,1]);
write_colourbar_files(diattenLinear, strcat(diattenPath, '_linear_diattenuation'),[0,1]);
write_colourbar_files(diattenHorz, strcat(diattenPath, '_horizontal_diattenuation'),[-1,1]);
write_colourbar_files(diatten45deg, strcat(diattenPath, '_45deg_diattenuation'),[-1,1]);
write_colourbar_files(diattenCirc, strcat(diattenPath, '_circular_diattenuation'),[-1,1]);
write_colourbar_files(qMetric, strcat(diattenPath, '_Q_metric'),[0,3]);
%write_colourbar_files(maxTransmitance, strcat(diattenPath, '_max_transmitance'));
%write_colourbar_files(minTransmitance, strcat(diattenPath, '_min_transmitance'));

%Write Diattenuation Matrix files
mmDiattenPath = strcat(path, 'Diattenuation/MM/', file, '_diattenuation');
write_MM_files(diattenMatrices, mmDiattenPath);

%End Diattenuation

%Write Depolarization files

depolarPath = strcat(path, 'Depolarization/', file);

%write metric results to text file

dlmwrite(strcat(depolarPath, '_polarizance.txt'), (polarizance));
dlmwrite(strcat(depolarPath, '_linear_polarizance.txt'), (polarizanceLinear));
dlmwrite(strcat(depolarPath, '_horizontal_polarizance.txt'), (polarizanceHorz));
dlmwrite(strcat(depolarPath, '_45deg_polarizance.txt'), (polarizance45deg));
dlmwrite(strcat(depolarPath, '_circular_polarizance.txt'), (polarizanceCirc));
dlmwrite(strcat(depolarPath, '_depolarization_index.txt'), (depolarizationIndex));
dlmwrite(strcat(depolarPath, '_degree_of_polarization.txt'), (degreeOfPolarization));

imwrite((polarizance/(2)+0.5), strcat(depolarPath, '_polarizance.bmp'));
imwrite((polarizanceLinear/(2)+0.5), strcat(depolarPath, '_linear_polarizance.bmp'));
imwrite((polarizanceHorz/(2)+0.5), strcat(depolarPath, '_horizontal_polarizance.bmp'));
imwrite((polarizance45deg/(2)+0.5), strcat(depolarPath, '_45deg_polariznce.bmp'));
imwrite((polarizanceCirc/(2)+0.5), strcat(depolarPath, '_circular_polarizance.bmp'));
imwrite((depolarizationIndex/(2)+0.5), strcat(depolarPath, '_depolarization_index.bmp'));
imwrite((degreeOfPolarization/(2)+0.5), strcat(depolarPath, '_degree_of_polarization.bmp'));

write_colourbar_files(polarizance, strcat(depolarPath, '_polarizance'),[0,1]);
write_colourbar_files(polarizanceLinear, strcat(depolarPath, '_linear_polarizance'),[0,1]);
write_colourbar_files(polarizanceHorz, strcat(depolarPath, '_horizontal_polarizance'),[-1,1]);
write_colourbar_files(polarizance45deg, strcat(depolarPath, '_45deg_polarizance'),[-1,1]);
write_colourbar_files(polarizanceCirc, strcat(depolarPath, '_circular_polarizance'),[-1,1]);
write_colourbar_files(depolarizationIndex, strcat(depolarPath, '_depolarization_index'),[0,1]);
write_colourbar_files(degreeOfPolarization, strcat(depolarPath, '_degree_of_polarization'),[0,1]);

%Write Deplorization Matrix files
mmDepolarPath = strcat(path, 'Depolarization/MM/', file, '_depolarization');
write_MM_files(depolarMatrices, mmDepolarPath);

%End Depolarization

%Write Additional Retardance files

additionalRetardancePath = strcat(path, 'Additional Retardance Calcs/', file);

dlmwrite(strcat(additionalRetardancePath, '_rho1.txt'), (rho1));
dlmwrite(strcat(additionalRetardancePath, '_rho1_approx.txt'), (rhoApprox1));
dlmwrite(strcat(additionalRetardancePath, '_rho2.txt'), (rho2));
dlmwrite(strcat(additionalRetardancePath, '_rho2_approx.txt'), (rhoApprox2));
dlmwrite(strcat(additionalRetardancePath, '_delta.txt'), (delta));
dlmwrite(strcat(additionalRetardancePath, '_delta_approx.txt'), (deltaApprox));
dlmwrite(strcat(additionalRetardancePath, '_theta.txt'), (theta));
dlmwrite(strcat(additionalRetardancePath, '_theta_approx.txt'), (thetaApprox));

imwrite((rho1/(2*255)+0.5), strcat(additionalRetardancePath, '_rho1.bmp'));
imwrite((rhoApprox1/(2*255)+0.5), strcat(additionalRetardancePath, '_rho1_approx.bmp'));
imwrite((rho2/(2*255)+0.5), strcat(additionalRetardancePath, '_rho2.bmp'));
imwrite((rhoApprox2/(2*255)+0.5), strcat(additionalRetardancePath, '_rho2_approx.bmp'));
imwrite((delta/(2*255)+0.5), strcat(additionalRetardancePath, '_delta.bmp'));
imwrite((deltaApprox/(2*255)+0.5), strcat(additionalRetardancePath, '_delta_approx.bmp'));
imwrite((theta/(2*255)+0.5), strcat(additionalRetardancePath, '_theta.bmp'));
imwrite((thetaApprox/(2*255)+0.5), strcat(additionalRetardancePath, '_theta_approx.bmp'));


write_colourbar_files(rho1, strcat(additionalRetardancePath, '_rho1'), [0,90]);
write_colourbar_files(rhoApprox1, strcat(additionalRetardancePath, '_rho1_approx'), [-1,1]);
write_colourbar_files(rho2, strcat(additionalRetardancePath, '_rho2'), [-90,90]);
write_colourbar_files(rhoApprox2, strcat(additionalRetardancePath, '_rho2_approx'), [-1,1]);
write_colourbar_files(delta, strcat(additionalRetardancePath, '_delta'), [0,180]);
write_colourbar_files(deltaApprox, strcat(additionalRetardancePath, '_delta_approx'), [-1,1]);
write_colourbar_files(theta, strcat(additionalRetardancePath, '_theta'), [-90,90]);
write_colourbar_files(thetaApprox, strcat(additionalRetardancePath, '_theta_approx'), [-1,1]);

%write_colourbar_files(devriesMetric, strcat(additionalRetardancePath, '_devries_metric'), [0,1]);
%write_colourbar_files(devriesMetricSemi, strcat(additionalRetardancePath, '_devries_metric_semi'), [0,1]);

%End Additional Retardance

disp('Complete!');
disp('Analysis Complete');
disp('');