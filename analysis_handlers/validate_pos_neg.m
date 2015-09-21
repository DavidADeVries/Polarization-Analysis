function [ is_valid ] = validate_pos_neg(path)
%makes sure all the needed files are present in order to run the
%analyze_pos_neg() function on the same path given

raw_manifest = importdata(strcat(path, 'Pos Neg Analysis Manifest.csv'));

suffixes = [
            cellstr('00');
            cellstr('30');
            cellstr('45');
            cellstr('60');            
            ];

is_valid = true;
        
for i=2:length(raw_manifest)
    subject_and_locations = strsplit(char(raw_manifest(i)),',');
    subject = subject_and_locations(1);
    locations = subject_and_locations(2:length(subject_and_locations));
    
    locations = remove_empty_cells(locations);
    
    %iterate through locations
    
    
    for j=1:length(locations)
        location_path = strcat(path, char(subject), '/Processed/', char(locations(j)), '/');
        
        %need to find the file base name
        file_search_dir = dir(fullfile(strcat(location_path, 'Positive/')));
        
        search_string = '_pos_0000.bmp';
        
        location_files = find_files_containing(file_search_dir, search_string);
        
        if ~(height(location_files) == 1)
           error(char(strcat('Unique match for base file ending in "_0000.bmp" for ', subject, ' ', locations(j), ' not found!')));  
        end
        
        filename = char(location_files(1));
                
        file_base_name = filename(1:length(filename)-length(search_string));
        
        % check files are in place
        
        
        
        for i=1:height(suffixes)
            for j=1:height(suffixes)
                pos_file = char(strcat(location_path, 'Positive/', file_base_name, '_pos_', suffixes(i), suffixes(j), '.bmp'));
                
                if exist(pos_file, 'file') == 0
                    disp(strcat('WARNING: "', pos_file, '" does not exist.'));
                    is_valid = false;
                end
                  
                neg_file = char(strcat(location_path, 'Negative/', file_base_name, '_neg_', suffixes(i), suffixes(j), '.bmp'));
                
                if exist(neg_file, 'file') == 0
                    disp(strcat('WARNING: "', neg_file, '" does not exist.'));
                    is_valid = false;
                end
            end
        end
    end
end


end

