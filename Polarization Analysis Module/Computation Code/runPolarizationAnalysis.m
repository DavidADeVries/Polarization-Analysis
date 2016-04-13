function trial = runPolarizationAnalysis(trial, projectPath, userName,  selectStructure, progressDisplayHandle, normalizationType, mmComputationProgram, onlyComputeMM, sessionNotes, isRejected, rejectedReason, rejectedBy)
% runPolarizationAnalysis

defaultSession = PolarizationAnalysisSession;

defaultSession = defaultSession.setPreAnalysisFields(userName, normalizationType, mmComputationProgram, onlyComputeMM, sessionNotes, isRejected, rejectedReason, rejectedBy);

for i=1:length(selectStructure)
    entry = selectStructure{i};
    
    if entry.isLocation && entry.isSelected && entry.isValidated
        trial = trial.runPolarizationAnalysis(indices, sessionsToProcess, defaultSession, projectPath, progressDisplayHandle, selectStructure, i);
    end
end

end

