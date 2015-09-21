function [] = grand_data_slam(main_analysis_path)
% this function is to be run AFTER all your data has been put through the
% full analysis pipeline (has MM calculated, metrics calculated and
% outputed, stats files generated, pos vs. neg analysis run). What this
% program then does is goes through all processed data and brings the
% results all to one place. It will great a CSV with the following data pulled together:
% - KS-Test P-Values for pos vs neg for all locations
% - Unpaired T-Test P-Values for pos vs neg for all locations
% - Paired T-Test P-Values for pos vs neg for all locations
% - Pos and Neg Mean Values for each location
% - Pos and Neg Median Values for each location
% - Pos and Neg Std Dev Values for each location
% - Pos and Neg Skewness Values for each location

%this function looks for a csv called 'Analysis Manifest.csv' in the main
%analysis path. It is of the format of the example below:

%Subject, Location,,
%602AD, Location 1, Location 2, Location 5
%534AD, Location 4, Location 1,

%%home_directory = cd(main_analysis_path); %change folders to go where all the analysis files are. store where we started

raw_manifest = importdata(strcat(main_analysis_path, 'Data Slam Manifest.csv'));

mkdir(strcat(main_analysis_path, 'Complete Set Analysis'));

mean_vals = fopen(strcat(main_analysis_path,'Complete Set Analysis/Mean Values.csv'),'w');
stdev_vals = fopen(strcat(main_analysis_path,'Complete Set Analysis/Standard Deviation Values.csv'),'w');
median_vals = fopen(strcat(main_analysis_path,'Complete Set Analysis/Median Values.csv'),'w');
skew_vals = fopen(strcat(main_analysis_path,'Complete Set Analysis/Skewness Values.csv'),'w');
% ks_test_vals = fopen(strcat(main_analysis_path,'Complete Set Analysis/KS Test Values.csv'),'w');
% paired_t_test_vals = fopen(strcat(main_analysis_path,'Complete Set Analysis/Paired T Test Values.csv'),'w');
% unpaired_t_test_vals = fopen(strcat(main_analysis_path,'Complete Set Analysis/Unpaired T Test Values.csv'),'w');

metric_labels = exhaustive_metric_labels();
tests_metric_labels = standard_metric_labels();

% write spreadsheet headers

fprintf(mean_vals,'Subject,Location,'); %leave room for location names
fprintf(stdev_vals,'Subject,Location,');
fprintf(median_vals,'Subject,Location,');
fprintf(skew_vals,'Subject,Location,');
% fprintf(ks_test_vals,'Subject,Location,');
% fprintf(paired_t_test_vals,'Subject,Location,');
% fprintf(unpaired_t_test_vals,'Subject,Location,');

for i=1:height(metric_labels)
   fprintf(mean_vals,strcat(char(metric_labels(i)),',,'));
   fprintf(stdev_vals,strcat(char(metric_labels(i)),',,'));
   fprintf(median_vals,strcat(char(metric_labels(i)),',,'));
   fprintf(skew_vals,strcat(char(metric_labels(i)),',,'));
end
% 
% for i=1:height(tests_metric_labels)
%     fprintf(ks_test_vals,strcat(char(tests_metric_labels(i)),',,,'));
%     fprintf(paired_t_test_vals,strcat(char(tests_metric_labels(i)),',,'));
%     fprintf(unpaired_t_test_vals,strcat(char(tests_metric_labels(i)),',,'));
% end

fprintf(mean_vals,' \r\n ,,'); %next line, leavinh room for location names in first two columns
fprintf(stdev_vals,' \r\n ,,');
fprintf(median_vals,' \r\n ,,');
fprintf(skew_vals,' \r\n ,,');
% fprintf(ks_test_vals,' \r\n ,,');
% fprintf(paired_t_test_vals,' \r\n ,,');
% fprintf(unpaired_t_test_vals,' \r\n ,,');

