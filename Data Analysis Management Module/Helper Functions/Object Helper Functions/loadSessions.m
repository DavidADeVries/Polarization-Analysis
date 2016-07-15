function parentObject = loadSessions(parentObject)  

sessionDirs = getMetadataFolders(parentObject.getFullPath(), SessionNamingConventions.METADATA_FILENAME);

numSessions = length(sessionDirs);

parentObject.sessions = cell(numSessions, 1);

for i=1:numSessions
    session = loadSession(parentObject, sessionDirs{i});
    
    parentObject.sessions{i} = session;
end

if ~isempty(parentObject.sessions)
    parentObject.sessionIndex = 1;
end

end

function session = loadSession(parentObject, sessionDir)
% loadSession
                
vars = load(makePath(parentObject.getFullPath(), sessionDir, SessionNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
session = vars.metadata;

session.dirName = sessionDir;

% load projectPath
session.projectPath = parentObject.projectPath;

% load toPath
session.toPath = parentObject.getToPath();

% load filename
session.toFilename = parentObject.getFilename();

% load file selections
session = session.createFileSelectionEntries(trialPath);


end

