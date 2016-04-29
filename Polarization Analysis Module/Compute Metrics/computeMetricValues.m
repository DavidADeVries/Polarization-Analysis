function [values, metricTypes] = computeMetricValues(MM, MM_sqr, M_D, M_delta, M_R)
%computeMetricValue

diattenuation =             computeDiattenuation(MM, MM_sqr);
diattenuation_horizontal =  computeDiattenuation_Horizontal(MM);
diattenuation_45deg =       computeDiattenuation_45deg(MM);
diattenuation_circular =    computeDiattenuation_Circular(MM);
diattenuation_linear =      computeDiattenuation_Linear(diattenuation_horizontal, diattenuation_45deg);

polarizance =               computePolarizance(MM, MM_sqr);
polarizance_horizontal =    computePolarizance_Horizontal(MM);
polarizance_45deg =         computePolarizance_45deg(MM);
polarizance_circular =      computePolarizance_Circular(MM);
polarizance_linear =        computePolarizance_Linear(polarizance_horizontal, polarizance_45deg);

retardance =                computeRetardance(M_R);
retardance_horizontal =     computeRetardance_Horizontal(M_R, retardance);
retardance_45deg =          computeRetardance_45deg(M_R, retardance);
retardance_circular =       computeRetardance_Circular(M_R, retardance);
retardance_linear =         computeRetardance_Linear(retardance_horizontal, retardance_45deg);

depolarizationIndex =       computeDepolarizationIndex(MM, MM_sqr);
qMetric =                   computeQMetric(depolarizationIndex, diattenuation);

opticalRotation =           computeOpticalRotation(M_R);
delta =                     computeDelta(MM);
rho1 =                      computeRho1(MM);
rho2 =                      computeRho2(MM);
theta =                     computeTheta(MM);

% assign to vector
values = [...
    diattenuation,...
    diattenuation_horizontal,...
    diattenuation_45deg,...
    diattenuation_circular,...
    diattenuation_linear,...
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
    depolarizationIndex,...
    qMetric,...
    opticalRotation,...
    theta,...
    delta,...
    rho1,...
    rho2];

% corresponding metric types (THEY BETTER MATCH!)
metricTypes = [...
    MetricTypes.Diattenuation,...
    MetricTypes.Diattenuation_Horizontal,...
    MetricTypes.Diattenuation_45deg,...
    MetricTypes.Diattenuation_Circular,...
    MetricTypes.Diattenuation_Linear,...
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
    MetricTypes.DepolarizationIndex,...
    MetricTypes.QMetric,...
    MetricTypes.OpticalRotation,...
    MetricTypes.Theta,...
    MetricTypes.Delta,...
    MetricTypes.Rho1,...
    MetricTypes.Rho2];
    
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
function value = computeRetardance_Horizontal(M_R, R)
    a_1 = (1 / (2*sind(R))) * (M_R(3,4) - M_R(4,3)); % since m_R is a bottom-right submatrix of M_R
    
    value = R * a_1;
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1107, Eqn (8) and Pg. 1108, Eqn (17)
function value = computeRetardance_45deg(M_R, R)
    a_2 = (1 / (2*sind(R))) * (M_R(4,2) - M_R(2,4));
    
    value = R * a_2;
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1107, Eqn (8) and Pg. 1108, Eqn (17)
function value = computeRetardance_Circular(M_R, R)
    a_3 = (1 / (2*sind(R))) * (M_R(2,3) - M_R(3,2));
    
    value = R * a_3;
end

% Source: Interpretation of Mueller matrices based on polar decomposition (Lu, Chipman)
% Pg. 1107, Eqn (9)
function value = computeRetardance_Linear(retardance_horizontal, retardance_45deg)
    value = sqrt((retardance_horizontal^2) + (retardance_45deg^2));
end

% Source: Depolarization and Polarization Indices of an Optical System (Gil, Bernabeu)
% Pg. 188, Eqn (23)
function value = computeDepolarizationIndex(MM, MM_sqr)
    norm_sqr = sum(sum(MM_sqr));
    
    numerator = sqrt(norm_sqr - MM_sqr(1,1));
    denominator = (sqrt(3).*MM(1,1));
    
    value = numerator / denominator;
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
function value = computeOpticalRotation(retardance, linear_retardance)
    numerator = cosd(retardance/2);
    denominator = cosd(linear_retardance/2);
    
    value = acosd(numerator/denominator);
end

% Source: Mueller matrix approach for determination of optical rotation in chiral turbid media in backscattering geometry (Manhas et al.)
% Pg. 195, Eqn (17)
function value = computeTheta(M_R)
    value = 0.5 .* atan2d((M_R(2,3) - M_R(3,2)), (M_R(4,2) - M_R(2,4)));
end

function value = computeDelta(MM)
value = real(acosd(MM(4,4)));
end

% Source: Azimuth-Invariant Mueller-Matrix Differentiation of the Optical Anisotropy of Biological Tissue (Ushenko et al.)

function value = computeRho1(MM)
value = real(0.5 .* acosd(MM(3,4) ./ sqrt(1 - MM(4,4) .^ 2)));
end

function value = computeRho2(MM)
value = 0.5 .* atan2d(MM(2,4), MM(3,4));
end

