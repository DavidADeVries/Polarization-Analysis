function [] = writeMatlabFile(data, path, filename)
% writeMatlabFile

filename = [filename, makeFilenameSection(PolarizationNamingConventions.MM_MATLAB_VAR_FILENAME_LABEL), Constants.MATLAB_EXT];

writePath = makePath(path, filename);

save(writePath, PolarizationNamingConventions.METRIC_MATLAB_VAR_NAME);


end

