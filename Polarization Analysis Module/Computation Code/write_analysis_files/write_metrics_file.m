function [] = write_metrics_file(metric_labels, metric_datasets, filepath)
% This function takes in n datasets (n x (X*Y) matrix) and corresponding n labels
% and makes a CSV file containing the max, min, mean, stdev, median,
% skewness, and K-S Test value

% NOTE: use cellstr() function to create metric_labels array

fileId = fopen(filepath, 'w');

fprintf(fileId, 'Metric, Max, Min, Mean, Std Dev, Median, Skewness \r\n');

numMetrics = height(metric_labels);

for n=1:numMetrics
    fprintf(fileId, strcat(char(metric_labels(n)), ','));
    
    metric_max = max(metric_datasets(n,:));
    metric_min = min(metric_datasets(n,:));
        
    if sum(strfind(char(metric_labels(n)), '(Circ)')) > 0 % must use circular stats
        dataset = metric_datasets(n,:);
        
        circ_dataset = convert_to_circ_stat(metric_labels(n), dataset);
        
        circular_mean = circ_mean(circ_dataset');
        circular_stdev = circ_std(circ_dataset');
        circular_median = median(circ_dataset); %circ_median crashes matlab because of the resources required
        circular_skew = circ_skewness(circ_dataset');
                
        metric_mean = convert_from_circ_stat(metric_labels(n), circular_mean, true);
        metric_stdev = convert_from_circ_stat(metric_labels(n), circular_stdev, false); %no shift needed: stdev(a+bx) = stdev(bx)
        metric_median = convert_from_circ_stat(metric_labels(n), circular_median, true);
        metric_skew = circular_skew; %no conversion needed skew(a+bx) = skew(x)
% % %         Retired code:
% % %         used to come in as radians, was put between 0..2pi and put back
% % %         now its done in a helper fn and each metric has different conversions
% % %         % getting ready for circular statistics
% % %         dataset = dataset .* 2;
% % %         dataset_size = size(dataset);
% % %         
% % %         for i=1:dataset_size(2)
% % %            if dataset(i) < 0
% % %               dataset(i) = (2.*pi) + dataset(i); 
% % %            end
% % %         end
        
% % %         dataset = dataset';
        
% % %         metric_mean = circ_mean(dataset) ./ 2 .* radToDeg;  
% % %         metric_stdev = circ_std(dataset) ./ 2 .* radToDeg;                
% % %         metric_median = median(dataset') ./ 2 .* radToDeg; %circular median is a mother on RAM, so let's not.                
% % %         metric_skew = circ_skewness(dataset); %unitless, don't need to convert back
    else
        metric_mean = mean(metric_datasets(n,:));
        metric_stdev = std(metric_datasets(n,:));
        metric_median = median(metric_datasets(n,:));
        metric_skew = skewness(metric_datasets(n,:));
    end    
    
    fprintf(fileId, '%6.4f,%6.4f,%6.4f,%6.4f,%6.4f,%6.4f \r\n', metric_max, metric_min, metric_mean, metric_stdev, metric_median, metric_skew);
end

fclose(fileId);

end

