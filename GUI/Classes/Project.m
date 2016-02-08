classdef Project
    %Project
    % contains project metadata
    
    properties
        title
        description
        
        trials
        trialIndex = 0
        
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
            project.trials = createEmptyCellArray(Trial, numTrials);
            
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
    end
    
end

