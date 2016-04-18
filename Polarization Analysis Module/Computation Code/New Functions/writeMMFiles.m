function [] = writeMMFiles(MM, writePath, fileName)
%writeMMFiles

rootPath = makePath(writePath, PolarizationAnalysisNamingConventions.MM_DIR);

mkdir(writePath, PolarizationAnalysisNamingConventions.MM_DIR);

rootFileName = [fileName, createFilenameSection(PolarizationAnalysisNamingConventions.MM_MATLAB_VAR_FILENAME_LABEL)];

% save MM as MATLAB file
matlabFileName = [rootFileName, createFilenameSection(PolarizationAnalysisNamingConventions.MM_MATLAB_VAR_FILENAME_LABEL), Constants.MATLAB_EXT];

save(makePath(rootPath, matlabFileName), PolarizationAnalysisNamingConventions.MM_MATLAB_VAR_NAME);

% save MM as composite image
compositeFileName = [rootFileName, createFilenameSection(PolarizationAnalysisNamingConventions.MM_COMPOSITE_FILENAME_LABEL), Constants.PNG_EXT];

createAndWriteMMComposite(MM, compositeFileName);


end

