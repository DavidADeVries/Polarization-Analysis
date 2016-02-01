function [ directoryName ] = createDirName(dirPrefix, dirNumber, dirSubtitle)
% createDirName
% parses together these three pieces to give a directory name in a
% specified format

directoryName = [dirPrefix, ' ', dirNumber];

if ~isempty(dirSubtitle)
    directoryName = [directoryName, ' (', dirSubtitle, ')'];
end


end