for i=1:height(metric_labels)
   fprintf(mean_vals,'Pos,Neg,Control,'); %sub-column pos and neg headers
   fprintf(stdev_vals,'Pos,Neg,Control,');
   fprintf(median_vals,'Pos,Neg,Control,');
   fprintf(skew_vals,'Pos,Neg,Control,');
end

% for i=1:height(tests_metric_labels)
%     fprintf(ks_test_vals,'H Value,P Value,KS Test Statistic,'); %sub-column test param headers
%     fprintf(paired_t_test_vals,'H Value,P Value,');
%     fprintf(unpaired_t_test_vals,'H Value,P Value,');
% end

fprintf(mean_vals,'\r\n');
fprintf(stdev_vals,'\r\n');
fprintf(median_vals,'\r\n');
fprintf(skew_vals,'\r\n');
% fprintf(ks_test_vals,'\r\n');
% fprintf(paired_t_test_vals,'\r\n');
% fprintf(unpaired_t_test_vals,'\r\n');

% fill in spreadsheet data

%iterate through subjects

% need these beauties for the paired T-Tests to be done later
mean_positive_values = zeros(height(metric_labels),1);
mean_negative_values = zeros(height(metric_labels),1);
mean_control_values = zeros(height(metric_labels),1);

stdev_positive_values = zeros(height(metric_labels),1);
stdev_negative_values = zeros(height(metric_labels),1);
stdev_control_values = zeros(height(metric_labels),1);

median_positive_values = zeros(height(metric_labels),1);
median_negative_values = zeros(height(metric_labels),1);
median_control_values = zeros(height(metric_labels),1);

skew_positive_values = zeros(height(metric_labels),1);
skew_negative_values = zeros(height(metric_labels),1);
skew_control_values = zeros(height(metric_labels),1);

total_location_counter = 1;

for i=2:length(raw_manifest)
    subject_and_locations = strsplit(char(raw_manifest(i)),',');
    subject = subject_and_locations(1);
    locations = subject_and_locations(2:length(subject_and_locations));
    
    locations = remove_empty_cells(locations);
    
    %iterate through locations
    
    for j=1:length(locations)
        if j==1
            fprintf(mean_vals, strcat(char(subject),',',char(locations(j))));
            fprintf(stdev_vals, strcat(char(subject),',',char(locations(j))));
            fprintf(median_vals, strcat(char(subject),',',char(locations(j))));
            fprintf(skew_vals, strcat(char(subject),',',char(locations(j))));
%             fprintf(ks_test_vals, strcat(char(subject),',',char(locations(j))));
%             fprintf(paired_t_test_vals, strcat(char(subject),',',char(locations(j))));
%             fprintf(unpaired_t_test_vals, strcat(char(subject),',',char(locations(j))));
        else
            fprintf(mean_vals, strcat(',',char(locations(j))));
            fprintf(stdev_vals, strcat(',',char(locations(j))));
            fprintf(median_vals, strcat(',',char(locations(j))));
            fprintf(skew_vals, strcat(',',char(locations(j))));
