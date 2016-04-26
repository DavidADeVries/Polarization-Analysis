addpath('circular_stats','compute_MM','write_analysis_files','MM_full_analysis','helper_functions','grand_data_slam','metric_labels','analysis_handlers');

path = 'C:\Michael ARVO Data (Chris and Kurt New Program)\';

disp(datestr(now));

%if(validate_control(path))
    disp('Valid!');
    %analyze_entire_image(path);
    %analyze_pos_neg(path);
    %analyze_control(path);
    grand_data_slam_pnc(path);
%end

disp(datestr(now));