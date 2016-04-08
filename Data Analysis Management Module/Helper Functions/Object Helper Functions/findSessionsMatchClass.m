function matchedSessions = findSessionsMatchClass(sessions, rawDataSourceClassString)
% findSessionsMatchClass

matchedSessions = {};
counter = 1;

for i=1:length(sessions)
    if isa(sessions{i}, rawDataSourceClassString)
        matchedSessions{counter} = sessions{i};
        counter = counter + 1;
    end
end

end

