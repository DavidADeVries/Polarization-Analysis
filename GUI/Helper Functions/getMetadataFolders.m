function [dirList] = getMetadataFolders(directory, metadataFilename)
%getMetadataFolders
%from the directory location, it gives all the folder names that contain
%metadata files
% the . and .. directories are omitted

rawDirList = dir(directory);

dirList = cell(0);

counter = 1;

for i=1:length(rawDirList)
    entry = rawDirList(i);
    
    if entry.isdir % is a directory
        folderName = entry.name;
        
        if ~strcmp(folderName, '.') && ~strcmp(folderName, '..') % don't look at current or previous directory
            metadataLocation = makePath(directory, folderName, metadataFilename);
            
            if exist(metadataLocation, 'file') == 2 % has metadata file
                dirList{counter} = folderName;
                counter = counter + 1;
            end
        end
    end
end


end

