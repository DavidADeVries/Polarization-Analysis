function matchFound = matchesSessionType(session, sessionTypes)
    % matchesSessionType
    
    sessionClass = class(session);
    
    for i=1:length(sessionTypes)
        if isa(sessionTypes.sessionClass, sessionClass)
            matchFound = true;
            break;
        end
    end
    
end

