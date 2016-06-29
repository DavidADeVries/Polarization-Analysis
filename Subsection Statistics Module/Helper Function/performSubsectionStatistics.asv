function trial = performSubsectionStatistics(trial, selectStructure, comparisonType, projectPath, userName, notes, rejected, rejectedReason, rejectedBy, skippedRejectedSessions)
% performSubsectionStatistics

gathering = false; %flag that signifies at set of sessions for a location are being scooped up

gatheredSessions = {};
toIndices = [];
counter = 1;

dataForStats = {};
dataLocationStrings = {};
dataSessionStrings = {};

dataCounter = 1;

toPath = projectPath;

% add a blank entry to the end for convienence
isSession = false;
selectStructure{length(selectStructure)+1} = SubsectionStatisticsModuleSelectionEntry('', [], isSession, []); %add this to the end


for i=1:length(selectStructure)    
    if selectStructure{i}.isSession && selectStructure{i}.isSelected
        if ~gathering
            gathering = true;
            
            indices = selectStructure{i}.indices;
            
            toIndices = indices(1:length(indices)-1);
        end
        
        gatheredSessions{counter} = selectStructure{i}.session;
        counter = counter + 1;
    else
        if gathering
            numSessions = length(gatheredSessions);
            
            if numSessions == comparisonType.numSessionsRequired
                locationData = {};
                locationString = [];
                sessionString = '';
                
                switch comparisonType
                    case SubsectionComparisonTypes.subsectionComparison
                        posData = {};
                        negData = {};
                        
                        for j=1:length(gatheredSessions)
                            session = gatheredSessions{j};
                            
                            if session.croppingType == CroppingTypes.positiveArea
                                [posData, locationString, newSessionString] = trial.getPolarizationAnalysisData(gatheredSessions{j}, toIndices, toPath);
                                sessionString = addSessionString(sessionString, newSessionString);
                            elseif session.croppingType == CroppingTypes.negativeArea
                                [negData, locationString, newSessionString] = trial.getPolarizationAnalysisData(gatheredSessions{j}, toIndices, toPath);
                                sessionString = addSessionString(sessionString, newSessionString);
                            end
                        end
                        
                        if isempty(posData) || isempty(negData)
                            error('Intended positive and negative data not found');
                        else
                            % reshape into col vectors
                            posDims = size(posData);
                            posData = reshape(posData, posDims(1)*posDims(2), 1);
                            
                            negDims = size(negData);
                            negData = reshape(negData, negDims(1)*negDims(2), 1);
                            
                            locationData = {posData, negData};
                        end
                        
                    case SubsectionComparisonTypes.fluorescentSubsectionComparison
                        session = gatheredSessions{1};
                        
                        [data, locationString, newSessionString] = trial.getPolarizationAnalysisData(session, toIndices, toPath);
                        
                        sessionString = addSessionString(sessionString, newSessionString);
                        
                        fluoroMask = trial.getFluoroMask(session, toIndices, toPath);
                        
                        [posData, negData] = getPosNegWithMask(data, fluoroMask);
                        
                        locationData = {posData, negData};
                    otherwise
                        error('Invalid Subsection Comparison Types');
                end
                
                
                % check if we have data to run with
                if ~isempty(locationData)
                    dataForStats{dataCounter} = locationData;
                    dataLocationStrings{dataCounter} = locationString;
                    dataSessionStrings{dataCounter} = sessionString;
                    
                    dataCounter = dataCounter + 1;
                end
            else
                error('Improper sessions selected');
            end
        end
        
        gathering = false;
        gatheredSessions = {};
        toIndices = [];
        counter = 1;
    end
end


% have all the data collected, so now run the stats!
[statsOutput, testsOutput] = runStats(dataForStats, dataLocationStrings, dataSessionStrings, comparisonType);

% write outputs
analysisSession = writeStats(statsOutput, testsOutput, projectPath, trial, userName, notes, rejected, rejectedReason, rejectedBy, comparisonType, skippedRejectedSessions);


% add session
trial = trial.addSession(analysisSession);




% HELPER FUNCTIONS

function string = addSessionString(string, sessionString)

if isempty(string)
    string = sessionString;
else
    string = [string, ', ', sessionString];
end



