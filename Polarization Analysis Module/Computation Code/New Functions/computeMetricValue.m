function value = computeMetricValue(metricType, MM, MM_sqr, M_D, M_delta, M_R, R)
%computeMetricValue

switch metricType
    case MetricTypes.Diattenuation
        value = computeDiattenuation(MM, MM_sqr);
        
    case MetricTypes.Diattenuation_Horizontal
        value = MM(1,2) ./ MM(1,1);
        
    case MetricTypes.Diattenuation_45deg
        value = MM(1,3) ./ MM(1,1);
        
    case MetricTypes.Diattenuation_Circular
        value = MM(1,4) ./ MM(1,1);
        
    case MetricTypes.Diattenuation_Linear
        value = sqrt(MM_sqr(1,2) + MM_sqr(1,3)) ./ (MM(1,1));
        
    case MetricTypes.Polarizance
        value = sqrt(MM_sqr(2,1) + MM_sqr(3,1) + MM_sqr(4,1)) ./ MM(1,1);
        
    case MetricTypes.Polarizance_Horizontal
        value = MM(2,1) ./ MM(1,1);
        
    case MetricTypes.Polarizance_45deg
        value = MM(3,1) ./ MM(1,1);
        
    case MetricTypes.Polarizance_Circular
        value = MM(4,1) ./ MM(1,1);
        
    case MetricTypes.Polarizance_Linear
        value = sqrt(MM_sqr(2,1) + MM_sqr(3,1)) ./ (MM(1,1));
        
    case MetricTypes.Retardance
        value = R;
        
    case MetricTypes.Retardance_Horizontal
        value = computeRetardanceHorizontal(R, M_R);
        
    case MetricTypes.Retardance_45deg
        value = computeRetardance45deg(R, M_R);
        
    case MetricTypes.Retardance_Circular
        value = (R/(2*sind(R))).*(M_R(2,3) - M_R(3,2));
        
    case MetricTypes.Retardance_Linear
        R_Horz = computeRetardanceHorizontal(R, M_R);
        R_45deg = computeRetardance45deg(R, M_R);
        
        value = sqrt((R_Horz^2) + (R_45deg^2));
        
    case MetricTypes.DegreeOfPolarization
        value = 1 - computeDepolarizationIndex(MM, MM_sqr);
        
    case MetricTypes.DepolarizationIndex
        value = computeDepolarizationIndex(MM, MM_sqr);
        
    case MetricTypes.QMetric
        value = (3*(computeDepolarizationIndex(MM, MM_sqr)^2) - (computeDiattenuation(MM, MM_sqr)^2)) / (1 + (computeDiattenuation(MM, MM_sqr)^2));
        
    case MetricTypes.OpticalRotation
        value = atan2d((M_R(3,2)-M_R(2,3)), (M_R(2,2)+M_R(3,3)));
        
    case MetricTypes.Delta
        value = acosd(MM(4,4));
        
    case MetricTypes.Rho1
        value = 0.5 .* acosd(MM(3,4) ./ sqrt(1 - MM(4,4) .^ 2));
        
    case MetricTypes.Rho2
        value = 0.5 .* atan2d(MM(2,4), MM(3,4));
        
    case MetricTypes.Theta
        value = 0.5 .* atan2d((MM(2,3) - MM(3,2)),(MM(2,2) + MM(3,3)));
        
    otherwise
        error('Invalid Metric Type!');
end

end

function value = computeRetardanceHorizontal(R, M_R)
    value = (R / (2*sind(R))) .* (M_R(3,4) - M_R(4,3));
end

function value = computeRetardance45deg(R, M_R)
    value = (R / (2*sind(R))) .* (M_R(3,4) - M_R(4,3));
end

function value = computeDepolarizationIndex(MM, MM_sqr)
    value = sqrt(sum(sum(MM_sqr)) - MM_sqr(1,1))./(sqrt(3).*MM(1,1));
end

function value = computeDiattenuation(MM, MM_sqr)
    value = sqrt(MM_sqr(1,2) + MM_sqr(1,3) + MM_sqr(1,4)) ./ (MM(1,1));
end
