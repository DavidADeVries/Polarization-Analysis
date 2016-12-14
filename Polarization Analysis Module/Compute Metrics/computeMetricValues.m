function [values, metricTypes] = computeMetricValues(MM, MM_sqr, M_D, M_delta, M_R)
%computeMetricValue

diattenuation =             computeDiattenuation(MM, MM_sqr);
diattenuation_horizontal =  computeDiattenuation_Horizontal(MM);
diattenuation_45deg =       computeDiattenuation_45deg(MM);
diattenuation_circular =    computeDiattenuation_Circular(MM);
diattenuation_linear =      computeDiattenuation_Linear(diattenuation_horizontal, diattenuation_45deg);
diattenuation_theta =       computeDiattenuation_theta (diattenuation_horizontal, diattenuation_45deg);

polarizance =               computePolarizance(MM, MM_sqr);
polarizance_horizontal =    computePolarizance_Horizontal(MM);
polarizance_45deg =         computePolarizance_45deg(MM);
polarizance_circular =      computePolarizance_Circular(MM);
polarizance_linear =        computePolarizance_Linear(polarizance_horizontal, polarizance_45deg);

retardance =                computeRetardance(M_R);

%retardance_vector is the eigenvector of the total retardance matrix
%its value represents simultaneous effect of the HV, +(-)45, and circular
%effect
retardance_vector =          computeRetardanceVector(M_R, retardance);

retardance_horizontal =     computeRetardance_Horizontal(retardance, retardance_vector);
retardance_45deg =          computeRetardance_45deg(retardance, retardance_vector);
retardance_circular =       computeRetardance_Circular(retardance, retardance_vector);
retardance_linear =         computeRetardance_Linear(retardance_horizontal, retardance_45deg);

retardance_theta =          computeRetardance_Theta(retardance_vector);

depolarizationIndex =       computeDepolarizationIndex(MM, MM_sqr);
depolarizationPower =       computeDepolarizationPower(M_delta);
qMetric =                   computeQMetric(depolarizationIndex, diattenuation);

%These angles are derived using the decomposition assumption of the M_R as
%the product of M_LR*M_CR
delta =                     computeDelta(retardance_vector, retardance);
Psi =                       computePsi(M_R);
%This theta is the orientation angle in the above mentioned assumption
theta =                     computeTheta(M_R, Psi);

% Compute the parameter /Sigma to used for computing Anisotropy
Sigma =                     getSigma (MM);
% These parameters are used to quantify the anisotropy along different axes
HLinearA=                   computeHLinearA (MM, Sigma);
Linear45A=                  compute45LinearA (MM, Sigma);
CircA=                      computeCircA (MM, Sigma);
LinearA =                   computeLinearA (HLinearA, Linear45A);
Asymmetric =                computeAsymmetric( retardance_theta, diattenuation_theta);

% assign to vector
values = [...
    diattenuation,...
    diattenuation_horizontal,...
    diattenuation_45deg,...
    diattenuation_circular,...
    diattenuation_linear,...
    diattenuation_theta,...
    polarizance,...
    polarizance_horizontal,...
    polarizance_45deg,...
    polarizance_circular,...
    polarizance_linear,...
    retardance,...
    retardance_horizontal,...
    retardance_45deg,...
    retardance_circular,...
    retardance_linear,...
    retardance_theta,...
    depolarizationIndex,...
    depolarizationPower,...
    qMetric,...
    Psi,...
    theta,...
    delta,...
    HLinearA,...
    Linear45A,...
    CircA,...
    LinearA,...
    Asymmetric];

% corresponding metric types (THEY BETTER MATCH!)
metricTypes = [...
    MetricTypes.Diattenuation,...
    MetricTypes.Diattenuation_Horizontal,...
    MetricTypes.Diattenuation_45deg,...
    MetricTypes.Diattenuation_Circular,...
    MetricTypes.Diattenuation_Linear,...
    MetricTypes.Diattenuation_theta,...
    MetricTypes.Polarizance,...
    MetricTypes.Polarizance_Horizontal,...
    MetricTypes.Polarizance_45deg,...
    MetricTypes.Polarizance_Circular,...
    MetricTypes.Polarizance_Linear...
    MetricTypes.Retardance,...
    MetricTypes.Retardance_Horizontal,...
    MetricTypes.Retardance_45deg,...
    MetricTypes.Retardance_Circular,...
    MetricTypes.Retardance_Linear,...
    MetricTypes.Retardance_Theta,...
    MetricTypes.DepolarizationIndex,...
    MetricTypes.DepolarizationPower,...
    MetricTypes.QMetric,...
    MetricTypes.Psi,...
    MetricTypes.Theta,...
    MetricTypes.Delta,...
    MetricTypes.HLinearA,...
    MetricTypes.Linear45A,...
    MetricTypes.CircA,...
    MetricTypes.LinearA,...
    MetricTypes.Asymmetric];
    
end

