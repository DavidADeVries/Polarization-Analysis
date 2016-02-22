function output = MM_full_analysis_for_pos_neg(path, file)

% ** VERSION 1.0.0 ** %

% Returns all the spatially resolved parameters for use in KS-Tests between
% the postive and negative areas

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
disp(path);

filename = strcat(path,file);

%CONVENTIONS:
%Vertical <-> y <-> j
%Horizontal <-> x <-> i
%MM(y,x) <-> MM(j,i)

disp('Creating Output Directories...');

make_MM_output_folders(strcat(path, 'MM - Pixelwise Norm'));
make_MM_output_folders(strcat(path, 'MM - Max m_00 Norm'));

make_output_folders(strcat(path, 'Polarizance'));
make_output_folders(strcat(path, 'Diattenuation'));
make_output_folders(strcat(path, 'DOP, DI, and Q Metric'));
make_output_folders(strcat(path, 'Retardance'));
make_output_folders(strcat(path, 'Related Retardance Metrics'));

make_MM_output_folders(strcat(path, 'Retardance/MM'));
make_MM_output_folders(strcat(path, 'Diattenuation/MM'));
make_MM_output_folders(strcat(path, 'Polarizance/MM'));

% mkdir(strcat(path, 'Stokes'));
mkdir(strcat(path, 'Metrics and Histograms'));
mkdir(strcat(path, 'Metrics and Histograms/Histograms'));


disp('Complete!');

disp('Computing Mueller Matrices...');
%Compute the Mueller Matrices
[MM_pixelwise_norm, MM_m00_max_norm] = compute_MM_corrected_super_old(filename);

%Get horizontal and vertical dimensions
imageSizes = size(MM_pixelwise_norm);
ySize = imageSizes(1);
xSize = imageSizes(2);

disp('Complete!');
disp('Writing Mueller Matrix Files...');

write_MM_files(MM_pixelwise_norm, strcat(path,'MM - Pixelwise Norm/'), file); %both normalizations are outputted
write_MM_files(MM_m00_max_norm, strcat(path,'MM - Max m_00 Norm/'), file);

%remove!
%MM_pixelwise_norm = MM_m00_max_norm;

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
    
    reshape(retardance,1,m); % circular stats
    reshape(retardanceLinear,1,m); 
    reshape(retardanceHorz,1,m); 
    reshape(retardance45deg,1,m); 
    reshape(retardanceCirc,1,m);
    reshape(opticalRotation,1,m);
    
%     abs(reshape(retardance,1,m)); %absolute stats DO NOT USE!
%     abs(reshape(retardanceLinear,1,m)); 
%     abs(reshape(retardanceHorz,1,m)); 
%     abs(reshape(retardance45deg,1,m)); 
%     abs(reshape(retardanceCirc,1,m));
%     abs(reshape(opticalRotation,1,m));
    
    reshape(retardance,1,m); % normal stats
    reshape(retardanceLinear,1,m); 
    reshape(retardanceHorz,1,m); 
    reshape(retardance45deg,1,m); 
    reshape(retardanceCirc,1,m);
    reshape(opticalRotation,1,m);
    
    reshape(depolarizationIndex,1,m);
    reshape(degreeOfPolarization,1,m);
    reshape(qMetric,1,m);
    
    reshape(rho1,1,m); %circular stats
    reshape(rho2,1,m);
    reshape(theta,1,m);
    reshape(delta,1,m);
    
%     abs(reshape(rho1,1,m));  %absolute stats DO NOT USE!
%     abs(reshape(rhoApprox1,1,m));
%     abs(reshape(rho2,1,m));
%     abs(reshape(rhoApprox2,1,m));
%     abs(reshape(theta,1,m));
%     abs(reshape(thetaApprox,1,m));
%     abs(reshape(delta,1,m));
%     abs(reshape(deltaApprox,1,m));
    
    reshape(rho1,1,m); %normal stats    
    reshape(rho2,1,m);
    reshape(theta,1,m);
    reshape(delta,1,m);
    
    reshape(rhoApprox1,1,m);
    reshape(rhoApprox2,1,m);
    reshape(thetaApprox,1,m);
    reshape(deltaApprox,1,m);
    ];

