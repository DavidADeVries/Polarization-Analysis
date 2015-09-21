% addpath('circular_stats','compute_MM','write_analysis_files','MM_full_analysis','helper_functions','grand_data_slam','metric_labels','analysis_handlers');
% 
% %path = 'C:/Campbell Labs/Alzheimer_s Project/Dog/Cognitively Impaired/';
% path = 'F:/Campbell Labs/Test Dir/';
% 
% disp(datestr(now));
% 
% if(validate_pos_neg(path) && validate_entire_image(path) && validate_control(path))
%     disp('Valid!');
%     analyze_entire_image(path);
%     analyze_pos_neg(path);
%     analyze_con(path);
%     grand_data_slam_pnc(path);
% end
% 
% disp(datestr(now));