% ************************************************************
% NOTE: See "Literature" folder for the sources mentioned here
% ************************************************************

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1109, Eqn (27)
function value = computeDiattenuation(MM, MM_sqr)
    numerator = sqrt(MM_sqr(1,2) + MM_sqr(1,3) + MM_sqr(1,4));
    denominator = MM(1,1);

    value = numerator / denominator;
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1109, Eqn (28)
function value = computeDiattenuation_Horizontal(MM)
    value = MM(1,2) ./ MM(1,1);
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1109, Eqn (28)
function value = computeDiattenuation_45deg(MM)
    value = MM(1,3) ./ MM(1,1);
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1109, Eqn (28)
function value = computeDiattenuation_Circular(MM)
    value = MM(1,4) ./ MM(1,1);
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1107, Eqn (3)
function value = computeDiattenuation_Linear(diattenuation_horizontal, diattenuation_45deg)
    value = sqrt((diattenuation_horizontal^2) + (diattenuation_45deg^2));
end

%orientation angle of the absorption axis.
function value = computeDiattenuation_theta(diattenuation_horizontal, diattenuation_45deg)
    
    compensator = 0;
    if diattenuation_horizontal < 0
        compensator = 180;
    end
    
    value = compensator + atand(diattenuation_45deg/diattenuation_horizontal);
    
    if value < 0
        value = value + 360;
    end
    
    value = 0.5 * value;
end


% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1109, Eqn (31)
function value = computePolarizance(MM, MM_sqr)
    numerator = sqrt(MM_sqr(2,1) + MM_sqr(3,1) + MM_sqr(4,1));
    denominator = MM(1,1);
    
    value = numerator / denominator ;
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1109, Eqn (32)
function value = computePolarizance_Horizontal(MM)
    value = MM(2,1) ./ MM(1,1);
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1109, Eqn (32)
function value = computePolarizance_45deg(MM)
    value = MM(3,1) ./ MM(1,1);
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1109, Eqn (32)
function value = computePolarizance_Circular(MM)
    value = MM(4,1) ./ MM(1,1);
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Diattenuation and Retardance both define "Linear" this way, so the leap
% was made for Polarizance as well
function value = computePolarizance_Linear(polarizance_horizontal, polarizance_45deg)
    value = sqrt((polarizance_horizontal^2) + (polarizance_45deg^2));
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1107, Eqn (8) and Pg. 1108, Eqn (17)
function value = computeRetardance(M_R)
    value = real(acosd((trace(M_R) / 2) - 1));
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1107, Eqn (8) and Pg. 1108, Eqn (17)
function value = computeRetardance_Horizontal(retardance, retardance_vector)
% %     if retardance < 1
% %         value = 0;
% %     elseif retardance > 179
%         E = eig (M_R);
%         e1 =  sqrt((abs(E(2,1)))^2 /((abs(E(2,1)))^2 + (abs(E(3,1)))^2+(abs(E(4,1)))^2));
%         value = real(e1)*sign(real(E(2,1))) * retardance;
% %     else
    value = abs(retardance * retardance_vector(1));
%     end
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1107, Eqn (8) and Pg. 1108, Eqn (17)
function value = computeRetardance_45deg(retardance, retardance_vector)
%     if retardance < 1
%        value = 0;
%     elseif retardance > 179
%         E = eig (M_R);
%         e2 =  sqrt((abs(E(3,1)))^2 /((abs(E(2,1)))^2 + (abs(E(3,1)))^2+(abs(E(4,1)))^2));
%         value = real(e2)*sign(real(E(3,1))) * retardance;      
%     else
       value = abs(retardance * retardance_vector(2));
%     end
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1107, Eqn (8) and Pg. 1108, Eqn (17)
function value = computeRetardance_Circular(retardance, retardance_vector)
%     if retardance < 1
%        value = 0;
%     elseif retardance > 179
%         E = eig (M_R);
%        e3 =  sqrt((abs(E(4,1)))^2 /((abs(E(2,1)))^2 + (abs(E(3,1)))^2+(abs(E(4,1)))^2));
%         value = real(e3)*sign(real(E(4,1))) * retardance;     
% %     else
    value = 0.5 * retardance * retardance_vector(3);   
       
%     end
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1107, Eqn (9)
function value = computeRetardance_Linear(retardance_horizontal, retardance_45deg)
    value = sqrt((retardance_horizontal^2) + (retardance_45deg^2));
end

function value = computeRetardance_Theta(retardance_vector)

    compensator = 0;    

    r_1 = retardance_vector(1);
    r_2 = retardance_vector(2);

    if r_1 < 0
        compensator = 180;
    end
    
    value = compensator + atand(r_2/r_1);
    
    if value < 0
        value = value + 360;
    end
    
    value = 0.5 * value;
   
end

