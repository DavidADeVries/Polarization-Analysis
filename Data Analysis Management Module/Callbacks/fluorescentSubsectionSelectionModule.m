function [] = fluorescentSubsectionSelectionModule(hObject, eventdata, handles)
% fluorescentSubsectionSelectionModule

project = handles.localProject;

[location, toLocationPath, toLocationFilename] = project.getSelectedLocation();

projectPath = handles.localPath;
userName = handles.userName;

session = location.getSelectedSession();
sessions = location.sessions;

if ~isempty(session)
    if isa(session, 'MicroscopeSession')
        writePath = makePath(handles.localPath, toLocationPath);
        
        fluoroImage = session.getFluoroscentImage(writePath);
        [polarimetryImages, filenames, registrationSession] = session.getAlignedPolarimetryImages(sessions, makePath(handles.localPath, toLocationPath));
        
        [cancel, transformParams, cropCoords, fluoroImage, fluoroMask, mmImages] = FluorescentSubsectionSelectionModule(polarimetryImages, filenames, fluoroImage);
        
        if ~cancel
            sessionNumber = location.nextSessionNumber();
            dataProcessingSessionNumber = location.nextDataProcessingSessionNumber();
            linkedSessionNumber = [session.sessionNumber, registrationSession.sessionNumber];
            
            fluoroSession = FluorescentSubsectionSelectionSession(...
                sessionNumber,...
                dataProcessingSessionNumber,...
                toLocationPath,...
                projectPath,...
                userName,...
                transformParams,...
                cropCoords,...
                linkedSessionNumber);
            
            fluoroSession.writeMMImages(writePath, toLocationFilename, mmImages, filenames);
            fluoroSession.writeFluoroImages(writePath, toLocationFilename, fluoroImage, fluoroMask);
            
            fluoroSession = fluoroSession.createFileSelectionEntries(writePath);
            
            location = location.updateSession(fluoroSession);
            
            project = project.updateSelectedLocation(location);
            
            handles.localProject = project;
            
            handles = project.updateMetadataFields(handles);
            handles = project.updateNavigationListboxes(handles);
            
            guidata(hObject, handles);
        end
    else
        warndlg('Please select a registration session.', 'Incorrect Session Type');
    end
    
else
    warndlg('Please select a  microscope session.', 'No Session Open');    
end

end

