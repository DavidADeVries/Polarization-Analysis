function [] = bulkRenameFiles(startDir)
% bulkRenameFiles

entries = dir(startDir);

for i=1:length(entries)
    entry = entries(i);
    
    if ~entry.isdir
        name = entry.name;
        
        newName = strrep(name, '[', '(');
        newName = strrep(newName, ']', ')');
        
        if ~strcmp(name, newName)
            movefile([startDir, '/', name], [startDir, '/', newName]);
        end
    else
        name = entry.name;
        
        if ~strcmp(name, '.') && ~strcmp(name, '..')
            bulkRenameFiles([startDir, '/', name]);
        end
    end
end


end

