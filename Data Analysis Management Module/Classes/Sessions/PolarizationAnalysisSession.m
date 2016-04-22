classdef PolarizationAnalysisSession < DataProcessingSession
    % PolarizationAnalysisSession
    % stores metadata for a polarization analysis sessios
    
    properties
        muellerMatrixComputationType = []
        muellerMatrixNormalizationType = []
        muellerMatrixOnly
        versionNumber %compare to the Version.m versionNumber
    end
    
    methods
        function session = setPreAnalysisFields(session, userName, normalizationType, mmComputationProgram, onlyComputeMM, sessionNotes, isRejected, rejectedReason, rejectedBy)
            session.uuid = generateUUID();
            session.metadataHistory = MetadataHistoryEntry(userName, PolarizationAnalysisSession.empty);
            session.sessionDate = now;
            session.sessionDoneBy = userName;
            session.notes = sessionNotes;
            session.rejected = isRejected;
            session.rejectedReason = rejectedReason;
            session.rejectedBy = rejectedBy;
            session.muellerMatrixComputationType = mmComputationProgram;
            session.muellerMatrixNormalizationType = normalizationType;
            session.muellerMatrixOnly = onlyComputeMM;
            session.versionNumber = PolarizationAnalysisModuleVersion.versionNumber;
        end
        
        function session = setSpecificPreAnalysisFields(session, parentSession, parentLocation)
            session.sessionNumber = parentLocation.nextSessionNumber();
            session.dataProcessingSessionNumber = parentLocation.nextDataProcessingSessionNumber();
            session.linkedSessionNumbers = [parentSession.sessionNumber];
            
            
            session.dirName = session.generateDirName();
            session.naviListboxLabel = session.generateListboxLabel();
            
        end
        
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = [PolarizationAnalysisNamingConventions.SESSION_DIR_SUBTITLE, num2str(session.versionNumber)];
        end
    end
    
end
