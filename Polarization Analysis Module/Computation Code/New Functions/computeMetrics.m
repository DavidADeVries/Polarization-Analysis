function metricResults = computeMetrics(MM_norm)
% computeMetrics

metricTypes = enumeration('MetricTypes');

numMetrics = length(metricTypes);

mmDims = size(MM_norm);

metricResults = zeros(numMetrics, mmDims(1), mmDims(2)); %allocate memory for all these metric values

% run through columns, then rows (better for memory accress)

for y=1:mmDims(1)
    for x=1:mmDims(2)
                
        MM = zeros(4,4);
        
        for i = 1:4,
            for j = 1:4,
                MM(j,i) = MM_norm(y,x,j,i);
            end
        end
        
        [M_D, M_delta, M_R, R] = performMatrixDecomposition(MM);
        
        MM_sqr = MM .^ 2; %each index squared, not MM*MM
        
        for i=1:numMetrics
            metricResults{i}(y,x) = computeMetricValue(metricTypes(i), MM, MM_sqr, M_D, M_delta, M_R, R);
        end
        
    end
end



end