filepath = strcat(path, 'Metrics and Histograms/', file, '_metrics.csv');

write_metrics_file(exhaustive_metric_labels(),metric_datasets,filepath);

% End writing metrics file

% Write Histograms

figure;
set(gcf,'Visible','off');

hist(reshape(diatten,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_diattenuation_histogram.png'));
hist(reshape(diattenLinear,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_linear_diattenuation_histogram.png'));
hist(reshape(diattenHorz,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_horizontal_diattenuation_histogram.png'));
hist(reshape(diatten45deg,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_45deg_diattenuation_histogram.png'));
hist(reshape(diattenCirc,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_circular_diattenuation_histogram.png'));

hist(reshape(polarizance,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_polarizance_histogram.png'));
hist(reshape(polarizanceLinear,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_linear_polarizance_histogram.png'));
hist(reshape(polarizanceHorz,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_horizontal_polarizance_histogram.png'));
hist(reshape(polarizance45deg,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_45deg_polarizance_histogram.png'));
hist(reshape(polarizanceCirc,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_circular_polarizance_histogram.png'));

hist(reshape(retardance,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_retardance_histogram.png'));
hist(reshape(retardanceLinear,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_linear_retardance_histogram.png'));
hist(reshape(retardanceHorz,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_horizontal_retardance_histogram.png'));
hist(reshape(retardance45deg,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_45deg_retardance_histogram.png'));
hist(reshape(retardanceCirc,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_circular_retardance_histogram.png'));

hist(reshape(rho1,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_rho1_histogram.png'));
% hist(reshape(rhoApprox1,1,m),100);
% saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_rho1_approx_histogram.png'));
hist(reshape(rho2,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_rho2_histogram.png'));
% hist(reshape(rhoApprox2,1,m),100);
% saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_rho2_approx_histogram.png'));
hist(reshape(delta,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_delta_histogram.png'));
% hist(reshape(deltaApprox,1,m),100);
% saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_delta_approx_histogram.png'));
hist(reshape(theta,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_theta_histogram.png'));
% hist(reshape(thetaApprox,1,m),100);
% saveas(gcf, strcat(path, 'Metrics and Histograms/', file, '_theta_approx_histogram.png'));


hist(reshape(opticalRotation,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_optical_rotation_histogram.png'));
hist(reshape(depolarizationIndex,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_depolarization_index_histogram.png'));
hist(reshape(degreeOfPolarization,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_degree_of_polarization_histogram.png'));
hist(reshape(qMetric,1,m),100);
saveas(gcf, strcat(path, 'Metrics and Histograms/Histograms/', file, '_Q_metric_histogram.png'));

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

retardancePath = strcat(path, 'Retardance/');

csvPath = strcat(retardancePath, 'CSVs/', file);

dlmwrite(strcat(csvPath, '_retardance.csv'), (retardance),'precision',7);
dlmwrite(strcat(csvPath, '_optical_rotation.csv'), (opticalRotation),'precision',7);
dlmwrite(strcat(csvPath, '_horizontal_retardance.csv'), (retardanceHorz),'precision',7);
dlmwrite(strcat(csvPath, '_45deg_retardance.csv'), (retardance45deg),'precision',7);
dlmwrite(strcat(csvPath, '_circular_retardance.csv'), (retardanceCirc),'precision',7);
dlmwrite(strcat(csvPath, '_linear_retardance.csv'), (retardanceLinear),'precision',7);

greyscaleNoScalePath = strcat(retardancePath, '/Greyscale [No Scalebar]/', file);

imwrite(scale_for_bmp(retardance, 0, 180), strcat(greyscaleNoScalePath, '_retardance.bmp'));
imwrite(scale_for_bmp(opticalRotation, 0, 180), strcat(greyscaleNoScalePath, '_optical_rotation.bmp'));
imwrite(scale_for_bmp(retardanceHorz, -180, 180), strcat(greyscaleNoScalePath, '_horizontal_retardance.bmp'));
imwrite(scale_for_bmp(retardance45deg, -180, 180), strcat(greyscaleNoScalePath, '_45deg_retardance.bmp'));
imwrite(scale_for_bmp(retardanceCirc, -180, 180), strcat(greyscaleNoScalePath, '_circular_retardance.bmp'));
imwrite(scale_for_bmp(retardanceLinear, -180, 180), strcat(greyscaleNoScalePath, '_linear_retardance.bmp'));

write_colourbar_files(retardance, retardancePath, strcat(file, '_retardance'), [0,180]); %this axis bounds do not cover the mathematical range, though for our trials they cover the experimental range
write_colourbar_files(retardanceLinear, retardancePath, strcat(file, '_linear_retardance'), [0,180]);
write_colourbar_files(retardanceHorz, retardancePath, strcat(file, '_horizontal_retardance'), [-180,180]);
write_colourbar_files(retardance45deg, retardancePath, strcat(file, '_45deg_retardance'), [-180,180]);
write_colourbar_files(retardanceCirc, retardancePath, strcat(file, '_circular_retardance'), [-180,180]);
write_colourbar_files(opticalRotation, retardancePath, strcat(file, '_optical_rotation'), [-180,180]);


%Write Retardance Matrix files
write_MM_files(retardanceMatrices, strcat(path, 'Retardance/MM/'), strcat(file,'_retardance'));

%End Retardance

% Write DOP, DI, Q files

dopPath = strcat(path, 'DOP, DI, and Q Metric/');

csvPath = strcat(dopPath, 'CSVs/', file);

dlmwrite(strcat(csvPath, '_depolarization_index.csv'), (depolarizationIndex),'precision',7);
dlmwrite(strcat(csvPath, '_degree_of_polarization.csv'), (degreeOfPolarization),'precision',7);
dlmwrite(strcat(csvPath, '_Q_metric.csv'), (qMetric),'precision',7);

greyscaleNoScalePath = strcat(dopPath, '/Greyscale [No Scalebar]/', file);

imwrite(scale_for_bmp(depolarizationIndex, 0, 1), strcat(greyscaleNoScalePath, '_depolarization_index.bmp'));
imwrite(scale_for_bmp(degreeOfPolarization, 0, 1), strcat(greyscaleNoScalePath, '_degree_of_polarization.bmp'));
imwrite(scale_for_bmp(qMetric, 0, 3), strcat(greyscaleNoScalePath, '_Q_metric.bmp'));

write_colourbar_files(depolarizationIndex, dopPath, strcat(file, '_depolarization_index'),[0,1]);
write_colourbar_files(degreeOfPolarization, dopPath, strcat(file, '_degree_of_polarization'),[0,1]);
write_colourbar_files(qMetric, dopPath, strcat(file, '_Q_metric'),[0,3]);

%end DOP, DI, Q metrics

%Write Diattenuation files

diattenPath = strcat(path, 'Diattenuation/');

csvPath = strcat(diattenPath, 'CSVs/', file);

dlmwrite(strcat(csvPath, '_diattenuation.csv'), (diatten),'precision',7);
dlmwrite(strcat(csvPath, '_linear_diattenuation.csv'), (diattenLinear),'precision',7);
dlmwrite(strcat(csvPath, '_horizontal_diattenuation.csv'), (diattenHorz),'precision',7);
dlmwrite(strcat(csvPath, '_45deg_diattenuation.csv'), (diatten45deg),'precision',7);
dlmwrite(strcat(csvPath, '_circular_diattenuation.csv'), (diattenCirc),'precision',7);
%dlmwrite(strcat(diattenPath, '_max_transmitance.txt'), (maxTransmitance));
%dlmwrite(strcat(diattenPath, '_min_transmitance.txt'), (minTransmitance));

greyscaleNoScalePath = strcat(diattenPath, '/Greyscale [No Scalebar]/', file);

imwrite(scale_for_bmp(diatten, 0, 1), strcat(greyscaleNoScalePath, '_diattenuation.bmp'));
imwrite(scale_for_bmp(diattenLinear, 0, 1), strcat(greyscaleNoScalePath, '_linear_diattenuation.bmp'));
imwrite(scale_for_bmp(diattenHorz, -1, 1), strcat(greyscaleNoScalePath, '_horizontal_diattenuation.bmp'));
imwrite(scale_for_bmp(diatten45deg, -1, 1), strcat(greyscaleNoScalePath, '_45deg_diattenuation.bmp'));
imwrite(scale_for_bmp(diattenCirc, -1, 1), strcat(greyscaleNoScalePath, '_circular_diattenuation.bmp'));
%imwrite((maxTransmitance/(2)+0.5), strcat(diattenPath, '_max_transmitance.bmp'));
%imwrite((minTransmitance/(2)+0.5), strcat(diattenPath, '_min_transmitance.bmp'));

write_colourbar_files(diatten, diattenPath, strcat(file, '_diattenuation'),[0,1]);
write_colourbar_files(diattenLinear, diattenPath, strcat(file, '_linear_diattenuation'),[0,1]);
write_colourbar_files(diattenHorz, diattenPath, strcat(file, '_horizontal_diattenuation'),[-1,1]);
write_colourbar_files(diatten45deg, diattenPath, strcat(file, '_45deg_diattenuation'),[-1,1]);
write_colourbar_files(diattenCirc, diattenPath, strcat(file, '_circular_diattenuation'),[-1,1]);
%write_colourbar_files(maxTransmitance, strcat(diattenPath, '_max_transmitance'));
%write_colourbar_files(minTransmitance, strcat(diattenPath, '_min_transmitance'));

%Write Diattenuation Matrix files
write_MM_files(diattenMatrices, strcat(path, 'Diattenuation/MM/'), strcat(file,'_diattenuation'));

%End Diattenuation

%Write Polarizance files

polarizancePath = strcat(path, 'Polarizance/');

%write metric results to text file

csvPath = strcat(polarizancePath, 'CSVs/', file);

dlmwrite(strcat(csvPath, '_polarizance.csv'), (polarizance),'precision',7);
dlmwrite(strcat(csvPath, '_linear_polarizance.csv'), (polarizanceLinear),'precision',7);
dlmwrite(strcat(csvPath, '_horizontal_polarizance.csv'), (polarizanceHorz),'precision',7);
dlmwrite(strcat(csvPath, '_45deg_polarizance.csv'), (polarizance45deg),'precision',7);
dlmwrite(strcat(csvPath, '_circular_polarizance.csv'), (polarizanceCirc),'precision',7);

greyscaleNoScalePath = strcat(polarizancePath, '/Greyscale [No Scalebar]/', file);

imwrite(scale_for_bmp(polarizance, 0, 1), strcat(greyscaleNoScalePath, '_polarizance.bmp'));
imwrite(scale_for_bmp(polarizanceLinear, 0, 1), strcat(greyscaleNoScalePath, '_linear_polarizance.bmp'));
imwrite(scale_for_bmp(polarizanceHorz, -1, 1), strcat(greyscaleNoScalePath, '_horizontal_polarizance.bmp'));
imwrite(scale_for_bmp(polarizance45deg, -1, 1), strcat(greyscaleNoScalePath, '_45deg_polariznce.bmp'));
imwrite(scale_for_bmp(polarizanceCirc, -1, 1), strcat(greyscaleNoScalePath, '_circular_polarizance.bmp'));

write_colourbar_files(polarizance, polarizancePath, strcat(file, '_polarizance'),[0,1]);
write_colourbar_files(polarizanceLinear, polarizancePath, strcat(file, '_linear_polarizance'),[0,1]);
write_colourbar_files(polarizanceHorz, polarizancePath, strcat(file, '_horizontal_polarizance'),[-1,1]);
write_colourbar_files(polarizance45deg, polarizancePath, strcat(file, '_45deg_polarizance'),[-1,1]);
write_colourbar_files(polarizanceCirc, polarizancePath, strcat(file, '_circular_polarizance'),[-1,1]);


%Write Deplorization Matrix files
write_MM_files(depolarMatrices, strcat(path, 'Polarizance/MM/'), strcat(file,'_polarizance'));


%End Depolarization

%Write Related Retardance files

relatedRetardancePath = strcat(path, 'Related Retardance Metrics/');

csvPath = strcat(relatedRetardancePath, 'CSVs/', file);

dlmwrite(strcat(csvPath, '_rho1.csv'), (rho1),'precision',7);
dlmwrite(strcat(csvPath, '_rho2.csv'), (rho2),'precision',7);
dlmwrite(strcat(csvPath, '_theta.csv'), (theta),'precision',7);
dlmwrite(strcat(csvPath, '_delta.csv'), (delta),'precision',7);
dlmwrite(strcat(csvPath, '_rho1_approx.csv'), (rhoApprox1),'precision',7);
dlmwrite(strcat(csvPath, '_rho2_approx.csv'), (rhoApprox2),'precision',7);
dlmwrite(strcat(csvPath, '_theta_approx.csv'), (thetaApprox),'precision',7);
dlmwrite(strcat(csvPath, '_delta_approx.csv'), (deltaApprox),'precision',7);

greyscaleNoScalePath = strcat(relatedRetardancePath, '/Greyscale [No Scalebar]/', file);

imwrite(scale_for_bmp(rho1, 0, 90), strcat(greyscaleNoScalePath, '_rho1.bmp'));
imwrite(scale_for_bmp(rho2, -90, 90), strcat(greyscaleNoScalePath, '_rho2.bmp'));
imwrite(scale_for_bmp(theta, -90, 90), strcat(greyscaleNoScalePath, '_theta.bmp'));
imwrite(scale_for_bmp(delta, 0, 180), strcat(greyscaleNoScalePath, '_delta.bmp'));
imwrite(scale_for_bmp(rhoApprox1, -1, 1), strcat(greyscaleNoScalePath, '_rho1_approx.bmp'));
imwrite(scale_for_bmp(rhoApprox2, -1, 1), strcat(greyscaleNoScalePath, '_rho2_approx.bmp'));
imwrite(scale_for_bmp(thetaApprox, -1, 1), strcat(greyscaleNoScalePath, '_theta_approx.bmp'));
imwrite(scale_for_bmp(deltaApprox, -1, 1), strcat(greyscaleNoScalePath, '_delta_approx.bmp'));


write_colourbar_files(rho1, relatedRetardancePath, strcat(file, '_rho1'), [0,90]);
write_colourbar_files(rho2, relatedRetardancePath, strcat(file, '_rho2'), [-90,90]);
write_colourbar_files(theta, relatedRetardancePath, strcat(file, '_theta'), [-90,90]);
write_colourbar_files(delta, relatedRetardancePath, strcat(file, '_delta'), [0,180]);
write_colourbar_files(rhoApprox1, relatedRetardancePath, strcat(file, '_rho1_approx'), [-1,1]);
write_colourbar_files(rhoApprox2, relatedRetardancePath, strcat(file, '_rho2_approx'), [-1,1]);
write_colourbar_files(thetaApprox, relatedRetardancePath, strcat(file, '_theta_approx'), [-1,1]);
write_colourbar_files(deltaApprox, relatedRetardancePath, strcat(file, '_delta_approx'), [-1,1]);

%write_colourbar_files(devriesMetric, strcat(additionalRetardancePath, '_devries_metric'), [0,1]);
%write_colourbar_files(devriesMetricSemi, strcat(additionalRetardancePath, '_devries_metric_semi'), [0,1]);

%End Related Retardance


%get output ready
dims = size(diatten);
numMetrics = height(standard_metric_labels);
output = zeros(numMetrics, dims(1), dims(2));

output(1,:,:) = diatten;
output(2,:,:) = diattenLinear;
output(3,:,:) = diattenHorz;
output(4,:,:) = diatten45deg;
output(5,:,:) = diattenCirc;
output(6,:,:) = polarizance;
output(7,:,:) = polarizanceLinear;
output(8,:,:) = polarizanceHorz;
output(9,:,:) = polarizance45deg;
output(10,:,:) = polarizanceCirc;
output(11,:,:) = retardance;
output(12,:,:) = retardanceLinear;
output(13,:,:) = retardanceHorz;
output(14,:,:) = retardance45deg;
output(15,:,:) = retardanceCirc;
output(16,:,:) = opticalRotation;
output(17,:,:) = depolarizationIndex;
output(18,:,:) = degreeOfPolarization;
output(19,:,:) = qMetric;
output(20,:,:) = rho1;
output(22,:,:) = rho2;
output(24,:,:) = theta;
output(26,:,:) = delta;
output(21,:,:) = rhoApprox1;
output(23,:,:) = rhoApprox2;
output(25,:,:) = thetaApprox;
output(27,:,:) = deltaApprox;

disp('Complete!');
disp('Analysis Complete');
disp('');