function filenamesByExtension = getFilesByExtension(filenames, extension)
% getFilesByExtension
% keeps filenames that match the extension given

filenamesByExtension = {};

extLength = length(extension);

counter = 1;

for i=1:length(filenames)
    filename = filenames{i};
    
    nameLength = length(filename);
    
    if nameLength >= extLength
        if filename(nameLength - extLength + 1 : nameLength) == extension
            filenamesByExtension{counter} = filename;
            counter = counter + 1;
        end
    end
end

end