%             fprintf(ks_test_vals, strcat(',',char(locations(j))));
%             fprintf(paired_t_test_vals, strcat(',',char(locations(j))));
%             fprintf(unpaired_t_test_vals, strcat(',',char(locations(j))));
        end
        
        location_path = strcat(main_analysis_path, char(subject), '/Processed/', char(locations(j)), '/');
        
        pos_path = strcat(location_path, 'Positive/Metrics and Histograms/');
        neg_path = strcat(location_path, 'Negative/Metrics and Histograms/');
        con_path = strcat(location_path, 'Control/Metrics and Histograms/');
        
        pos_dir = dir(fullfile(pos_path));
        neg_dir = dir(fullfile(neg_path));
        con_dir = dir(fullfile(con_path));
        
        pos_files = find_files_containing(pos_dir, 'pos_metrics.csv');
        neg_files = find_files_containing(neg_dir, 'neg_metrics.csv');
        con_files = find_files_containing(con_dir, 'con_metrics.csv');
        
        if ~(height(pos_files) == 1)
           error(char(strcat('Unique match to metrics file for ', subject, ' ', locations(j), ' (Positive) not found at: ', pos_path)));  
        end
        
        if ~(height(neg_files) == 1)
           error(char(strcat('Unique match to metrics file for ', subject, ' ', locations(j), ' (Negative) not found at: ', neg_path)));  
        end
        
        if ~(height(neg_files) == 1)
           error(char(strcat('Unique match to metrics file for ', subject, ' ', locations(j), ' (Control) not found at: ', con_path)));  
        end
                
        pos_alldata = importdata(strcat(pos_path, char(pos_files(1))));
        neg_alldata = importdata(strcat(neg_path, char(neg_files(1))));
        con_alldata = importdata(strcat(con_path, char(con_files(1))));
        
        
        pos_data = pos_alldata.data;
        neg_data = neg_alldata.data;
        con_data = con_alldata.data;
        
        % iterate through metric labels
        
        for k=1:length(metric_labels)
            fprintf(mean_vals, ',%6.4f,%6.4f,%6.4f', pos_data(k,3), neg_data(k,3), con_data(k,3));
            fprintf(stdev_vals, ',%6.4f,%6.4f,%6.4f', pos_data(k,4), neg_data(k,4), con_data(k,4));
            fprintf(median_vals, ',%6.4f,%6.4f,%6.4f', pos_data(k,5), neg_data(k,5), con_data(k,5));
            fprintf(skew_vals, ',%6.4f,%6.4f,%6.4f', pos_data(k,6),neg_data(k,6), con_data(k,6));
            
            mean_positive_values(k,total_location_counter) = pos_data(k,3);
            mean_negative_values(k,total_location_counter) = neg_data(k,3);            
            mean_control_values(k,total_location_counter) = con_data(k,3);
            
            stdev_positive_values(k,total_location_counter) = pos_data(k,4);
            stdev_negative_values(k,total_location_counter) = neg_data(k,4);
            stdev_control_values(k,total_location_counter) = con_data(k,4);
            
            median_positive_values(k,total_location_counter) = pos_data(k,5);
            median_negative_values(k,total_location_counter) = neg_data(k,5);
            median_control_values(k,total_location_counter) = con_data(k,5);
            
            skew_positive_values(k,total_location_counter) = pos_data(k,6);
            skew_negative_values(k,total_location_counter) = neg_data(k,6);
            skew_control_values(k,total_location_counter) = con_data(k,6);
        end
        
        % do the same for tests results
        
%         location_dir = dir(fullfile(location_path));
%         
%         location_files = find_files_containing(location_dir, 'stat_test_results.csv');
%         
%         if ~(height(location_files) == 1)
%            error(char(strcat('Unique match to Stat Test Results file for ', subject, ' ', locations(j), ' not found!')));  
%         end
%         
%         location_alldata = importdata(strcat(location_path, char(location_files(1)))); 
%         
%         location_data = location_alldata.data;
        
%         for k=1:length(tests_metric_labels)
%             fprintf(ks_test_vals, ',%6.4f,%6.4f,%6.4f', location_data(k,1), location_data(k,2), location_data(k,3));
%             fprintf(paired_t_test_vals, ',%6.4f,%6.4f', location_data(k,4), location_data(k,5));
%             fprintf(unpaired_t_test_vals, ',%6.4f,%6.4f', location_data(k,6), location_data(k,7));
%         end
        
        %fill in data points
        
        fprintf(mean_vals, '\r\n');
        fprintf(stdev_vals, '\r\n');
        fprintf(median_vals, '\r\n');
        fprintf(skew_vals, '\r\n');
%         fprintf(ks_test_vals, '\r\n');
%         fprintf(paired_t_test_vals, '\r\n');
%         fprintf(unpaired_t_test_vals, '\r\n');
        
        total_location_counter = total_location_counter + 1;
    end
