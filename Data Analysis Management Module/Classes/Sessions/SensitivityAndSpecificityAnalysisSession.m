classdef SensitivityAndSpecificityAnalysisSession < DataProcessingSession
    % SensitivityAndSpecificityAnalysisSession
    % stores metadata for a sensitity and specificity
    
    properties
        analysisReason = ''
        analysisTitle = ''
    end
    
    methods
        function session = SensitivityAndSpecificityAnalysisSession(parentObject, sessionNumber, dataProcessingSessionNumber, userName, analysisReason, analysisTitle, notes, rejected, rejectedReason, rejectedBy)
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
                
                session.rejected = rejected;
                session.rejectedReason = rejectedReason;
                session.rejectedBy = rejectedBy;
                                
                session.linkedSessionNumbers = []; %distributed over multiple subjects, could uuids I suppose
                
                % make directory/metadata file
                session = session.createDirectories(parentObject.getToPath(), parentObject.projectPath);
                
                % set projectPath
                session.projectPath = parentObject.projectPath;
                
                % set toPath
                session.toPath = parentObject.getToPath();
                
                % set toFilename
                session.toFilename = parentObject.getFilename();
                
                % save metadata
                saveToBackup = false;
                session.saveMetadata(makePath(parentObject.getToPath(), session.dirName), parentObject.projectPath, saveToBackup);
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
        
        function [] = writeSensitivityAndSpecificityFile(session, output)
            filename = [...
                session.getFilename(),...
                createFilenameSection(SensitivityAndSpecificityAnalysisNamingConventions.OUTPUT_FILENAME_SECTION,[]),...
                createFilenameSection(SensitivityAndSpecificityAnalysisNamingConventions.SENSE_AND_SPEC_FILENAME_SECTION,[]),...
                Constants.XLSX_EXT];
            
            toPath = session.getFullPath();
            
            mkdir(toPath, SensitivityAndSpecificityAnalysisNamingConventions.OUTPUT_DIR);
            
            writePath = makePath(toPath, SensitivityAndSpecificityAnalysisNamingConventions.OUTPUT_DIR, filename);
            
            xlswrite(writePath, output);
        end
    end
    
end
