classdef Session
    %Session
    % holds metadata describing data collection or analysis for a given
    % location
    
    % a lot of classes inherit from this bad boy
    
    properties
        % set at initialization
        uuid
        dirName = '';
        naviListboxLabel = '';
        metadataHistory = {};
        
        projectPath = ''
        toPath = ''
        toFilename = ''
        
        % set by metadata entry
        sessionDate = 0;
        sessionDoneBy = '';    
        sessionNumber
        notes = '';
        
        rejected = false; % T/F, will exclude data from being included in analysis
        rejectedReason = ''; % reason that this data was rejected (suspected poor imaging, out of focus
        rejectedBy = '';
        
        % list of files for the session and the index   
        fileSelectionEntries = {};
        subfolderIndex = 0;
                
        % for use with select structures
        isSelected = [];
        selectStructureFields = [];
    end
    
    methods(Static)
        
        function session = createSession(sessionType, sessionNumber, dataCollectionSessionNumber, processingSessionNumber, locationProjectPath, projectPath, locationImportPath, userName, sessionChoices, lastSession, toFilename)
            
            if sessionType == SessionTypes.Microscope
                session = MicroscopeSession(sessionNumber, dataCollectionSessionNumber, locationProjectPath, projectPath, locationImportPath, userName, lastSession, toFilename);
                
            elseif sessionType == SessionTypes.CSLO
                session = CLSOSession(sessionNumber, dataCollectionSessionNumber, locationProjectPath, projectPath, locationImportPath, userName, lastSession, toFilename);
                
            elseif sessionType == SessionTypes.LegacyRegistration
                session = LegacyRegistrationSession(sessionNumber, processingSessionNumber, locationProjectPath, projectPath, locationImportPath, userName, sessionChoices, lastSession, toFilename);
                
            elseif sessionType == SessionTypes.LegacySubsectionSelection
                session = LegacySubsectionSelectionSession(sessionNumber, processingSessionNumber, locationProjectPath, projectPath, locationImportPath, userName, sessionChoices, lastSession, toFilename);
                
            elseif sessionType == SessionTypes.FrameAveraging
                session = FrameAveragingSession();
                
            elseif sessionType == SessionTypes.Registration
                session = RegistrationSession();
                
            elseif sessionType == SessionTypes.PolarizationAnalysis
                session = PolarizationAnalysisSession();
                
            elseif sessionType == SessionTypes.SubsectionStatisticsAnalysis
                session = SubsectionStatisticsAnalysisSession();
                
            else
                error('Invalid Session type!');
            end                
        end
        
    end
    
    methods
        
        function session = Session()
            % set UUID
            session.uuid = generateUUID();
        end
        
        function session = wipeoutMetadataFields(session)
            session.dirName = '';
            session.fileSelectionEntries = [];
            session.toPath = '';
            session.toFilename = '';
        end
        
        
        function filename = getFilename(session)
            filename = [session.toFilename, session.generateFilenameSection()];
        end
        
        
        function toPath = getToPath(session)
            toPath = makePath(session.toPath, session.dirName);
        end
        
        
        function toPath = getFullPath(session)
            toPath = makePath(session.projectPath, session.getToPath());
        end
        
        function session = loadObject(session)            
            session = session.createFileSelectionEntries();
        end
        
        
        function handles = updateNavigationListboxes(session, handles)
            subfolderSelections = session.getSubfolderSelections();
            
            if isempty(subfolderSelections)
                disableNavigationListboxes(handles, handles.subfolderSelect);
            else
                set(handles.subfolderSelect, 'String', subfolderSelections, 'Value', session.subfolderIndex, 'Enable', 'on');
                
                handles = session.getSubfolderSelection().updateNavigationListboxes(handles);
            end            
        end
        
        
        function session = updateFileSelectionEntries(session, toPath)
            session.fileSelectionEntries = generateFileSelectionEntries({}, toPath, session.dirName, 0);
        end
        
        
        function session = createFileSelectionEntries(session)
            toSessionPath = makePath(session.projectPath, session.toPath);
            
            session.fileSelectionEntries = generateFileSelectionEntries({}, toSessionPath, session.dirName, 0);
            
            if ~isempty(session.fileSelectionEntries)
                session.subfolderIndex = 1;
            end
        end
        
        function subfolderSelections = getSubfolderSelections(session)
            numEntries = length(session.fileSelectionEntries);
            
            subfolderSelections = cell(numEntries, 1);
            
            for i=1:numEntries
                subfolderSelections{i} = session.fileSelectionEntries{i}.selectionLabel;
            end
        end              
        
        function subfolderSelection = getSubfolderSelection(session)
            
            if session.subfolderIndex ~= 0
                subfolderSelection = session.fileSelectionEntries{session.subfolderIndex};
            else
                subfolderSelection = [];
            end
        end
        
        function session = updateCurrentSubfolderSelection(session, subfolderSelection)
            session.fileSelectionEntries{session.subfolderIndex} = subfolderSelection;
        end
                
        function session = updateSubfolderIndex(session, index)
            session.subfolderIndex = index;
        end
        
        function session = updateFileIndex(session, index)
            subfolderSelection = session.getSubfolderSelection();
            
            subfolderSelection = subfolderSelection.updateFileIndex(index);  
            
            session.fileSelectionEntries{session.subfolderIndex} = subfolderSelection;
        end
        
        function fileSelection = getSelectedFile(session)
            subfolderSelection = session.getSubfolderSelection();
            
            if ~isempty(subfolderSelection)
                fileSelection = subfolderSelection.getFileSelection();
            else
                fileSelection = [];
            end
        end
        
        function session = incrementFileIndex(session, increment)            
            subfolderSelection = session.getSubfolderSelection();
            
            subfolderSelection = subfolderSelection.incrementFileIndex(increment);            
            
            session = session.updateCurrentSubfolderSelection(subfolderSelection);
        end
        
        function [sessionDateString, sessionDoneByString, sessionNumberString, rejectedString, rejectedReasonString, rejectedByString, sessionNotesString, metadataHistoryStrings] = getSessionMetadataString(session)
            
            sessionDateString = ['Date: ', displayDateAndTime(session.sessionDate)];
            sessionDoneByString = ['Done By: ', session.sessionDoneBy];
            sessionNumberString = ['Session Number: ', num2str(session.sessionNumber)];
            rejectedString = ['Rejected: ' , booleanToString(session.rejected)];
            rejectedReasonString = ['Rejected Reason: ', formatMultiLineTextForDisplay(session.rejectedReason)];
            rejectedByString = ['Rejected By: ', session.rejectedBy];
            sessionNotesString = ['Notes: ', formatMultiLineTextForDisplay(session.notes)];
            metadataHistoryStrings = generateMetadataHistoryStrings(session.metadataHistory);
        end
        
        function hasMMDataBool = hasMMData(session)
            hasMMDataBool = false;
            
            for i=1:length(session.fileSelectionEntries)
                entry = session.fileSelectionEntries{i};
                
                if ~isempty(containsString(MicroscopeNamingConventions.MM_DIR.project, entry.dirName))
                    hasMMDataBool = session.fileSelectionEntries{i}.hasMMData();
                    break;
                end
            end
        end
        
        function [linkedSessionNumbers, checkedSessions] = getLinkedSessionNumbers(session, allSessions, checkedSessions, linkedSessionNumbers)
            checkedSessions = [checkedSessions, session.sessionNumber];
            
            if isa(session, class(DataProcessingSession))
                allLinkedSessionNumbers = session.linkedSessionNumbers;
                
                
                for i=1:length(allLinkedSessionNumbers)
                    sessionNumber = allLinkedSessionNumbers(i);
                    
                    if ~ismember(sessionNumber, checkedSession) % don't want to re-check any sessions!
                        linkedSessionNumbers = [linkedSessionNumbers, sessionNumber];
                        
                        nextSession = getSessionBySessionNumber(allSessions, sessionNumber);
                        
                        [linkedSessionNumbers, checkedSessions] = nextSession.getLinkedSessionNumbers(allSessions, checkedSessions);
                    end                    
                end
                    
            else % no linkedSessions list
                linkedSessionNumbers = [];
            end
        end
        
        function isConnected = isConnectedToRejectedSession(session, sessions, linkedSessionNumbers)
            isConnected = session.rejected;
            
            if ~isConnected
                for i=1:length(linkedSessionNumbers)
                    session = getSessionBySessionNumber(sessions, linkedSessionNumbers{i});
                    
                    if session.rejected
                        isConnected = true;
                        break;
                    end
                end
            end
        end
        
        function isConnected = isConnectedToRegisteredData(session, sessions, linkedSessionNumbers)
            registeredClasses = {class(sessionTypes.LegacyRegistration.sessionClass), class(sessionTypes.Registration.sessionClass)};
            
            isConnected = ~isempty(containsString(registeredClasses, class(session)));
            
            if ~isConnected
                for i=1:length(linkedSessionNumbers)
                    session = getSessionBySessionNumber(sessions, linkedSessionNumbers{i});
                    
                    if ~isempty(containsString(registeredClasses, class(session)))
                        isConnected = true;
                        break;
                    end
                end
            end
        end
        
        function dataCollectionSession = getLinkedDataCollectionSession(session, sessions, linkedSessionNumbers)
            counter = 0;
            
            for i=1:length(linkedSessionNumbers)
                session = getSessionBySessionNumber(sessions, linkedSessionNumbers{i});
                
                if isa(session, class('DataCollectionSession'))
                    dataCollectionSession = session;
                    counter = counter + 1;
                end
            end
            
            if counter > 1 % what happened?!
                dataCollectionSession = [];
                error('More than 1 data collection source!');
            end
        end
               
        
        function registeredSessions = findRegisteredSessions(session, sessions)
             registeredSessions = {};
             counter = 1;
             
             for i=1:length(sessions)
                nextSession = sessions{i};
                
                if isa(nextSession, class(SessionTypes.LegacyRegistration)) || isa(nextSession, class(SessionTypes.Registration))
                    if ~isempty(session.sessionNumber, nextSession.linkedSessionNumbers)
                        registeredSessions{counter} = nextSession;
                        counter = counter + 1;
                    end
                end
             end
        end
        
        function runSession = noAnalysisAfterVersionCutoff(session, doNotRerunDataAboveCutoff, versionCutoff, sessions)
            if doNotRerunDataAboveCutoff
                polarizationAnalysisSessions = session.getPolarizationAnalysisSessions(sessions);
                
                runSession = true;
                
                for i=1:length(polarizationAnalysisSessions)
                   analysisSession = polarizationAnalysisSessions{i};
                   
                   if analysisSession.versionNumber > versionCutoff
                        runSession = false;
                        break;
                   end
                end
            else
                runSession = true;
            end
        end
        
        function polarizationAnalysisSessions = getPolarizationAnalysisSessions(session, allSessions)
            polarizationAnalysisSessions = {};
            counter = 1;
            
            for i=1:length(allSessions)
                if isa(allSessions{i}, class(SessionTypes.PolarizationAnalysis.sessionClass))
                    sessionNumber = allSessions{i}.sessionNumber;
                    
                    if ~isempty(findInArray(session.sessionNumbers, sessionNumber))
                        polarizationAnalysisSessions{counter} = allSessions{i};
                        counter = counter + 1;
                    end
                end
            end
        end
                
        
        function [isValidSession, selectStructure] = createSelectStructure(session, indices, sessionClass)
            switch sessionClass
                case class(PolarizationAnalysisSession)                  
                    if ...
                            session.hasMMData() &&...
                            ~isa(session, class(SessionTypes.PolarizationAnalysis.sessionClass)) && ...
                            ~isa(session, class(SessionTypes.Microscope.sessionClass))
                        
                        isValidSession = true;
                        
                        isSession = true;
                        
                        label = [session.naviListboxLabel, ' [', displayDate(session.sessionDate), ']'];
                        
                        if session.rejected
                            label = [label, '*'];
                        end
                        
                        selectStructure = PolarizationAnalysisModuleSelectionEntry(label, indices, isSession);
                    else
                        isValidSession = false;
                        selectStructure = {};
                    end
                case class(SubsectionStatisticsAnalysisSession)
                    if session.isSubsectionSelectionSession() || session.isFluorescentSubsectionSelectionSession()
                        isValidSession = true;
                        
                        isSession = true;
                        
                        label = [session.naviListboxLabel, ' [', displayDate(session.sessionDate), ']'];
                        
                        if session.rejected
                            label = [label, '*'];
                        end
                        
                        selectStructure = SubsectionStatisticsModuleSelectionEntry(label, indices, isSession, session);
                    else
                        isValidSession = false;
                        selectStructure = {};
                    end                    
                otherwise
                    error('Unrecognized class type');
            end
                                    
        end
        
        function [isValid, toPath] = validateSession(session, toPath)
            toPath = [toPath, session.dirName];
            isValid = session.hasMMData();
        end
        
        function [polarizationAnalysisSession, selectStructure] = runPolarizationAnalysis(parentSession, polarizationAnalysisSession, projectPath, progressDisplayHandle, selectStructure, selectStructureIndex, toPath, fileName)
            %parent session is the session where the data is coming from
            
            dataPath = makePath(toPath, parentSession.dirName);
            savePath = makePath(toPath, polarizationAnalysisSession.dirName);
            fileName = [fileName, polarizationAnalysisSession.generateFilenameSection()];
            
            [selectStructure, polarizationAnalysisSession] = runAnalysis(parentSession, polarizationAnalysisSession, projectPath, dataPath, savePath, fileName, progressDisplayHandle, selectStructure, selectStructureIndex);
            
            % save metadata
            saveToBackup = false;
            
            polarizationAnalysisSession.saveMetadata(savePath, projectPath, saveToBackup);
                                
            % set toPath
            polarizationAnalysisSession.toPath = toPath;
            
            % create file selection structure
            polarizationAnalysisSession = polarizationAnalysisSession.createFileSelectionEntries(makePath(projectPath, toPath));
        end
        
        function bool = isRegistrationSession(session)
            sessionClass = class(session);
            
            registrationClasses = {class(RegistrationSession), class(LegacyRegistrationSession)};
            
            bool = ~isempty(containsString(registrationClasses, sessionClass));
        end
        
        function bool = isSubsectionSelectionSession(session)
            sessionClass = class(session);
            
            subsectionSelectionClasses = {class(LegacySubsectionSelectionSession), class(SubsectionSelectionSession)};
            
            bool = ~isempty(containsString(subsectionSelectionClasses, sessionClass));
        end
        
        function bool = isFluorescentSubsectionSelectionSession(session)
            sessionClass = class(session);
            
            subsectionSelectionClasses = {class(FluorescentSubsectionSelectionSession)};
            
            bool = ~isempty(containsString(subsectionSelectionClasses, sessionClass));
        end
        
        function bool = isAnySubsectionSelectionSession(session)
            bool = session.isSubsectionSelectionSession() || session.isFluorescentSubsectionSelectionSession();
        end
        
        function bool = isPolarizationAnalysisSession(session)
            sessionClass = class(session);
            
            polarizationAnalysisClasses = {class(PolarizationAnalysisSession)};
            
            bool = ~isempty(containsString(polarizationAnalysisClasses, sessionClass));            
        end
        
        function [data, sessionString] = getPolarizationAnalysisDataFromSubsectionSelectionSession(session, allSessions, toLocationPath, fileName)
            toSessionPath = makePath(toLocationPath, session.dirName);
            
            if session.isAnySubsectionSelectionSession()
                polarizationAnalysisSession = session.getPolarizationAnalysisSession(allSessions, toSessionPath);
                
                sessionString = polarizationAnalysisSession.generateFilenameSection();
                
                data = polarizationAnalysisSession.getPolarizationAnalysisData(toLocationPath, fileName);
            else
                data = {};
                sessionString = '';
            end
        end
        
        function polarizationAnalysisSession = getPolarizationAnalysisSession(session, allSessions, toSessionPath)
            allPolarizationAnalysisSessions = session.getAllPolarizationAnalysisSessions(allSessions);
            
            validSessions = {};
            counter = 1;
            
            % remove rejected sessions
            for i=1:length(allPolarizationAnalysisSessions)
                if ~allPolarizationAnalysisSessions{i}.rejected
                    validSessions{counter} = allPolarizationAnalysisSessions{i};
                end
            end
            
            if isempty(validSessions)
                polarizationAnalysisSession = [];
            elseif length(validSessions) == 1
                polarizationAnalysisSession = validSessions{1};
            else
                [selectedSession, cancel] = choosePolarizationAnaylsisSession(matchedSessions, toSessionPath);
                
                if cancel
                    polarizationAnalysisSession = [];                    
                else
                    polarizationAnalysisSession = selectedSession;
                end
            end
        end
        
        function allPolarizationAnalysisSessions = getAllPolarizationAnalysisSessions(session, allSessions)
            allPolarizationAnalysisSessions = {};
            counter = 1;
            
            for i=1:length(allSessions)
                possibleSession = allSessions{i};
                
                if possibleSession.isPolarizationAnalysisSession() && possibleSession.isLinkedToSession(session)
                    allPolarizationAnalysisSessions{counter} = possibleSession;
                    counter = counter + 1;
                end
            end
        end
        
        function filenameSections = getFilenameSections(session, indices)
        	filenameSections = session.generateFilenameSection();
        end        
        
        function session = applySelection(session, indices, isSelected, additionalFields)
        end
        
        % *****************************************
        % FUNCTIONS FOR SUBSECTION SELECTION MODULE
        % *****************************************
        
        function handles = updateNavigationListboxesForSubsectionSelection(session, handles)
            subfolderSelections = session.getSubfolderSelections();
            
            if isempty(subfolderSelections)
                disableNavigationListboxesForSubsectionSelection(handles, handles.subfolderSelectListbox);
            else
                set(handles.subfolderSelectListbox, 'String', subfolderSelections, 'Value', session.subfolderIndex, 'Enable', 'on');
                
                handles = session.getSubfolderSelection().updateNavigationListboxes(handles);
            end            
        end
        
    end
    
end

