function [] = writeMMFiles(MM, writePath, fileName, dirName, filenameSection)
%writeMMFiles

rootPath = makePath(writePath, dirName);

mkdir(writePath, dirName);

rootFileName = [fileName, filenameSection];

% save MM as MATLAB file
matlabFileName = [rootFileName, createFilenameSection(PolarizationAnalysisNamingConventions.MM_MATLAB_VAR_FILENAME_LABEL, []), Constants.MATLAB_EXT];

save(makePath(rootPath, matlabFileName), PolarizationAnalysisNamingConventions.MM_MATLAB_VAR_NAME);

% save MM as composite image
compositeFileName = [rootFileName, createFilenameSection(PolarizationAnalysisNamingConventions.MM_COMPOSITE_FILENAME_LABEL, []), Constants.PNG_EXT];

createAndWriteMMComposite(MM, makePath(rootPath,compositeFileName));


end

