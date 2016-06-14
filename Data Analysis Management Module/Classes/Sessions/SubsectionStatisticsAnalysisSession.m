classdef SubsectionStatisticsAnalysisSession < DataProcessingSession
    % SubsectionStatisticsAnalysisSession
    % stores metadata for a subsection statistics analysis sessions
    
    properties
        comparisonType = [];
        skippedRejectedSessions
    end
    
    methods
        function session = setPreAnalysisFields(session, userName, normalizationType, mmComputationProgram, onlyComputeMM, sessionNotes, isRejected, rejectedReason, rejectedBy)
            session.uuid = generateUUID();
            session.metadataHistory = MetadataHistoryEntry(userName, SubsectionStatisticsAnalysisSession.empty);
            session.sessionDate = now;
            session.sessionDoneBy = userName;
            session.notes = sessionNotes;
            session.rejected = isRejected;
            session.rejectedReason = rejectedReason;
            session.rejectedBy = rejectedBy;
        end
        
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = [PolarizationAnalysisNamingConventions.SESSION_DIR_SUBTITLE, num2str(session.versionNumber)];
        end
        
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString, metadataHistoryStrings] = getSessionMetadataString(session);
            [dataProcessingSessionNumberString, linkedSessionsString] = session.getProcessingSessionMetadataString();
            
            computationTypeString = ['Comparison Type: ', displayType(session.comparisonType)];
            skippedRejectedSessionsString = ['Skipped Rejected Sessions: ', booleanToString(session.skippedRejectedSessions)];
                        
            metadataString = {...
                sessionDateString,...
                sessionDoneByString,...
                sessionNumberString,...
                dataProcessingSessionNumberString,...
                linkedSessionsString,...
                computationTypeString,...
                skippedRejectedSessionsString,...
                rejectedString,...
                rejectedReasonString,...
                rejectedByString,...
                sessionNotesString};
            
            metadataString = [metadataString, metadataHistoryStrings];
        end
    end
    
end
