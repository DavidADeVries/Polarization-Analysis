function filenameSection = createFilenameSection(label, number)
% createFilenameSection
% creates a piece of a filename e.g. [Q2]

if isempty(label) || isempty(number)
    filenameSection = ['[', label, number, ']'];
else
    filenameSection = ['[', label, number, ']'];
end


end

