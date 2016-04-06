function [selectedSession, duplicateTimes] = getMostRecentSession(sessions)
% getMostRecentSession

topTime = -Inf; %starting  time

duplicateTimes = false;

selectedSession = [];

for i=1:length(sessions)
    session = sessions{i};
    
    if session.sessionDate > topTime
        duplicateTimes = false;
        topTime = session.sessionDate;
        
        selectedSession = session;
    elseif session.sessionDate == topTime
        duplicateTimes = true;
    end
end



end

