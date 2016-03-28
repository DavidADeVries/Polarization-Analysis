function lastSession = getLastSessionByType(locations, sessionType)
%getLastSessionByType

lastSession = [];

maxLocationNumber = 0;

for i=1:length(locations)
    location = locations{i};
    
    session = location.getLastSessionByType(sessionType);
    
    if ~isempty(session) && location.locationNumber > maxLocationNumber
        lastSession = session;
        maxLocationNumber = location.locationNumber;
    end
end


end

