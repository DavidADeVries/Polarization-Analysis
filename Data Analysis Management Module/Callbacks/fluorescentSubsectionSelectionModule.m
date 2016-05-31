function [] = fluorescentSubsectionSelectionModule(hObject, eventdata, handles)
% fluorescentSubsectionSelectionModule

project = handles.localProject;

[location, toLocationPath] = project.getSelectedLocation();

session = location.getSelectedSession();
sessions = location.sessions;

if ~isempty(session)
    if isa(session, 'MicroscopeSession')
        fluoroImage = session.getFluoroscentImage(makePath(handles.localPath, toLocationPath));
        [polarimetryImages, filenames] = session.getAlignedPolarimetryImages(sessions, makePath(handles.localPath, toLocationPath));
        
        [cancel, xShift, yShift, rotShift] = FluorescentSubsectionSelectionModule(polarimetryImages, filenames, fluoroImage);
    else
        warndlg('Please select a registration session.', 'Incorrect Session Type');
    end
    
else
    warndlg('Please select a  microscope session.', 'No Session Open');    
end

end

