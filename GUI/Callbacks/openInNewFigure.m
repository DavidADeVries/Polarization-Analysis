function [] = openInNewFigure(hObject, eventdata, handles)
% openInNewFigure
% opens the current selected image in a new figure window

project = handles.localProject;

selectedFile = project.getSelectedFile();

if ~isempty(selectedFile)
    imageData = openFile(selectedFile.toPath);
    
    if ~isempty(imageData)
        warning('off', Constants.FIGURE_INIT_SIZE_WARNING_ID);
        
        figure('name', getFilename(selectedFile.toPath));
        imshow(imageData, []);
        
        warning('on', Constants.FIGURE_INIT_SIZE_WARNING_ID);
    end
end



end

