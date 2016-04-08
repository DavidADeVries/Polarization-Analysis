function filenameString = createFilenameString(labels, numberStrings)
% createFilenameString

filenameString = '';

for i=1:length(labels)
    if isempty(numberStrings)
        filenameString = [filenameString, createFilenameSection(labels{i}, [])];
    else
        filenameString = [filenameString, createFilenameSection(labels{i}, numberStrings{i})];
    end
end


end

