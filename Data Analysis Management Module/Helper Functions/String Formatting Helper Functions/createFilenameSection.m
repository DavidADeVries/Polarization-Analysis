function filenameSection = createFilenameSection(label, number)
% createFilenameSection
% creates a piece of a filename e.g. (Q2)

leftBracket = Constants.FILENAME_SECTION_LEFT_BRACKET;
rightBracket = Constants.FILENAME_SECTION_RIGHT_BRACKET;

if isempty(label) && isempty(number)
    filenameSection = '';
elseif isempty(label) || isempty(number)
    filenameSection = [leftBracket, label, number, rightBracket];
else
    filenameSection = [leftBracket, label, number, rightBracket];
end


end

