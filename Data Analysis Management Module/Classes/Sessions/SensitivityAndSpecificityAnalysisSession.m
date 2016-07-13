classdef SensitivityAndSpecificityAnalysisSession < DataProcessingSession
    % SensitivityAndSpecificityAnalysisSession
    % stores metadata for a sensitity and specificity
    
    properties
        analysisReason = ''
        analysisTitle = ''
        
        excludedSubjectUUIDs
        excludedSubjectLabels
        excludedSubjectReasons
    end
    
    methods
        function session = SensitivityAndSpecificityAnalysisSession(sessionNumber, dataProcessingSessionNumber, toTrialPath, projectPath, userName, analysisReason, analysisTitle, notes, rejected, rejectedReason, rejectedBy, excludedSubjectUUIDs, excludedSubjectLabels, excludedSubjectReasons, toFilename)
            if nargin > 0
                % set session numbers
                session.sessionNumber = sessionNumber;
                session.dataProcessingSessionNumber = dataProcessingSessionNumber;
                
                % set navigation listbox label
                session.naviListboxLabel = session.generateListboxLabel();
                
                % set metadata history
                session.metadataHistory = MetadataHistoryEntry(userName, SensitivityAndSpecificityAnalysisSession.empty);
                
                % set other fields
                session.uuid = generateUUID();
                session.sessionDate = now;
                session.sessionDoneBy = userName;
                session.analysisReason = analysisReason;
                session.analysisTitle = analysisTitle;
                session.notes = notes;
                
                session.excludedSubjectUUIDs = excludedSubjectUUIDs;
                session.excludedSubjectLabels = excludedSubjectLabels;
                session.excludedSubjectReasons = excludedSubjectReasons;
                
                session.rejected = rejected;
                session.rejectedReason = rejectedReason;
                session.rejectedBy = rejectedBy;
                                
                session.linkedSessionNumbers = []; %distributed over multiple subjects, could uuids I suppose
                
                % make directory/metadata file
                session = session.createDirectories(toTrialPath, projectPath);
                    
                % set toPath
                session.toPath = toTrialPath;
                
                % set toFilename
                session.toFilename = toFilename;
                
                % save metadata
                saveToBackup = false;
                session.saveMetadata(makePath(toTrialPath, session.dirName), projectPath, saveToBackup);
            end
        end
        
        
        function dirSubtitle = getDirSubtitle(session)
            dirSubtitle = [SensitivityAndSpecificityAnalysisNamingConventions.SESSION_DIR_SUBTITLE];
        end
        
        
        function bool = shouldCreateBackup(session)
            bool = false;
        end
        
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString, metadataHistoryStrings] = getSessionMetadataString(session);
            [dataProcessingSessionNumberString, linkedSessionsString] = session.getProcessingSessionMetadataString();
                        
            metadataString = [...
                sessionDateString,...
                sessionDoneByString,...
                sessionNumberString,...
                dataProcessingSessionNumberString,...
                linkedSessionsString,...
                rejectedString,...
                rejectedReasonString,...
                rejectedByString,...
                sessionNotesString];
            
            metadataString = [metadataString, metadataHistoryStrings];
        end
        
        function [] = writeSensitivityAndSpecificityFile(session, toTrialFilename, toTrialPath, projectPath, output)
            filename = [...
                toTrialFilename,...
                session.generateFilenameSection,...
                createFilenameSection(SensitivityAndSpecificityAnalysisNamingConventions.OUTPUT_FILENAME_SECTION,[]),...
                createFilenameSection(SensitivityAndSpecificityAnalysisNamingConventions.SENSE_AND_SPEC_FILENAME_SECTION,[]),...
                Constants.XLSX_EXT];
            
            toPath = makePath(projectPath, toTrialPath, session.dirName);
            
            mkdir(toPath, SensitivityAndSpecificityAnalysisNamingConventions.OUTPUT_DIR);
            
            writePath = makePath(toPath, SensitivityAndSpecificityAnalysisNamingConventions.OUTPUT_DIR, filename);
            
            xlswrite(writePath, output);
        end
    end
    
end
