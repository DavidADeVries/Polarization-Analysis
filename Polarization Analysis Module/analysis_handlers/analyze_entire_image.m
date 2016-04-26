function [ ] = analyze_entire_image(path)
%runs pos and neg area analysis based at the root given by 'path'
%actual subject name and deposit locations are given by the manifest file
%titled 'Pos Neg Analysis Manifest.csv'

raw_manifest = importdata(strcat(path, 'Entire Image Analysis Manifest.csv'),',');

for i=2:length(raw_manifest)
    subject_and_locations = strsplit(char(raw_manifest(i)),',');
    subject = subject_and_locations(1);
    locations = subject_and_locations(2:length(subject_and_locations));
    
    locations = remove_empty_cells(locations);
    
    %iterate through locations
    
    for j=1:length(locations)
        location_path = strcat(path, char(subject), '/Processed/', char(locations(j)), '/Entire Image/');
        
        %need to find the file base name
        
        file_search_dir = dir(fullfile(location_path));
        
        search_string = '_0000.bmp';
        
        location_files = find_files_containing(file_search_dir, search_string);
        
        if ~(height(location_files) == 1)
           error(strcat('Unique match for base file ending in "_0000.bmp" for ', subject, ' ', locations(j), ' not found!'));  
        end
        
        filename = char(location_files(1));
                
        file_base_name = filename(1:length(filename)-length(search_string));
        
        MM_full_analysis_for_pos_neg(location_path, file_base_name);
    end
end

end

