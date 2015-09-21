function[] = MM_full_analysis_reverse(path, file)

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

mkdir(strcat(path, 'MM'));
mkdir(strcat(path, 'Depolarization'));
mkdir(strcat(path, 'Depolarization/MM'));
mkdir(strcat(path, 'Diattenuation'));
mkdir(strcat(path, 'Diattenuation/MM'));
mkdir(strcat(path, 'Retardance'));
mkdir(strcat(path, 'Retardance/MM'));
mkdir(strcat(path, 'Alignment'));

disp('Complete!');

% disp('Aligning Images...');
% %Align images. Have image matrices returned.
% alignedMatrices;
% disp('Complete!');
% disp('Writing Aligned Image Files...');
% 
% orientations = ['45','00','30','60'];
% alignPath = strcat(path, 'Alignment/', file, '_registered_');
% 
% for i=1:4
%     for j=1:4
%         orientation = strcat(alignPath
%         dlmwrite(strcat(path, 'Alignment/', file, '_registered_', orientations(i), orientations(j)), alignMatrices(j,i))
%         imwrite(regImage{i, 1}, strcat('reg_',files(i).name,ext));
%     end
% end
% disp('Complete!');
disp('Computing Mueller Matrices...');
%Compute the Mueller Matrices
complete_MM = compute_MM(filename);

%Get horizontal and vertical dimensions
imageSizes = size(complete_MM);
ySize = imageSizes(1);
xSize = imageSizes(2);

disp('Complete!');
disp('Writing Mueller Matrix Files...');

write_MM_files(complete_MM, strcat(path,'MM/',file));

disp('Complete!');
disp('Validating Mueller Matrices for Analysis...');

%Ensure Valid MMs
for i=1:4
    for j=1:4
        complete_MM(:,:,j,i) = nonzero(complete_MM(:,:,j,i));
    end
end

disp('Complete!');
disp('Allocating Memory...');

%Return Matrices:
retardance              = zeros(ySize,xSize);
opticalRotation         = zeros(ySize,xSize);
linearRetardance        = zeros(ySize,xSize);
retardanceHorz          = zeros(ySize,xSize);
retardance45deg         = zeros(ySize,xSize);
retardanceCirc          = zeros(ySize,xSize);
diatten                 = zeros(ySize,xSize);
diattenLinear           = zeros(ySize,xSize);
diattenHorz             = zeros(ySize,xSize);
diatten45deg            = zeros(ySize,xSize);
diattenCirc             = zeros(ySize,xSize);
polarizance             = zeros(ySize,xSize);
polarizanceHorz         = zeros(ySize,xSize);
polarizance45deg        = zeros(ySize,xSize);
polarizanceCirc         = zeros(ySize,xSize);
depolarizationIndex     = zeros(ySize,xSize);
degreeOfPolarization    = zeros(ySize,xSize);
qMetric                 = zeros(ySize,xSize);
maxTransmitance         = zeros(ySize,xSize);
minTransmitance         = zeros(ySize,xSize);
retardanceMatrices      = zeros(ySize,xSize,4,4);
diattenMatrices         = zeros(ySize,xSize,4,4);
depolarMatrices         = zeros(ySize,xSize,4,4);

MM = zeros(4);
mm = zeros(3);
I = eye(3);

disp('Complete!');
disp('Computing Metrics...');

%Loop through each pixel
for pix_i = 1:xSize
    % insert by column, not individual indices to speed up memory accesses
    retardanceCol       = zeros(ySize, 1);
    opticalRotationCol  = zeros(ySize, 1);
    linearRetardanceCol = zeros(ySize, 1);
    retardanceHorzCol   = zeros(ySize, 1);
    retardance45degCol  = zeros(ySize, 1);
    retardanceCircCol   = zeros(ySize, 1);
    diattenCol          = zeros(ySize, 1);
    diattenLinearCol    = zeros(ySize, 1);
    diattenHorzCol      = zeros(ySize, 1);
    diatten45degCol     = zeros(ySize, 1);
    diattenCircCol      = zeros(ySize, 1);
    polarizanceCol      = zeros(ySize, 1);
    polarizanceHorzCol  = zeros(ySize, 1);
    polarizance45degCol = zeros(ySize, 1);
    polarizanceCircCol  = zeros(ySize, 1);
    depolarizationIndexCol   = zeros(ySize, 1);
    degreeOfPolarizationCol  = zeros(ySize, 1);
    qMetricCol          = zeros(ySize, 1);
    maxTransmitanceCol  = zeros(ySize,1);
    minTransmitanceCol  = zeros(ySize,1);
    retardanceMatricesCol   = zeros(ySize,1,4,4);
    diattenMatricesCol      = zeros(ySize,1,4,4);
    depolarMatricesCol      = zeros(ySize,1,4,4);
    
    for pix_j = 1: ySize
        
        %Get the MM for the pixel (j,i) in question
                
        for i = 1:4,
            for j = 1:4,
                MM(j,i) = complete_MM(pix_j,pix_i,j,i);
            end
        end
                        
        %Submatrix of original Mueller Matrix Elements
        
        mm = [  MM(2,2)  MM(2,3) MM(2,4);
                MM(3,2)  MM(3,3) MM(3,4);
                MM(4,2)  MM(4,3) MM(4,4)];
        
        %Polarizance Vector
        
        P = [MM(2,1); MM(3,1); MM(4,1);]/MM(1,1);
        
        %Diattenuation Vector
        
        D = [MM(1,2); MM(1,3); MM(1,4);]/MM(1,1);
        
        %Polarizance Vector Magnitude Squared
        
        P_mag_sqr = (1/MM(1,1)^2) .* (((MM(2,1))^2) + ((MM(3,1))^2) + ((MM(4,1))^2));
        
        %Diattenuation Vector for Reverse Method (Eqn 17 in Ossikovski
        %Paper)
        
        D_delta_r = (D - (mm * P)) / (1 - P_mag_sqr);
        
        I = eye(3);
        
        m_P = (sqrt(1 - P_mag_sqr) * I) + ((1 - sqrt(1 - P_mag_sqr)) .* ((1/P_mag_sqr).*(P * P')));
        
        M_D = MM(1,1) .* [1 P(1) P(2) P(3); P(1) m_P(1,1) m_P(1,2) m_P(1,3); P(2) m_P(2,1) m_P(2,2) m_P(2,3); P(3) m_P(3,1) m_P(3,2) m_P(3,3)];
        
        M_prime = inv(M_D) * MM;
        
        m_prime = [ M_prime(2,2) M_prime(2,3) M_prime(2,4);
                    M_prime(3,2) M_prime(3,3) M_prime(3,4);
                    M_prime(4,2) M_prime(4,3) M_prime(4,4);];
                
        eigenvalues = eig(m_prime' * m_prime);
        
        m_delta_r = inv((m_prime' * m_prime) + ((sqrt(eig(1)*eig(2)) + sqrt(eig(1)*eig(2)) + sqrt(eig(2)*eig(3))) .* I)) * (((sqrt(eig(1)) + sqrt(eig(2)) + sqrt(eig(3))) .* (m_prime' * m_prime)) + (sqrt(eig(1) * eig(2) * eig(3)) .* I));
        
        if (det(m_prime) < 0)
            m_delta_r = -m_delta_r;
        end
        
        M_delta =   [   1 D_delta_r(1)   D_delta_r(2)   D_delta_r(3);
                        0 m_delta_r(1,1) m_delta_r(1,2) m_delta_r(1,3);
                        0 m_delta_r(2,1) m_delta_r(2,2) m_delta_r(2,3);
                        0 m_delta_r(3,1) m_delta_r(3,2) m_delta_r(3,3);];
        
        M_R = M_prime * inv(M_delta);
                
        %STORE CALCULATED VALUES AT PIXEL TO RETURN MATRICES:
        
        %Calculates the retardance from the retardation mueller matrix according to
        %equation (17).
        
        radToDeg = 180/pi;
        
        MM_sqr = MM.^2; %each index squared, not MM*MM
        
        %questionable:
        M_R = real(M_R);
        
        R = acos((trace(M_R)/2)-1);       
        
        retardanceCol(pix_j, 1) = real(R*radToDeg);
        opticalRotationCol  (pix_j, 1) = real(atan((M_R(4,3)-M_R(3,4))/(M_R(3,3)+M_R(4,4)))*radToDeg);
        linearRetardanceCol (pix_j, 1) = real(acos(((((M_R(3,3)+M_R(4,4)).^2)+((M_R(4,3)-M_R(3,4)).^2)).^0.5)-1)*radToDeg);
        retardanceHorzCol   (pix_j, 1) = real((R/(2*sin(R))).*(M_R(3,4) - M_R(4,3))); %according to Chipman eqn (17)
        retardance45degCol  (pix_j, 1) = real((R/(2*sin(R))).*(M_R(4,2) - M_R(2,4))); %according to Chipman eqn (17)
        retardanceCircCol   (pix_j, 1) = real((R/(2*sin(R))).*(M_R(2,3) - M_R(3,2))); %according to Chipman eqn (17)
        
        diattenCol          (pix_j, 1) = sqrt(((M_delta(1,2))^2) + ((M_delta(1,3))^2) + ((M_delta(1,4))^2)); %range: 0..1
        diattenLinearCol    (pix_j, 1) = sqrt((M_delta(1,2)^2) + (M_delta(1,3)^2));
        diattenHorzCol      (pix_j, 1) = M_delta(1,2); %range: -1..1
        diatten45degCol     (pix_j, 1) = M_delta(1,3); %range: -1..1
        diattenCircCol      (pix_j, 1) = M_delta(1,4); %range: -1..1
        
        polarizanceCol      (pix_j, 1) = sqrt(((M_D(1,2))^2) + ((M_D(1,3))^2) + ((M_D(1,4))^2)); %range: 0..1
        polarizanceHorzCol  (pix_j, 1) = M_D(1,2); %range: -1..1
        polarizance45degCol (pix_j, 1) = M_D(1,3); %range: -1..1
        polarizanceCircCol  (pix_j, 1) = M_D(1,4); %range: -1..1
        
        depolarizationIndexCol   (pix_j, 1) = sqrt(sum(sum(MM_sqr)) - MM_sqr(1,1))./(sqrt(3).*MM(1,1)); %Depolarization Index as outlined in the Handbook of Optics sect. 14.28
        degreeOfPolarizationCol  (pix_j, 1) = 1 - depolarizationIndexCol(pix_j, 1); %DOP as per Fran's code
        
        qMetricCol          (pix_j, 1) = (3*(depolarizationIndexCol(pix_j,1)^2) - (diattenLinearCol(pix_j,1))) / (1 - depolarizationIndexCol(pix_j,1)^2);
        
        maxTransmitanceCol  (pix_j, 1) = MM(1,1).*(1 + diattenCol(pix_j,1));
        minTransmitanceCol  (pix_j, 1) = MM(1,1).*(1 - diattenCol(pix_j,1));
                
        for i=1:4
           for j=1:4
               retardanceMatricesCol    (pix_j,1,j,i) = M_R(j,i);
               diattenMatricesCol       (pix_j,1,j,i) = real(M_D(j,i));
               depolarMatricesCol       (pix_j,1,j,i) = real(M_delta(j,i));
           end
        end
                        
    end
    
    retardance(:,pix_i)       = retardanceCol;
    opticalRotation(:,pix_i)  = opticalRotationCol;
    linearRetardance(:,pix_i) = linearRetardanceCol;
    retardanceHorz(:,pix_i)   = retardanceHorzCol;
    retardance45deg(:,pix_i)  = retardance45degCol;
    retardanceCirc(:,pix_i)   = retardanceCircCol;
    diatten(:,pix_i)          = diattenCol;
    diattenLinear(:,pix_i)    = diattenLinearCol;
    diattenHorz(:,pix_i)      = diattenHorzCol;
    diatten45deg(:,pix_i)     = diatten45degCol;
    diattenCirc(:,pix_i)      = diattenCircCol;
    polarizance(:,pix_i)      = polarizanceCol;
    polarizanceHorz(:,pix_i)  = polarizanceHorzCol;
    polarizance45deg(:,pix_i) = polarizance45degCol;
    polarizanceCirc(:,pix_i)  = polarizanceCircCol;
    depolarizationIndex(:,pix_i)   = depolarizationIndexCol;
    degreeOfPolarization(:,pix_i)  = degreeOfPolarizationCol;
    qMetric(:,pix_i)          = qMetricCol;
    maxTransmitance(:,pix_i)  = maxTransmitanceCol;
    minTransmitance(:,pix_i)  = minTransmitanceCol;
    retardanceMatrices   (:, pix_i,:,:) = retardanceMatricesCol;
    diattenMatrices      (:, pix_i,:,:) = diattenMatricesCol;
    depolarMatrices      (:, pix_i,:,:) = depolarMatricesCol;
    
end

disp('Complete!');
disp('Writing Analysis Files...');

%Write Retardance files

retardancePath = strcat(path, 'Retardance/', file);

%write metric results to text file

maxRetardance=max(max(retardance));
maxOpticalRotation=max(max(opticalRotation));
maxLinearRetardance=max(max(linearRetardance));
maxRetardanceHorz=max(max(retardanceHorz));
maxRetardance45deg=max(max(retardance45deg));
maxRetardanceCirc=max(max(retardanceCirc));

fileId = fopen(strcat(retardancePath, '_retardance_metrics.txt'), 'w');
fprintf(fileId, 'Max Retardance: %6.4f\r\n', maxRetardance);
fprintf(fileId, 'Max Optical Rotation: %6.4f\r\n', maxOpticalRotation);
fprintf(fileId, 'Max Linear Retardance: %6.4f\r\n', maxLinearRetardance);
fprintf(fileId, 'Max Horizontal Retardance: %6.4f\r\n', maxRetardanceHorz);
fprintf(fileId, 'Max 45 deg Retardance: %6.4f\r\n', maxRetardance45deg);
fprintf(fileId, 'Max Circular Retardance: %6.4f\r\n', maxRetardanceCirc);
fclose(fileId);

dlmwrite(strcat(retardancePath, '_retardance.txt'), (retardance));
dlmwrite(strcat(retardancePath, '_optical_rotation.txt'), (opticalRotation));
dlmwrite(strcat(retardancePath, '_linear_retardance.txt'), (linearRetardance));
dlmwrite(strcat(retardancePath, '_horizontal_retardance.txt'), (retardanceHorz));
dlmwrite(strcat(retardancePath, '_45deg_retardance.txt'), (retardance45deg));
dlmwrite(strcat(retardancePath, '_circular_ retardance.txt'), (retardanceCirc));

imwrite((retardance/(2*255)+0.5), strcat(retardancePath, '_retardance.bmp'));
imwrite((opticalRotation/(2*255)+0.5), strcat(retardancePath, '_optical_rotation.bmp'));
imwrite((linearRetardance/(2*255)+0.5), strcat(retardancePath, '_linear_retardance.bmp'));
imwrite((retardanceHorz/(2*255)+0.5), strcat(retardancePath, '_horizontal_retardance.bmp'));
imwrite((retardance45deg/(2*255)+0.5), strcat(retardancePath, '_45deg_retardance.bmp'));
imwrite((retardanceCirc/(2*255)+0.5), strcat(retardancePath, '_circular_retardance.bmp'));

write_colourbar_files(retardance, strcat(retardancePath, '_retardance'));
write_colourbar_files(opticalRotation, strcat(retardancePath, '_optical_rotation'));
write_colourbar_files(linearRetardance, strcat(retardancePath, '_linear_retardance'));
write_colourbar_files(retardanceHorz, strcat(retardancePath, '_horizontal_retardance'));
write_colourbar_files(retardance45deg, strcat(retardancePath, '_45deg_retardance'));
write_colourbar_files(retardanceCirc, strcat(retardancePath, '_circular_retardance'));

%Write Retardance Matrix files
mmRetardancePath = strcat(path, 'Retardance/MM/', file, '_retardance');
write_MM_files(retardanceMatrices, mmRetardancePath);

%Write Diattenuation files

diattenPath = strcat(path, 'Diattenuation/', file);

%write metric results to text file

maxDiatten = max(max(diatten));
maxDiattenLinear = max(max(diattenLinear));
maxDiattenHorz = max(max(diattenHorz));
maxDiatten45deg = max(max(diatten45deg));
maxDiattenCirc = max(max(diattenCirc));
maxQMetric = max(max(qMetric));
maxMaxTransmitance = max(max(maxTransmitance));
minMinTransmitance = min(min(minTransmitance));

fileId = fopen(strcat(diattenPath, '_diattenuation_metrics.txt'), 'w');
fprintf(fileId, 'Max Diattenuation: %6.4f\r\n', maxDiatten);
fprintf(fileId, 'Max Linear Diattenuation: %6.4f\r\n', maxDiattenLinear);
fprintf(fileId, 'Max Horizontal Diattenuation: %6.4f\r\n', maxDiattenHorz);
fprintf(fileId, 'Max 45 deg Diattenuation: %6.4f\r\n', maxDiatten45deg);
fprintf(fileId, 'Max Circular Diattenuation: %6.4f\r\n', maxDiattenCirc);
fprintf(fileId, 'Max Q Metric Value: %6.4f\r\n', maxQMetric);
fprintf(fileId, 'Max Maxiumum Transmitance Value: %6.4f\r\n', maxMaxTransmitance);
fprintf(fileId, 'Min Minimum Transmitance Value: %6.4f\r\n', minMinTransmitance);
fclose(fileId);

dlmwrite(strcat(diattenPath, '_diattenuation.txt'), (diatten));
dlmwrite(strcat(diattenPath, '_linear_diattenuation.txt'), (diattenLinear));
dlmwrite(strcat(diattenPath, '_horizontal_diattenuation.txt'), (diattenHorz));
dlmwrite(strcat(diattenPath, '_45deg_diattenuation.txt'), (diatten45deg));
dlmwrite(strcat(diattenPath, '_circular_diattenuation.txt'), (diattenCirc));
dlmwrite(strcat(diattenPath, '_Q_metric.txt'), (qMetric));
dlmwrite(strcat(diattenPath, '_max_transmitance.txt'), (maxTransmitance));
dlmwrite(strcat(diattenPath, '_min_transmitance.txt'), (minTransmitance));

imwrite((diatten/(2)+0.5), strcat(diattenPath, '_diattenuation.bmp'));
imwrite((diattenLinear/(2)+0.5), strcat(diattenPath, '_linear_diattenuation.bmp'));
imwrite((diattenHorz/(2)+0.5), strcat(diattenPath, '_horizontal_diattenuation.bmp'));
imwrite((diatten45deg/(2)+0.5), strcat(diattenPath, '_45deg_diattenuation.bmp'));
imwrite((diattenCirc/(2)+0.5), strcat(diattenPath, '_circular_diattenuation.bmp'));
imwrite((qMetric/(2)+0.5), strcat(diattenPath, '_Q_metric.bmp'));
imwrite((maxTransmitance/(2)+0.5), strcat(diattenPath, '_max_transmitance.bmp'));
imwrite((minTransmitance/(2)+0.5), strcat(diattenPath, '_min_transmitance.bmp'));

write_colourbar_files(diatten, strcat(diattenPath, '_diattenuation'));
write_colourbar_files(diattenLinear, strcat(diattenPath, '_linear_diattenuation'));
write_colourbar_files(diattenHorz, strcat(diattenPath, '_horizontal_diattenuation'));
write_colourbar_files(diatten45deg, strcat(diattenPath, '_45deg_diattenuation'));
write_colourbar_files(diattenCirc, strcat(diattenPath, '_circular_diattenuation'));
write_colourbar_files(qMetric, strcat(diattenPath, '_Q_metric'));
write_colourbar_files(maxTransmitance, strcat(diattenPath, '_max_transmitance'));
write_colourbar_files(minTransmitance, strcat(diattenPath, '_min_transmitance'));

%Write Diattenuation Matrix files
mmDiattenPath = strcat(path, 'Diattenuation/MM/', file, '_diattenuation');
write_MM_files(diattenMatrices, mmDiattenPath);

%Write Depolarization files

depolarPath = strcat(path, 'Depolarization/', file);

%write metric results to text file

maxPolarizance = max(max(diatten));
maxPolarizanceHorz = max(max(polarizanceHorz));
maxPolarizance45deg = max(max(polarizance45deg));
maxPolarizanceCirc = max(max(polarizanceCirc));
maxDepolarizationIndex = max(max(depolarizationIndex));
maxDegreeOfPolarization = max(max(degreeOfPolarization));

fileId = fopen(strcat(depolarPath, '_depolarization_metrics.txt'), 'w');
fprintf(fileId, 'Max Polarizance: %6.4f\r\n', maxPolarizance);
fprintf(fileId, 'Max Horizontal Polarizance: %6.4f\r\n', maxPolarizanceHorz);
fprintf(fileId, 'Max 45 deg Polarizance: %6.4f\r\n', maxPolarizance45deg);
fprintf(fileId, 'Max Circular Polarizance: %6.4f\r\n', maxPolarizanceCirc);
fprintf(fileId, 'Max Depolarization Index: %6.4f\r\n', maxDepolarizationIndex);
fprintf(fileId, 'Max Degree of Polarization: %6.4f\r\n', maxDegreeOfPolarization);
fclose(fileId);

dlmwrite(strcat(depolarPath, '_polarizance.txt'), (polarizance));
dlmwrite(strcat(depolarPath, '_horizontal_polarizance.txt'), (polarizanceHorz));
dlmwrite(strcat(depolarPath, '_45deg_polarizance.txt'), (polarizance45deg));
dlmwrite(strcat(depolarPath, '_circular_polarizance.txt'), (polarizanceCirc));
dlmwrite(strcat(depolarPath, '_depolarization_index.txt'), (depolarizationIndex));
dlmwrite(strcat(depolarPath, '_degree_of_polarization.txt'), (degreeOfPolarization));

imwrite((polarizance/(2)+0.5), strcat(depolarPath, '_polarizance.bmp'));
imwrite((polarizanceHorz/(2)+0.5), strcat(depolarPath, '_horizontal_polarizance.bmp'));
imwrite((polarizance45deg/(2)+0.5), strcat(depolarPath, '_45deg_polariznce.bmp'));
imwrite((polarizanceCirc/(2)+0.5), strcat(depolarPath, '_circular_polarizance.bmp'));
imwrite((depolarizationIndex/(2)+0.5), strcat(depolarPath, '_depolarization_index.bmp'));
imwrite((degreeOfPolarization/(2)+0.5), strcat(depolarPath, '_degree_of_polarization.bmp'));

write_colourbar_files(polarizance, strcat(depolarPath, '_polarizance'));
write_colourbar_files(polarizanceHorz, strcat(depolarPath, '_horizontal_polarizance'));
write_colourbar_files(polarizance45deg, strcat(depolarPath, '_45deg_polarizance'));
write_colourbar_files(polarizanceCirc, strcat(depolarPath, '_circular_polarizance'));
write_colourbar_files(depolarizationIndex, strcat(depolarPath, '_depolarization_index'));
write_colourbar_files(degreeOfPolarization, strcat(depolarPath, '_degree_of_polarization'));

%Write Diattenuation Matrix files
mmDepolarPath = strcat(path, 'Depolarization/MM/', file, '_depolarization');
write_MM_files(depolarMatrices, mmDepolarPath);

disp('Complete!');
disp('Analysis Complete');