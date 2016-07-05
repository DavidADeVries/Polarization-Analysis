function [] = disableNavigationListboxesForSubsectionSelection(handles, lastDisabledListbox)
% disableNavigationListboxesForSubsectionSelection

% disable all naviagation listboxes below a certain cutoff, given by
% the lastDisableListbox handle (e.g. handles.subjectSelect)

listboxes = {   handles.fileSelectListbox,...
                handles.subfolderSelectListbox}; %ordered in a hierarchy low to bottom

for i=1:length(listboxes)
    handle = listboxes{i};
    
    disableNavigationListbox(handle);
    
    if handle == lastDisabledListbox
        break;
    end
end

imageSelection = []; %is empty, so the image axes will be cleared out

% TODO!!!!!!!!!!!!!!!!!
% updateImageAxes(handles, imageSelection);

end