end

% write mean, stdev, median, skewnewss for each column

% space it out from data
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

pos_neg_label = 'General Stats';

fprintf(mean_vals, strcat(pos_neg_label,',Mean'));
fprintf(stdev_vals, strcat(pos_neg_label,',Mean'));
fprintf(median_vals, strcat(pos_neg_label,',Mean'));
fprintf(skew_vals, strcat(pos_neg_label,',Mean'));

for i = 1:height(metric_labels)
    fprintf(mean_vals, ',%6.4f,%6.4f,%6.4f', mean(mean_positive_values(i,:)), mean(mean_negative_values(i,:)), mean(mean_control_values(i,:)));
    fprintf(stdev_vals, ',%6.4f,%6.4f,%6.4f', mean(stdev_positive_values(i,:)), mean(stdev_negative_values(i,:)), mean(stdev_control_values(i,:)));
    fprintf(median_vals, ',%6.4f,%6.4f,%6.4f', mean(median_positive_values(i,:)), mean(median_negative_values(i,:)), mean(median_control_values(i,:)));
    fprintf(skew_vals, ',%6.4f,%6.4f,%6.4f', mean(skew_positive_values(i,:)), mean(skew_negative_values(i,:)), mean(skew_control_values(i,:)));
end

fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

fprintf(mean_vals, ',Standard Deviation');
fprintf(stdev_vals, ',Standard Deviation');
fprintf(median_vals, ',Standard Deviation');
fprintf(skew_vals, ',Standard Deviation');

for i = 1:height(metric_labels)
    fprintf(mean_vals, ',%6.4f,%6.4f,%6.4f', std(mean_positive_values(i,:)), std(mean_negative_values(i,:)), std(mean_control_values(i,:)));
    fprintf(stdev_vals, ',%6.4f,%6.4f,%6.4f', std(stdev_positive_values(i,:)), std(stdev_negative_values(i,:)), std(stdev_control_values(i,:)));
    fprintf(median_vals, ',%6.4f,%6.4f,%6.4f', std(median_positive_values(i,:)), std(median_negative_values(i,:)), std(median_control_values(i,:)));
    fprintf(skew_vals, ',%6.4f,%6.4f,%6.4f', std(skew_positive_values(i,:)), std(skew_negative_values(i,:)), std(skew_control_values(i,:)));
end

fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

fprintf(mean_vals, ',Median');
fprintf(stdev_vals, ',Median');
fprintf(median_vals, ',Median');
fprintf(skew_vals, ',Median');

for i = 1:height(metric_labels)
    fprintf(mean_vals, ',%6.4f,%6.4f,%6.4f', median(mean_positive_values(i,:)), median(mean_negative_values(i,:)), median(mean_control_values(i,:)));
    fprintf(stdev_vals, ',%6.4f,%6.4f,%6.4f', median(stdev_positive_values(i,:)), median(stdev_negative_values(i,:)), median(stdev_control_values(i,:)));
    fprintf(median_vals, ',%6.4f,%6.4f,%6.4f', median(median_positive_values(i,:)), median(median_negative_values(i,:)), median(median_control_values(i,:)));
    fprintf(skew_vals, ',%6.4f,%6.4f,%6.4f', median(skew_positive_values(i,:)), median(skew_negative_values(i,:)), median(skew_control_values(i,:)));
end

fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

fprintf(mean_vals, ',Skewness');
fprintf(stdev_vals, ',Skewness');
fprintf(median_vals, ',Skewness');
fprintf(skew_vals, ',Skewness');

