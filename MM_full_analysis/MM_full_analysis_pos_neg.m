function[] = MM_full_analysis_pos_neg(path, file)

% Input standards:

% path:
% leads to a directory that contains the two subdirectories 'Positive' and
% 'Negative'

% file:
% with the positive directory there are files of the format
% 'file_pos_XXYY.bmp'
% similarly for the negative directory, there are files of the format
% 'file_neg_XXYY.bmp'

pos_path = strcat(path, 'Positive/');
pos_file = strcat(file, '_pos');

neg_path = strcat(path, 'Negative/');
neg_file = strcat(file, '_neg');

sizing_image = imread(strcat(pos_path,file,'_pos_0000.bmp'));
dims = size(sizing_image);

cols = dims(2); 
rows = dims(1);

metric_labels = standard_metric_labels();

numMetrics = length(metric_labels);

posMetricsRaw = MM_full_analysis_for_pos_neg(pos_path, pos_file);
negMetricsRaw = MM_full_analysis_for_pos_neg(neg_path, neg_file);

posMetrics = zeros(numMetrics,rows*cols);
negMetrics = zeros(numMetrics,rows*cols);

for i=1:numMetrics;
   posMetrics(i,:) = reshape(posMetricsRaw(i,:,:), [1 rows*cols]); 
   negMetrics(i,:) = reshape(negMetricsRaw(i,:,:), [1 rows*cols]);
end


%ranges will be specificied as [a,b,c] where the range is the (a:b)./c

%1: for metrics of range 0..1, split into 100 bins (0.01 each)
bins_0_1 = [0,100,100];
%2: for metrics of range -1..-1, split into 200 bins (0.01 each)
bins_neg1_1 = [-100,100,100];
%3: for metrics of range 0..180, split into 180 bins (1 each)
bins_0_180 = [0,180,1];
%4: for metrics of range -180..180, split into 360 bins (1 each)
bins_neg180_180 = [-180,180,1];
%5: for metrics of range 0..90, split into 90 bins (1 each)
bins_0_90 = [0,90,1];
%6: for metrics of range -90..90, split into 180 bins (1 each)
bins_neg90_90 = [-90,90,1];
%7: for metrics of range 0..3, split into 300 bins (0.01 each)
bins_0_3 = [0,300,100];
    
metric_ranges = [
    bins_0_1; %diattenuation range
    bins_0_1; %linear diattenuation range
    bins_neg1_1; %horizontal diattenuation range
    bins_neg1_1; %45 deg diattenuation range
    bins_neg1_1; %circular diattenuation range
    
    bins_0_1; %polarizance range
    bins_0_1; %linear polarizance range
    bins_neg1_1; %horizontal polarizance range
    bins_neg1_1; %45 deg polarizance range
    bins_neg1_1; %circular polarizance range
    
    bins_0_180; %retardance range
    bins_0_180; %linear retardance range
    bins_neg180_180; %horizontal retardance range
    bins_neg180_180; %45 deg retardance range
    bins_neg180_180; %circular retardance range
    
    bins_neg180_180; %optical rotation range
    
    bins_0_1; %depolarization index range
    bins_0_1; %degree of polarization range
    bins_0_3; %Q metric range
    
    bins_0_90;%rho 1 range
    bins_neg1_1; %rho 1 approx range
    bins_neg90_90; %rho 2 range
    bins_neg1_1; %rho 2 approx range
    bins_neg90_90; %theta range
    bins_neg1_1; %theta approx range
    bins_0_180; %delta range
    bins_neg1_1; %delta approx range    
];

ksTestResults = zeros(numMetrics, 3);
unpairedTTestResults = zeros(numMetrics, 2);
pairedTTestResults = zeros(numMetrics, 2);

for i=1:numMetrics;
    range = (metric_ranges(i,1) : metric_ranges(i,2)) ./ metric_ranges(i,3);
    
    posHist = hist(posMetrics(i,:), range);
    negHist = hist(negMetrics(i,:), range);
    
    ksTestResults(i,:) = kstest2(posHist,negHist); %kstest2 returns [h,p,ks_stat]
    
    unpairedTTestResults(i,:) = ttest2(posMetrics(i,:), negMetrics(i,:));
    pairedTTestResults(i,:) = ttest(posMetrics(i,:), negMetrics(i,:));
end

filepath = strcat(path, file, '_stat_test_results.csv');

fileId = fopen(filepath, 'w');

fprintf(fileId, 'Metric, KS-Test, , , Paired T-Test, , Unpaired T-Test \r\n');
fprintf(fileId, ' , H Value, P Value, KS Test Statistic, H Value, P Value, H Value, P Value \r\n');

for n=1:numMetrics
    fprintf(fileId, strcat(char(metric_labels(n)), ','));
        
    fprintf(fileId, '%6.4f,%6.4f,%6.4f,%6.4f,%6.4f,%6.4f,%6.4f \r\n', ksTestResults(n,1), ksTestResults(n,2), ksTestResults(n,3), pairedTTestResults(n,1), pairedTTestResults(n,2), unpairedTTestResults(n,1), unpairedTTestResults(n,2));
end

fclose(fileId);



