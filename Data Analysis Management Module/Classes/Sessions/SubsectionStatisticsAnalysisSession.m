classdef SubsectionStatisticsAnalysisSession < DataProcessingSession
    % SubsectionStatisticsAnalysisSession
    % stores metadata for a subsection statistics analysis sessions
    
    properties
        comparisonType = [];
        skippedRejectedSessions
    end
    
    methods
        function session = SubsectionStatisticsAnalysisSession(sessionNumber, dataProcessingSessionNumber, toLocationPath, projectPath, userName, notes, rejected, rejectedReason, rejectedBy, comparisonType, skippedRejectedSessions)
            if nargin > 0
                % set session numbers
                session.sessionNumber = sessionNumber;
                session.dataProcessingSessionNumber = dataProcessingSessionNumber;
                
                % set navigation listbox label
                session.naviListboxLabel = session.generateListboxLabel();
                
                % set metadata history
                session.metadataHistory = MetadataHistoryEntry(userName, SubsectionStatisticsAnalysisSession.empty);
                
                % set other fields
                session.uuid = generateUUID();
                session.sessionDate = now;
                session.sessionDoneBy = userName;
                session.notes = notes;
                session.rejected = rejected;
                session.rejectedReason = rejectedReason;
                session.rejectedBy = rejectedBy;
                
                session.comparisonType = comparisonType;
                session.skippedRejectedSessions = skippedRejectedSessions;
                
                session.linkedSessionNumbers = []; %distributed over multiple subjects, could uuids I suppose
                
                % make directory/metadata file
                session = session.createDirectories(toLocationPath, projectPath);
                
                % save metadata
                saveToBackup = false;
                session.saveMetadata(makePath(toLocationPath, session.dirName), projectPath, saveToBackup);
            end
        end
        
        
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = [SubsectionStatisticsAnalysisNamingConventions.SESSION_DIR_SUBTITLE];
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
