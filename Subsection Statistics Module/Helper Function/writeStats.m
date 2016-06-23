function analysisSession = writeStats(statsOutput, projectPath, trial, userName, notes, rejected, rejectedReason, rejectedBy, comparisonType, skippedRejectedSessions)
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
    outputForFile = statsOutput{i};
    statType = statTypes(i);
    
    filenameStart = [trial.generateFilenameSection(), analysisSession.generateFilenameSection()];
    
    writeStatFile(outputForFile, sessionPath, statType, filenameStart);
end


end



function writeStatFile(outputForFile, sessionPath, statType, filenameStart)
    filename = [filenameStart, createFilenameSection(statType.filenameString, []), Constants.XLSX_EXT];
    
    writePath = makePath(sessionPath, filename);
    
    xlswrite(writePath, outputForFile);
end