for i = 1:height(metric_labels)
    fprintf(mean_vals, ',%6.4f,%6.4f,%6.4f', skewness(mean_positive_values(i,:)), skewness(mean_negative_values(i,:)), skewness(mean_control_values(i,:)));
    fprintf(stdev_vals, ',%6.4f,%6.4f,%6.4f', skewness(stdev_positive_values(i,:)), skewness(stdev_negative_values(i,:)), skewness(stdev_control_values(i,:)));
    fprintf(median_vals, ',%6.4f,%6.4f,%6.4f', skewness(median_positive_values(i,:)), skewness(median_negative_values(i,:)), skewness(median_control_values(i,:)));
    fprintf(skew_vals, ',%6.4f,%6.4f,%6.4f', skewness(skew_positive_values(i,:)), skewness(skew_negative_values(i,:)), skewness(skew_control_values(i,:)));
end

fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

% do Paired T-Tests across columns (pos-neg,..)

mean_t_test_results = zeros(height(metric_labels),7);
stdev_t_test_results = zeros(height(metric_labels),7);
median_t_test_results = zeros(height(metric_labels),7);
skew_t_test_results = zeros(height(metric_labels),7);

%% POS - NEG T TEST %%

for i = 1:height(metric_labels)
    [h,p,ci,stats] = ttest(mean_positive_values(i,:),mean_negative_values(i,:));
    mean_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
    [h,p,ci,stats] = ttest(stdev_positive_values(i,:),stdev_negative_values(i,:));
    stdev_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
    [h,p,ci,stats] = ttest(median_positive_values(i,:),median_negative_values(i,:));
    median_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
    [h,p,ci,stats] = ttest(skew_positive_values(i,:),skew_negative_values(i,:));
    skew_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
end

% space it out from data
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

% print p vals
pos_neg_label = 'Positive-Negative Paired T-Test';

fprintf(mean_vals, strcat(pos_neg_label,',P Value'));
fprintf(stdev_vals, strcat(pos_neg_label,',P Value'));
fprintf(median_vals, strcat(pos_neg_label,',P Value'));
fprintf(skew_vals, strcat(pos_neg_label,',P Value'));

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,2), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,2), stdev_vals);
   stat_test_result_print(median_t_test_results(i,2), median_vals);
   stat_test_result_print(skew_t_test_results(i,2), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print h vals

fprintf(mean_vals, ',H Value');
fprintf(stdev_vals, ',H Value');
fprintf(median_vals, ',H Value');
fprintf(skew_vals, ',H Value');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,1), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,1), stdev_vals);
   stat_test_result_print(median_t_test_results(i,1), median_vals);
   stat_test_result_print(skew_t_test_results(i,1), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print lower ci values

fprintf(mean_vals, ',Confidence Interval');
fprintf(stdev_vals, ',Confidence Interval');
fprintf(median_vals, ',Confidence Interval');
fprintf(skew_vals, ',Confidence Interval');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,3), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,3), stdev_vals);
   stat_test_result_print(median_t_test_results(i,3), median_vals);
   stat_test_result_print(skew_t_test_results(i,3), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print upper ci values

fprintf(mean_vals, ',');
fprintf(stdev_vals, ',');
fprintf(median_vals, ',');
fprintf(skew_vals, ',');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,4), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,4), stdev_vals);
   stat_test_result_print(median_t_test_results(i,4), median_vals);
   stat_test_result_print(skew_t_test_results(i,4), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print tstat values

fprintf(mean_vals, ',T Stat');
fprintf(stdev_vals, ',T Stat');
fprintf(median_vals, ',T Stat');
fprintf(skew_vals, ',T Stat');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,5), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,5), stdev_vals);
   stat_test_result_print(median_t_test_results(i,5), median_vals);
   stat_test_result_print(skew_t_test_results(i,5), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print tstat values

fprintf(mean_vals, ',df Value');
fprintf(stdev_vals, ',df Value');
fprintf(median_vals, ',df Value');
fprintf(skew_vals, ',df Value');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,6), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,6), stdev_vals);
   stat_test_result_print(median_t_test_results(i,6), median_vals);
   stat_test_result_print(skew_t_test_results(i,6), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print tstat values

fprintf(mean_vals, ',sd Value');
fprintf(stdev_vals, ',sd Value');
fprintf(median_vals, ',sd Value');
fprintf(skew_vals, ',sd Value');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,7), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,7), stdev_vals);
   stat_test_result_print(median_t_test_results(i,7), median_vals);
   stat_test_result_print(skew_t_test_results(i,7), skew_vals);
