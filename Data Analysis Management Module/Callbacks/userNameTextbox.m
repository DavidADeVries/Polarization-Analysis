function [] = userNameTextbox(hObject, eventdata, handles)
% userNameTextbox
% updates handles.userName when textbox string is changed

userName = get(hObject, 'String');

handles.userName = userName;

guidata(hObject, handles);

end