% Source: Depolarization and Polarization Indices of an Optical System (Gil, Bernabeu)
% Pg. 188, Eqn (23)
function value = computeDepolarizationIndex(MM, MM_sqr)
    norm_sqr = sum(sum(MM_sqr));
    
    numerator = sqrt(norm_sqr - MM_sqr(1,1));
    denominator = (sqrt(3).*MM(1,1));
    
    value = numerator / denominator;
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1111, Eqn (54)
function value = computeDepolarizationPower(M_delta)
    value = 1 - ((trace(M_delta) - 1)/3);
end

% Source: On the Q(M) depolarization metric (Espinosa-Luna, Bernabeu)
% Pg. 257, Eqn (7)
function value = computeQMetric(depolarizationIndex, diattenuation)
    numerator = 3*(depolarizationIndex^2) - (diattenuation^2);
    denominator = 1 + (diattenuation^2);
    
    value = numerator / denominator;
end

% Source: Mueller matrix approach for determination of optical rotation in chiral turbid media in backscattering geometry (Manhas et al.)
% Pg. 195, Eqn (16)
% NOTE: Optical Rotation = Circular Retardance / 2   for a pure circular retarder (Wave Optics: Basic Concepts and Contemporary Trends, Gupta et al.)
 function value = computePsi(M_R)

%     numerator =  2 * retardance_vector(3) * sind(retardance);
%     denominator = 1 + cosd(delta);
%     
%     value = real(0.5 * asind(numerator/ denominator));
    
    numerator = M_R(2,3) - M_R(3,2);
    denominator = M_R(2,2) + M_R(3,3);
    value = 0.5 * atan2d(numerator, denominator); %atand2 gives four quadrant value

    %if retardance > 90 & retardance_vactor(3) > 0 
     %   value = 90 - value;
    %end
    
    %if retardance > 90 & retardance_vactor(3) < 0     
    %    value = -90 - value;
    %end
end
% Source: Mueller matrix approach for determination of optical rotation in chiral turbid media in backscattering geometry (Manhas et al.)
% Pg. 195, Eqn (17)
function value = computeTheta(M_R, Psi)
    
    %This method of computing theta is outlined in the vitkin paper.
    %Nothing novel was added by this lab

    compensator = 0;
    
    rotationInverse = [ 1 0 0 0;
                        0 cosd(2*Psi) -sind( 2*Psi) 0;
                        0 sind(2*Psi) cosd( 2* Psi) 0;
                        0 0 0 1 ];
                    
    M_LR = M_R * rotationInverse;
    m_LR = M_LR(2:4, 2:4);
    
    r_1 = m_LR(2,3) - m_LR(3,2); %cos(2 theta)sin(delta)
    r_2 = m_LR(3,1) - m_LR(1,3); % sin(2 theta)sin(delta)

    if r_1 < 0
        compensator = 180;
    end
    
    value = compensator + atand(r_2/r_1);
    
    if value < 0
        value = value + 360;
    end
    
    value = 0.5 * value;
    
end 


% Source: Mueller matrix approach for determination of optical rotation in chiral turbid media in backscattering geometry (Manhas et al.)
% Pg. 195, Eqn (15)
function value = computeDelta(retardance_vector, retardance)
    %R is in degrees
    a = (cosd(retardance/2))^2;
    r_3 = retardance_vector(3);
    
    value = real(2 * acosd( sqrt( (r_3)^2 * (1-a) + a )));
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1108, Eqn (17)
function vector = computeRetardanceVector(M_R, retardance)
    e_1 = M_R(3,4) - M_R(4,3); % since m_R is a bottom-right submatrix of M_R
    e_2 = M_R(4,2) - M_R(2,4);
    e_3 = M_R(2,3) - M_R(3,2);
    
    vector = (1 / (2*sind(retardance))) .* [e_1; e_2; e_3];
end

% Computing the anisotropy of along Horizontal-vertical, +- 45degree, and
% circular axis.
function value = computeHLinearA (MM, Sigma)
      value = sqrt ((1/Sigma)*((MM(1,2)+MM(2,1))^2 + (MM(3,4)-MM(4,3))^2)); 
end

function value = compute45LinearA (MM, Sigma)
      value = sqrt ((1/Sigma)*((MM(1,3)+MM(3,1))^2 + (MM(2,4)-MM(4,2))^2));
end

function value = computeCircA (MM, Sigma)
      value = sqrt ((1/Sigma)*((MM(1,4)+MM(4,1))^2 + (MM(2,3)-MM(3,2))^2));
end

function value = computeLinearA (HLinearA, Linear45A)
      value = sqrt (HLinearA^2 + Linear45A^2);
end 

function value = computeAsymmetric( retardance_theta, diattenuation_theta)
     value = sind(abs( retardance_theta - diattenuation_theta));
end

function value = getSigma (MM)
   value = 3*MM(1,1)^2 - (MM(2,2)^2 + MM(3,3)^2 + MM(4,4)^2) +2*(MM(1,2)*MM(2,1)+MM(1,3)*MM(3,1)...
         + MM(1,4)*MM(4,1) - MM(3,4)*MM(4,3) - MM(2,4)*MM(4,2) - MM(2,3)* MM(3,2));
end