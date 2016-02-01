classdef Project
    %Project
    % contains project metadata
    
    properties
        title
        description
        
        trials
        
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
    end
    
end

