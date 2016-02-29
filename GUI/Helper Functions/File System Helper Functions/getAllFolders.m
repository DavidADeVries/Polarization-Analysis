function [dirList] = getAllFolders(directory)
%getAllFolders
%from the directory location, it gives all the folder names
% the . and .. directories are omitted

rawDirList = dir(directory);

dirList = cell(0);

counter = 1;

for i=1:length(rawDirList)
    entry = rawDirList(i);
    
    if entry.isdir % is a directory
        folderName = entry.name;
        
        if ~strcmp(folderName, '.') && ~strcmp(folderName, '..') %look at current or previous directory
            dirList{counter} = folderName;
            counter = counter + 1;
        end
    end
end


end

