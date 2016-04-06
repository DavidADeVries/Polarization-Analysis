function session = getSessionBySessionNumber(sessionList, sessionNumber)
% getSessionBySessionNumber

session = [];

for i=1:length(sessionList)
    nextSession = sessionList{i};
    
    if nextSession.sessionNumber == sessionNumber
        session = nextSession;
        break;
    end
end



end

