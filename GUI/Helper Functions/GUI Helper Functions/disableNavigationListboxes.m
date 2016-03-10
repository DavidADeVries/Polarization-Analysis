function [] = disableNavigationListboxes(handles, lastDisabledListbox)
% disableNavigationListboxes
% disable all naviagation listboxes below a certain cutoff, given by
% the lastDisableListbox handle (e.g. handles.subjectSelect)

listboxes = {   handles.fileSelect,...
                handles.subfolderSelect,...
                handles.sessionSelect,...
                handles.locationSelect,...
                handles.quarterSampleSelect,...
                handles.sampleSelect,...
                handles.subjectSelect,...
                handles.trialSelect}; %ordered in a hierarchy low to bottom

for i=1:length(listboxes)
    handle = listboxes{i};
    
    set(handle, 'Enable', 'off', 'String', {'None Available',''}, 'Value', 2);
    
    if handle == lastDisabledListbox
        break;
    end
end

imageSelection = []; %is empty, so the image axes will be cleared out

updateImageAxes(handles, imageSelection);

end

