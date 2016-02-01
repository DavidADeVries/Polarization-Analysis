function [ ] = importData(hObject, eventdata, handles)
%import_data
% raw data taken from an images (CSLO, microscope) is added to the project
% database.
% Steps include:
% - user entering metadata
% - data copied over and organized
% - auto raw data backups made

% prompt user to select folder for a SUBJECT (aka dog, human, or growth
% trial)

start = 'C:\';
title = 'Select Subject Folder';

importDir = uigetdir(start, title);

if importDir ~= 0 %dir successfully selected
    project = handles.project;
    
    %have user select trial that subject is from
    trialChoices = project.getTrialChoices();
        
    name = 'Select Trial';
    listSize = [160, 150];
    promptString = 'Please select the trial that this data is from.';
    
    [selection, ok] = listdlg('ListString', trialChoices, 'SelectionMode', 'single', 'ListSize', listSize, 'PromptString', promptString, 'Name', name);
    
    
    if ok % selection was made
        subjectId = '';
        cancel = false;
        
        selectedTrial = project.getTrialFromChoice(selection);
        
        while(isempty(subjectId) && ~cancel)
            
            
            % get/confirm subject id
            splitImportDir = strsplit(importDir, '\');
            subjectId = splitImportDir{length(splitImportDir)};
            
            prompt = {'Please enter Subject Name/ID:'};
            title = 'Subject ID';
            numLines = 1;
            defaultAnswer = {subjectId};
            
            answer = inputdlg(prompt, title, numLines, defaultAnswer);
            
            if ~isempty(answer) && ~isempty(answer{1}) %subjectId given (user didn't press cancel, string is not empty                
                indices = findInCellArray(subjectId, selectedTrial.getSubjectIds());
                
                if ~isempty(indices) %subject already exists
                    %ask user if you want to merge data
                    question = ['The subject ', subjectId, ' already exists for this trial. Do you wish to merge this new data with the existing data?'];
                    title = 'Subject Conflict';
                    affirm = 'Yes';
                    deny = 'No';
                    default = affirm;
                    
                    response = questdlg(question, title, affirm, deny, default);
                    
                    if strcmp(response, deny)
                        subjectId = ''; %set subjectId back to empty so the user will have to enter it again
                    end
                end
            else
                cancel = true;
            end
        end
        
        if ~cancel % make sure user didn't cancel
            indices = findInCellArray(subjectId, selectedTrial.getSubjectIds());
            
            toTrialPath = selectedTrial.dirName;
            
            if isempty(indices) %must create new subject
                subject = selectedTrial.createNewSubject();
                
                subject = subject.enterMetadata();
                
                subject.subjectNumber = selectedTrial.nextSubjectNumber();
                subject.subjectId = subjectId;
                               
                
                subject = subject.createDirectories(toTrialPath, handles);
                
                saveToBackup = true;
                subject.saveMetadata(makePath(toTrialPath, subject.dirName), handles, saveToBackup);
                
            else % merge new data with existing subject
                if length(indices) == 1
                    subject = selectedTrial.subjects{indices(1)};
                else
                    error(strcat('Multiple subjects with same Subject ID: ', subjectId));
                end
            end
            
            toSubjectPath = makePath(toTrialPath, subject.dirName);
            
            subject = subject.importSubject(toSubjectPath, importDir, handles.projectDirectory, handles.localDirectory);
            
            selectedTrial = selectedTrial.updateSubject(subject);
            
            project = project.updateTrial(selectedTrial);
            
            handles.project = project;
            
            guidata(hObject, handles);
            
        end
        
    end
end


end

