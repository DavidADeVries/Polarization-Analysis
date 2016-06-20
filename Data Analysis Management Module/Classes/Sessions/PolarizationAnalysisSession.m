classdef PolarizationAnalysisSession < DataProcessingSession
    % PolarizationAnalysisSession
    % stores metadata for a polarization analysis sessios
    
    properties
        muellerMatrixComputationType = []
        muellerMatrixNormalizationType = []
        muellerMatrixOnly
        outOfRangePixelsRatio
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
        
        function metadataString = getMetadataString(session)
            
            [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString, metadataHistoryStrings] = getSessionMetadataString(session);
            [dataProcessingSessionNumberString, linkedSessionsString] = session.getProcessingSessionMetadataString();
            
            computationTypeString = ['MM Computation Type: ', displayType(session.muellerMatrixComputationType)];
            normalizationTypeString = ['MM Normalization Type: ', displayType(session.muellerMatrixNormalizationType)];
            muellerMatrixOnlyString = ['Only MM Computed: ', booleanToString(session.muellerMatrixOnly)];
            versionNumberString = ['Analysis Module Version: ', num2str(session.versionNumber)];
            outOfRangePixelsRatioString = ['Out of Range Pixels Ratio: ', num2str(100*session.outOfRangePixelsRatio), '%'];
                        
            metadataString = {sessionDateString, sessionDoneByString, sessionNumberString, dataProcessingSessionNumberString, linkedSessionsString, computationTypeString, normalizationTypeString, muellerMatrixOnlyString, versionNumberString, outOfRangePixelsRatioString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString};
            metadataString = [metadataString, metadataHistoryStrings];
        end
        
        function data = getPolarizationAnalysisData(session, toLocationPath, toLocationFileName)
            toSessionPath = makePath(toLocationPath, session.dirName);
            
            toSessionFileName = [toLocationFileName, session.generateFilenameSection()];
            
            metricTypes = enumeration('MetricTypes');
            
            fileNameEnd = [createFilenameSection(PolarizationAnalysisNamingConventions.MM_MATLAB_VAR_FILENAME_LABEL, []), Constants.MATLAB_EXT];
            
            for i=1:length(metricTypes)
                metricType = metricTypes(i);
                
                metricGroupTag = createFilenameSection(metricType.metricGroupType.filenameTag,[]);
                metricTag = createFilenameSection(metricType.filenameTag,[]);
                
                metricFilename = [toSessionFileName, metricGroupTag, metricTag, fileNameEnd];
                
                loadPath = makePath(toSessionPath, metricType.metricGroupType.dirName, metricFilename);
                
                vars = load(loadPath, PolarizationAnalysisNamingConventions.METRIC_MATLAB_VAR_NAME);
                
                data{i} = vars.data;
            end
        end
    end
    
end
