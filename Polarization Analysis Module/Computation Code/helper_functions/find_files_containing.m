function [ files ] = find_files_containing(dir_list, search_string)
% searches within the give list of file/folders and returns the file(s)
% [NOT FOLDERS] that contain the given search string

files = [];

for i=1:length(dir_list)
    if (~(dir_list(i).isdir)) && (~isempty(strfind(dir_list(i).name,search_string)))
        files = [files; cellstr(dir_list(i).name)];
    end
end

end

