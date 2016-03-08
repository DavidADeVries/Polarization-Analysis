function handles = setRejectedInputFields(handles)
%setRejectedInputFields

if handles.rejected
    set(handles.yesRejectedButton, 'Value', 1);
    set(handles.noRejectedButton, 'Value', 0);
else
    set(handles.yesRejectedButton, 'Value', 0);
    set(handles.noRejectedButton, 'Value', 1);
    
    set(handles.rejectedReasonInput, 'Enable', 'off');
    set(handles.rejectedByInput, 'Enable', 'off');
end
    
set(handles.rejectedReasonInput, 'String', handles.rejectedReason)
set(handles.rejectedByInput, 'String', handles.rejectedBy)

end

