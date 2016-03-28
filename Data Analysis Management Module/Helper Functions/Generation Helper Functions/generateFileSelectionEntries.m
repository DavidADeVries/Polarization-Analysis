function [ fileSelectionEntries ] = generateFileSelectionEntries(fileSelectionEntries, path, dirName, depth)
% generateFileSelectionEntries
% in the directory given by path, fileSelectionEntries are generated.
% the depth param helps calculate the amount of spacing to give outfront of
% the selection label

% first add the current directory as a file selection

tab = getTab(Constants.TAB, depth);

currentPath = makePath(path, dirName);

newEntry = FileSelectionEntry(currentPath, [tab, dirName], {});

newEntryIndex = length(fileSelectionEntries) + 1;

fileSelectionEntries{newEntryIndex} = newEntry;

% then add new entries for what is in the dir

dirList = dir(currentPath);

fileList = {};

fileCounter = 1;

for i=1:length(dirList)
    entry = dirList(i);
    
    if ~strcmp(entry.name, '.') && ~strcmp(entry.name, '..')
        if entry.isdir
            fileSelectionEntries = generateFileSelectionEntries(fileSelectionEntries, currentPath, entry.name, depth+1);
        else
            fileList{fileCounter} = FileSelectionEntry(makePath(currentPath, entry.name), entry.name, {});
            
            fileCounter = fileCounter + 1;
        end
    end
    
end

fileSelectionEntries{newEntryIndex}.filesInDir = fileList;

if ~isempty(fileList)
    fileSelectionEntries{newEntryIndex}.fileIndex = 1;
end

end


function tab = getTab(tabString, depth)
    tab = [];

    for i=1:depth
        tab = [tab, tabString];
    end
end
