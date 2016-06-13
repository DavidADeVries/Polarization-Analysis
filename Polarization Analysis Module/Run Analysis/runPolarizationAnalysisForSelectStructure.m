function [trial, selectStructure] = runPolarizationAnalysisForSelectStructure(trial, projectPath, userName,  selectStructure, progressDisplayHandle, normalizationType, mmComputationProgram, onlyComputeMM, sessionNotes, isRejected, rejectedReason, rejectedBy)
% runPolarizationAnalysisForSelectStructure

defaultSession = PolarizationAnalysisSession;

defaultSession = defaultSession.setPreAnalysisFields(userName, normalizationType, mmComputationProgram, onlyComputeMM, sessionNotes, isRejected, rejectedReason, rejectedBy);

for i=1:length(selectStructure)
    entry = selectStructure{i};
    
    if entry.isSession && entry.isSelected && entry.isValidated
        [trial, selectStructure] = trial.runPolarizationAnalysis(entry.indices, defaultSession, projectPath, progressDisplayHandle, selectStructure, i);
    end
end

end

