function [metricResults, M_D, M_delta, M_R] = computeMetrics(MM_norm)
% computeMetrics

allMetricTypes = enumeration('MetricTypes');

numMetrics = length(allMetricTypes);

mmDims = size(MM_norm);

height = mmDims(1);
width = mmDims(2);

newHeight = height * width;

MM_norm = reshape(MM_norm,newHeight,4,4);

metricResults = zeros(newHeight, numMetrics); %allocate memory for all these metric values

M_D = zeros(newHeight,4,4);
M_delta = zeros(newHeight,4,4);
M_R = zeros(newHeight,4,4);

% run through columns, then rows (better for memory accress)


parfor i=1:newHeight
        
    MM = squeeze(MM_norm(i,:,:));
        
    [M_D_pix, M_delta_pix, M_R_pix] = performMatrixDecomposition(MM);
    
    M_D(i,:,:) = M_D_pix;
    M_delta(i,:,:) = M_delta_pix;
    M_R(i,:,:) = M_R_pix;
    
    MM_sqr = MM .^ 2; %each index squared, not MM*MM
        
    [metricValues, metricTypes] = computeMetricValues(MM, MM_sqr, M_D_pix, M_delta_pix, M_R_pix); 
    
    if length(metricTypes) ~= numMetrics
        error('Metric computation is not configured!');
    end

    metricResults(i,:) = metricValues;
        
end

M_D = reshape(M_D, mmDims);
M_delta = reshape(M_delta, mmDims);
M_R = reshape(M_R, mmDims);

metricResults = reshape(metricResults, height, width, numMetrics);


end

