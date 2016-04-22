function [metricResults, M_D, M_delta, M_R] = computeMetrics(MM_norm)
% computeMetrics

metricTypes = enumeration('MetricTypes');

numMetrics = length(metricTypes);

mmDims = size(MM_norm);

metricResults = zeros(numMetrics, mmDims(1), mmDims(2)); %allocate memory for all these metric values

M_D = zeros(mmDims);
M_delta = zeros(mmDims);
M_R = zeros(mmDims);

% run through columns, then rows (better for memory accress)

for y=1:mmDims(1)
    for x=1:mmDims(2)
                
        MM = zeros(4,4);
        
        for i = 1:4,
            for j = 1:4,
                MM(j,i) = MM_norm(y,x,j,i);
            end
        end
        
        [M_D_pix, M_delta_pix, M_R_pix, R] = performMatrixDecomposition(MM);
        
        M_D(y,x,:,:) = M_D_pix;
        M_delta(y,x,:,:) = M_delta_pix;
        M_R(y,x,:,:) = M_R_pix;
        
        MM_sqr = MM .^ 2; %each index squared, not MM*MM
        
        for i=1:numMetrics
            metricResults(i,y,x) = computeMetricValue(metricTypes(i), MM, MM_sqr, M_D_pix, M_delta_pix, M_R_pix, R);
        end
        
    end
end



end

