function [] = fluorescentSubsectionSelectionModule(hObject, eventdata, handles)
% fluorescentSubsectionSelectionModule

project = handles.localProject;

[location, toLocationPath] = project.getSelectedLocation();

session = location.getSelectedSession();
sessions = location.sessions;

if ~isempty(session)
    if isa(session, 'MicroscopeSession')
        fluoroImage = session.getFluoroscentImage(toLocationPath);
        polarimetryImages = session.getAlignedPolarimetryImages(sessions, toLocationPath);
        
        [cancel, xShift, yShift, rotShift] = FluorescentSubsectionSelectionModule(polarimetryImages, fluoroImage);
    else
        warndlg('Please select a registration session.', 'Incorrect Session Type');
    end
    
else
    warndlg('Please select a  microscope session.', 'No Session Open');    
end

end

