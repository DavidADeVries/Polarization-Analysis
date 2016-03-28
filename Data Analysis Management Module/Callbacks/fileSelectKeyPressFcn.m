function [] = fileSelectKeyPressFcn(hObject, eventdata, handles)
% fileSelectKeyPressFcn
% gets left and right arrow key presses to move through files

key = eventdata.Key;

leftArrow = strcmp(key, 'leftarrow');
rightArrow = strcmp(key, 'rightarrow');

if leftArrow || rightArrow
    project = handles.localProject;
    
    if leftArrow
        increment = -1;
    else
        increment = 1;
    end
    
    project = project.incrementFileIndex(increment);
    
    handles = project.updateNavigationListboxes(handles); % still do this (image axes update is at the end of this)
    
    handles.localProject = project;
    
    guidata(hObject, handles);
end
    

end

