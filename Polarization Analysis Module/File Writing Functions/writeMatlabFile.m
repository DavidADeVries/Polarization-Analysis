function [] = writeMatlabFile(data, path, filename)
% writeMatlabFile

filename = [filename, createFilenameSection(PolarizationAnalysisNamingConventions.MM_MATLAB_VAR_FILENAME_LABEL,[]), Constants.MATLAB_EXT];

writePath = makePath(path, filename);

save(writePath, PolarizationAnalysisNamingConventions.METRIC_MATLAB_VAR_NAME);


end

