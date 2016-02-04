function [ session ] = importDataCollectionSession(location, locationProjectPath, locationImportPath, projectPath, dataFilename)
%importDataCollectionSession
% imports a data collection session. Copies over images, prompts user for
% metadata, back-ups raw data, and puts data on working directory

listString = DataCollectionSession.getDataCollectionSessionChoices();

[choice, ok] = listdlg('ListString', listString, 'SelectionMode', 'single', 'Name', 'Select Data Collection Type', 'PromptString', 'For the data being imported, please select how the data was collected:');

session = DataCollectionSession.getSelection(choice);

session = session.enterMetadata();

session.sessionNumber = location.getNextSessionNumber();
session.dataCollectionSessionNumber = location.getNextDataCollectionSessionNumber();

% make directory/metadata file
session = session.createDirectories(locationProjectPath, projectPath);

saveToBackup = true;
sessionProjectPath = makePath(locationProjectPath, session.dirName);
session.saveMetadata(sessionProjectPath, projectPath, saveToBackup);

% time to copy over the files! At long last!

filenameSection = createFilenameSection(SessionNamingConventions.DATA_FILENAME_LABEL, num2str(session.sessionNumber));
dataFilename = strcat(dataFilename, filenameSection);

session.importData(sessionProjectPath, locationImportPath, projectPath, dataFilename);

end

