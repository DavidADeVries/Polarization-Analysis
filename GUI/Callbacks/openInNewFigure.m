function [] = openInNewFigure(hObject, eventdata, handles)
% openInNewFigure
% opens the current selected image in a new figure window

project = handles.localProject;

selectedFile = project.getSelectedFile();

if ~isempty(selectedFile)
    imageData = openFile(selectedFile.toPath);
    
    if ~isempty(imageData)
        figure('name', getFilename(selectedFile.toPath));
        imshow(imageData, []);
    end
end



end