end

%% POS - CON T TEST%%

for i = 1:height(metric_labels)
    [h,p,ci,stats] = ttest(mean_positive_values(i,:),mean_control_values(i,:));
    mean_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
    [h,p,ci,stats] = ttest(stdev_positive_values(i,:),stdev_control_values(i,:));
    stdev_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
    [h,p,ci,stats] = ttest(median_positive_values(i,:),median_control_values(i,:));
    median_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
    [h,p,ci,stats] = ttest(skew_positive_values(i,:),skew_control_values(i,:));
    skew_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
end

% space it out from data
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

% print p vals
pos_con_label = 'Positive-Control Paired T-Test';

fprintf(mean_vals, strcat(pos_con_label,',P Value'));
fprintf(stdev_vals, strcat(pos_con_label,',P Value'));
fprintf(median_vals, strcat(pos_con_label,',P Value'));
fprintf(skew_vals, strcat(pos_con_label,',P Value'));

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,2), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,2), stdev_vals);
   stat_test_result_print(median_t_test_results(i,2), median_vals);
   stat_test_result_print(skew_t_test_results(i,2), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print h vals

fprintf(mean_vals, ',H Value');
fprintf(stdev_vals, ',H Value');
fprintf(median_vals, ',H Value');
fprintf(skew_vals, ',H Value');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,1), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,1), stdev_vals);
   stat_test_result_print(median_t_test_results(i,1), median_vals);
   stat_test_result_print(skew_t_test_results(i,1), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print lower ci values

fprintf(mean_vals, ',Confidence Interval');
fprintf(stdev_vals, ',Confidence Interval');
fprintf(median_vals, ',Confidence Interval');
fprintf(skew_vals, ',Confidence Interval');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,3), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,3), stdev_vals);
   stat_test_result_print(median_t_test_results(i,3), median_vals);
   stat_test_result_print(skew_t_test_results(i,3), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print upper ci values

fprintf(mean_vals, ',');
fprintf(stdev_vals, ',');
fprintf(median_vals, ',');
fprintf(skew_vals, ',');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,4), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,4), stdev_vals);
   stat_test_result_print(median_t_test_results(i,4), median_vals);
   stat_test_result_print(skew_t_test_results(i,4), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print tstat values

fprintf(mean_vals, ',T Stat');
fprintf(stdev_vals, ',T Stat');
fprintf(median_vals, ',T Stat');
fprintf(skew_vals, ',T Stat');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,5), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,5), stdev_vals);
   stat_test_result_print(median_t_test_results(i,5), median_vals);
   stat_test_result_print(skew_t_test_results(i,5), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print tstat values

fprintf(mean_vals, ',df Value');
fprintf(stdev_vals, ',df Value');
fprintf(median_vals, ',df Value');
fprintf(skew_vals, ',df Value');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,6), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,6), stdev_vals);
   stat_test_result_print(median_t_test_results(i,6), median_vals);
   stat_test_result_print(skew_t_test_results(i,6), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print tstat values

fprintf(mean_vals, ',sd Value');
fprintf(stdev_vals, ',sd Value');
fprintf(median_vals, ',sd Value');
fprintf(skew_vals, ',sd Value');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,7), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,7), stdev_vals);
   stat_test_result_print(median_t_test_results(i,7), median_vals);
   stat_test_result_print(skew_t_test_results(i,7), skew_vals);
end

%% NEG - CON T TEST %%

