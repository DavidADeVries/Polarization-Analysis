function filenames = getFilenamesForTagAssignment(path)
% getFilenamesForTagAssignment
% in the path given, all the filenames are trawled, extensions are removed
% and duplicates chopped out

files = getAllFiles(path);

filenames = {};
counter = 1;

for i=1:length(files)
    filename = removeFileExtension(files{i});
    
    if ~containsString(filenames, filename)
        filenames{counter} = filename;
        counter = counter + 1;
    end
end


end

