function analysisSession = writeStats(statsOutput, testsOutput, projectPath, trial, userName, notes, rejected, rejectedReason, rejectedBy, comparisonType, skippedRejectedSessions)
% writeStats

toPath = trial.dirName;

sessionNumber = trial.nextSessionNumber();
dataProcessingSessionNumber = trial.nextDataProcessingSessionNumber();

analysisSession = SubsectionStatisticsAnalysisSession(...
    sessionNumber,...
    dataProcessingSessionNumber,...
    toPath,...
    projectPath,...
    userName,...
    notes,...
    rejected,...
    rejectedReason,...
    rejectedBy,...
    comparisonType,...
    skippedRejectedSessions);

sessionPath = makePath(projectPath, toPath, analysisSession.dirName);

statTypes = enumeration('StatisticTypes');

for i=1:length(statTypes)
    outputForStatsFile = statsOutput{i};
    outputForTestsFile = testsOutput{i};
    
    statType = statTypes(i);
    
    filenameStart = [trial.generateFilenameSection(), analysisSession.generateFilenameSection()];
    
    writeStatFile(outputForStatsFile, sessionPath, statType, filenameStart, SubsectionStatisticsAnalysisNamingConventions.STAT_FILENAME);
    writeStatFile(outputForTestsFile, sessionPath, statType, filenameStart, SubsectionStatisticsAnalysisNamingConventions.TEST_FILENAME);
end

end


function writeStatFile(outputForFile, sessionPath, statType, filenameStart, fileTypeName)
    filename = [filenameStart, createFilenameSection(statType.filenameString, []), createFilenameSection(fileTypeName, []), Constants.XLSX_EXT];
    
    writePath = makePath(sessionPath, filename);
    
    xlswrite(writePath, outputForFile);
end