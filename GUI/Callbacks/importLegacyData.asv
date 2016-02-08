function [] = importLegacyData(hObject, eventdata, handles)
% importLegacyData
% starts workflow for user to import legacy data

start = 'C:\';
title = 'Select Legacy Subject Folder';

importDir = uigetdir(start, title);

if importDir ~= 0 %dir successfully selected
    project = handles.localProject;
    
    %have user select trial that subject is from
    trialChoices = project.getTrialChoices();
    
    name = 'Select Trial';
    listSize = [160, 150];
    promptString = 'Please select the trial that this data is from.';
    
    [selection, ok] = listdlg('ListString', trialChoices, 'SelectionMode', 'single', 'ListSize', listSize, 'PromptString', promptString, 'Name', name);
    
    if ok
        trial = project.getTrialFromChoice(selection);
        
        while true
            prompt = '
        end
        
        if trial.subjectType.subjectClass == SubjectClassTypes.Natural
            
        elseif trial.subjectType.subjectClass == SubjectClassTypes.Artifical
            
        else
            error('Invalid subject type');
        end
    end
end


end

