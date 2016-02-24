function [ directoryName ] = createDirName(dirPrefix, dirNumber, dirSubtitle, requiredNumDigits)
% createDirName
% parses together these three pieces to give a directory name in a
% specified format

numDigits = length(dirNumber);

if numDigits < requiredNumDigits
    prefix = '';
    
    for i=1:requiredNumDigits - numDigits
        prefix = [prefix, '0'];
    end
    
    dirNumber = [prefix, dirNumber];
end

directoryName = [dirPrefix, ' ', dirNumber];

if ~isempty(dirSubtitle)
    directoryName = [directoryName, ' (', dirSubtitle, ')'];
end


end

