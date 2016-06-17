function trial = performSubsectionStatistics(trial, selectStructure, comparisonType, toPath, userName)
% performSubsectionStatistics

gathering = false; %flag that signifies at set of sessions for a location are being scooped up

gatheredSessions = {};
toIndices = [];
counter = 1;

dataForStats = {};
dataLocationStrings = {};
dataSessionStrings = {};

dataCounter = 1;


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
            
            if numSessions == comparisonType.numSesssionsRequired
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
                                [posData, locationString] = trial.getPolarizationAnalysisData(gatheredSessions{j}, toIndices, toPath);
                                sessionString = addSessionToString(sessionString, session);
                            elseif session.croppingType == CroppingTypes.negativeArea
                                [negData, locationString] = trial.getPolarizationAnalysisData(gatheredSessions{j}, toIndices, toPath);
                                sessionString = addSessionToString(sessionString, session);
                            end
                        end
                        
                        if isempty(posData) || isempy(negData)
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
                        
                        sessionString = addSessionToString(sessionString, session);
                        
                        [data, locationString] = trial.getPolarizationAnalysisData(session, toIndices, toPath);
                        
                        fluoroMask = trial.getFluoroMask(session, toIndices, toPath);
                        
                        [posData, negData] = getPosNegWithMask(data, fluoroMask);
                        
                        locationData = {posData, negData};
                    otherwise
                        error('Invalid Subsection Comparison Types');
                end
                
                
                % check if we have data to run with
                if ~isempty(locationData)
                    dataForStats{counter} = locationData;
                    dataLocationStrings{counter} = locationString;
                    dataSessionStrings{counter} = sessionString;
                    
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
statsOutput = runStats(dataForStats, dataLocationStrings, dataSessionStrings, comparisonType);




% HELPER FUNCTIONS

function string = addSessionToString(string, session)

stringToAdd = session.generateFilenameSection();

if isempty(string)
    string = stringToAdd;
else
    string = [string, ', ', stringToAdd];
end