for i = 1:height(metric_labels)
    [h,p,ci,stats] = ttest(mean_negative_values(i,:),mean_control_values(i,:));
    mean_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
    [h,p,ci,stats] = ttest(stdev_negative_values(i,:),stdev_control_values(i,:));
    stdev_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
    [h,p,ci,stats] = ttest(median_negative_values(i,:),median_control_values(i,:));
    median_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
    [h,p,ci,stats] = ttest(skew_negative_values(i,:),skew_control_values(i,:));
    skew_t_test_results(i,:) = [h,p,ci(1),ci(2),stats.tstat,stats.df,stats.sd];
end

% space it out from data
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

% print p vals
neg_con_label = 'Negative-Control Paired T-Test';

fprintf(mean_vals, strcat(neg_con_label,',P Value'));
fprintf(stdev_vals, strcat(neg_con_label,',P Value'));
fprintf(median_vals, strcat(neg_con_label,',P Value'));
fprintf(skew_vals, strcat(neg_con_label,',P Value'));

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,2), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,2), stdev_vals);
   stat_test_result_print(median_t_test_results(i,2), median_vals);
   stat_test_result_print(skew_t_test_results(i,2), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print h vals

fprintf(mean_vals, ',H Value');
fprintf(stdev_vals, ',H Value');
fprintf(median_vals, ',H Value');
fprintf(skew_vals, ',H Value');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,1), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,1), stdev_vals);
   stat_test_result_print(median_t_test_results(i,1), median_vals);
   stat_test_result_print(skew_t_test_results(i,1), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print lower ci values

fprintf(mean_vals, ',Confidence Interval');
fprintf(stdev_vals, ',Confidence Interval');
fprintf(median_vals, ',Confidence Interval');
fprintf(skew_vals, ',Confidence Interval');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,3), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,3), stdev_vals);
   stat_test_result_print(median_t_test_results(i,3), median_vals);
   stat_test_result_print(skew_t_test_results(i,3), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print upper ci values

fprintf(mean_vals, ',');
fprintf(stdev_vals, ',');
fprintf(median_vals, ',');
fprintf(skew_vals, ',');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,4), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,4), stdev_vals);
   stat_test_result_print(median_t_test_results(i,4), median_vals);
   stat_test_result_print(skew_t_test_results(i,4), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print tstat values

fprintf(mean_vals, ',T Stat');
fprintf(stdev_vals, ',T Stat');
fprintf(median_vals, ',T Stat');
fprintf(skew_vals, ',T Stat');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,5), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,5), stdev_vals);
   stat_test_result_print(median_t_test_results(i,5), median_vals);
   stat_test_result_print(skew_t_test_results(i,5), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print tstat values

fprintf(mean_vals, ',df Value');
fprintf(stdev_vals, ',df Value');
fprintf(median_vals, ',df Value');
fprintf(skew_vals, ',df Value');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,6), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,6), stdev_vals);
   stat_test_result_print(median_t_test_results(i,6), median_vals);
   stat_test_result_print(skew_t_test_results(i,6), skew_vals);
end

%new line
fprintf(mean_vals, '\r\n');
fprintf(stdev_vals, '\r\n');
fprintf(median_vals, '\r\n');
fprintf(skew_vals, '\r\n');

%print tstat values

fprintf(mean_vals, ',sd Value');
fprintf(stdev_vals, ',sd Value');
fprintf(median_vals, ',sd Value');
fprintf(skew_vals, ',sd Value');

for i=1:height(metric_labels)
   stat_test_result_print(mean_t_test_results(i,7), mean_vals);
   stat_test_result_print(stdev_t_test_results(i,7), stdev_vals);
   stat_test_result_print(median_t_test_results(i,7), median_vals);
   stat_test_result_print(skew_t_test_results(i,7), skew_vals);
end

%% CLOSE FILES %%

% close files

fclose(mean_vals);
fclose(stdev_vals);
fclose(median_vals);
fclose(skew_vals);
% fclose(ks_test_vals);
% fclose(paired_t_test_vals);
% fclose(unpaired_t_test_vals);

%%cd(home_directory);

end

