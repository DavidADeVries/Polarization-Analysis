function [fileList] = getAllFiles(directory)
%getAllFiles
%from the directory location, it gives all file names

rawDirList = dir(directory);

fileList = cell(0);

counter = 1;

for i=1:length(rawDirList)
    entry = rawDirList(i);
    
    if ~entry.isdir % is a file
        fileList{counter} = entry.name;
        counter = counter + 1;
    end
end


end

