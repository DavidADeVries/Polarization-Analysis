classdef Project
    %Project
    % contains project metadata
    
    properties
        title
        description
        
        trials
        trialIndex = 0
        
        metadataHistory
        
        notes
    end
    
    methods
        function project = loadProject(project, projectDir)
            % load metadata
            vars = load(makePath(projectDir, ProjectNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
            project = vars.metadata;
            
            % load trials
            trialDirs = getMetadataFolders(projectDir, TrialNamingConventions.METADATA_FILENAME);
            
            numTrials = length(trialDirs);
            project.trials = createEmptyCellArray(Trial.empty, numTrials);
            
            for i=1:numTrials
                project.trials{i} = project.trials{i}.loadTrial(projectDir, trialDirs{i});
            end
            
            if ~isempty(project.trials)
                project.trialIndex = 1;
            end
        end
        
        function project = updateTrial(project, trial)
            trials = project.trials;
            numTrials = length(trials);
            updated = false;
            
            for i=1:numTrials
                if trials{i}.trialNumber == trial.trialNumber
                    project.trials{i} = trial;
                    updated = true;
                    break;
                end
            end
            
            if ~updated % add new trial
                project.trials{numTrials + 1} = trial;
                
                if project.trialIndex == 0
                    project.trialIndex = 1;
                end
            end            
        end
        
        function trialChoices = getTrialChoices(project)
            trials = project.trials;
            numTrials = length(trials);
            
            trialChoices = cell(numTrials, 1);
            
            for i=1:numTrials
                trialChoices{i} = ['Trial ', num2str(trials{i}.trialNumber), ' (', trials{i}.title, ')'];
            end
        end
        
        function trial = getTrialFromChoice(project, choice)
            trial = project.trials{choice}; 
        end
        
        function trial = getSelectedTrial(project)
            trial = [];
            
            if project.trialIndex ~= 0
                trial = project.trials{project.trialIndex};
            end
        end
        
        function trialNumbers = getTrialNumbers(project)
            trials = project.trials;
            numTrials = length(trials);
            
            trialNumbers = zeros(numTrials, 1); % want this to be an matrix, not cell array
            
            for i=1:numTrials
                trialNumbers(i) = trials{i}.trialNumber;
            end
        end
                
        function nextNumber = nextTrialNumber(projects)
            trialNumbers = projects.getTrialNumbers();
            
            if isempty(trialNumbers)
                nextNumber = 1;
            else
                lastNumber = max(trialNumbers);
                nextNumber = lastNumber + 1;
            end
        end
        
        function handles = updateNavigationListboxes(project, handles)
            numTrials = length(project.trials);
            
            trialOptions = cell(numTrials, 1);
            
            if numTrials == 0
                disableNavigationListboxes(handles, handles.trialSelect);
            else
                for i=1:numTrials
                    trialOptions{i} = project.trials{i}.dirName;
                end
                
                set(handles.trialSelect, 'String', trialOptions, 'Value', project.trialIndex, 'Enable', 'on');
                
                handles = project.getSelectedTrial().updateNavigationListboxes(handles);
            end
        end
        
        function handles = updateMetadataFields(project, handles)
            trial = project.getSelectedTrial();
                        
            if isempty(trial)
                disableMetadataFields(handles, handles.trialMetadata);
            else
                metadataString = trial.getMetadataString();
                
                set(handles.trialMetadata, 'String', metadataString);
                
                handles = trial.updateMetadataFields(handles);
            end
        end
        
        function project = importData(project, handles, importDir)
            % select trial
            
            prompt = ['Select the trial to which the subject being imported belongs to. Import path: ', importDir];
            title = 'Select Trial';
            choices = project.getTrialChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    trial = Trial(project.nextTrialNumber, project.getTrialNumbers(), handles.userName, handles.localPath, importDir);
                else
                    trial = project.getTrialFromChoice(choice);
                end
                
                if ~isempty(trial)
                    trial = trial.importData(handles, importDir);
                
                    project = project.updateTrial(trial);
                end
            end            
        end
        
        function project = updateTrialIndex(project, index)
            project.trialIndex = index;
        end
        
        function project = updateSubjectIndex(project, index)
            trial = project.getSelectedTrial();
            
            trial = trial.updateSubjectIndex(index);
            
            project = project.updateTrial(trial);
        end
        
        function project = updateEyeIndex(project, index)
            trial = project.getSelectedTrial();
            
            trial = trial.updateEyeIndex(index);
            
            project = project.updateTrial(trial);
        end
        
        function project = updateQuarterSampleIndex(project, index)
            trial = project.getSelectedTrial();
            
            trial = trial.updateQuarterSampleIndex(index);
            
            project = project.updateTrial(trial);
        end
        
        function project = updateLocationIndex(project, index)
            trial = project.getSelectedTrial();
            
            trial = trial.updateLocationIndex(index);
            
            project = project.updateTrial(trial);
        end
        
        function project = updateSessionIndex(project, index)
            trial = project.getSelectedTrial();
            
            trial = trial.updateSessionIndex(index);
            
            project = project.updateTrial(trial);
        end
        
        function project = updateSubfolderIndex(project, index)
            trial = project.getSelectedTrial();
            
            trial = trial.updateSubfolderIndex(index);
            
            project = project.updateTrial(trial);
        end
        
        function project = updateFileIndex(project, index)
            trial = project.getSelectedTrial();
            
            trial = trial.updateFileIndex(index);
            
            project = project.updateTrial(trial);
        end
        
        function fileSelection = getSelectedFile(project)
            trial = project.getSelectedTrial();
            
            if ~isempty(trial)
                fileSelection = trial.getSelectedFile();
            else
                fileSelection = [];
            end
        end
        
        function project = incrementFileIndex(project, increment)            
            trial = project.getSelectedTrial();
            
            trial = trial.incrementFileIndex(increment);
            
            project = project.updateTrial(trial);
        end
        
        function project = importLegacyData(project, legacySubjectImportDir, localProjectPath, userName)
            prompt = ['Select the trial to which the subject being imported belongs to. Import path: ', legacySubjectImportDir];
            title = 'Select Trial';
            choices = project.getTrialChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    trial = Trial(project.nextTrialNumber, project.getTrialNumbers(), userName, localProjectPath, legacySubjectImportDir);
                else
                    trial = project.getTrialFromChoice(choice);
                end
                
                if ~isempty(trial)
                    trial = trial.importLegacyData(legacySubjectImportDir, localProjectPath, userName);
                    
                    project = project.updateTrial(trial);
                end
            end
        end
    end
    
end

