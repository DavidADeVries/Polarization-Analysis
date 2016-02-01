classdef Trial
    %Trial
    %holds metadata and more important directory location for a trial
    
    properties
        dirName
        
        title
        description
        
        trialNumber
        
        subjects
        subjectType % natural, artifical
        
        notes
    end
    
    methods        
        function trial = loadTrial(trial, toTrialPath, trialDir)
            trialPath = makePath(toTrialPath, trialDir);

            % load metadata
            vars = load(makePath(trialPath, TrialNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
            trial = vars.metadata;
            
            % load dir name
            trial.dirName = trialDir;
            
            % load subjects            
            subjectDirs = getMetadataFolders(trialPath, SubjectNamingConventions.METADATA_FILENAME);
            
            numSubjects = length(subjectDirs);
            
            if trial.subjectType == SubjectTypes.Natural
                trial.subjects = createEmptyCellArray(NaturalSubject, numSubjects);
            elseif trial.subjectType == SubjectTypes.Artifical
                trial.subjects = createEmptyCellArray(ArtificalSubject, numSubjects);
            else
                error('Invalid subject type');
            end
            
            for i=1:numSubjects
                trial.subjects{i} = trial.subjects{i}.loadSubject(trialPath, subjectDirs{i});
            end
        end
        
        function subject = createNewSubject(trial)
            if trial.subjectType == SubjectTypes.Natural
                subject = NaturalSubject;
            elseif trial.subjectType == SubjectTypes.Artifical
                subject = ArtificalSubject;
            else
                subject = Subject;
            end
        end
        
        function nextNumber = nextSubjectNumber(trial)
            subjects = trial.subjects;
            
            if isempty(subjects)
                nextNumber = 1;
            else
                lastNumber = subjects{length(subjects)}.subjectNumber;
                
                nextNumber = lastNumber + 1;
            end
        end
        
        function trial = updateSubject(trial, subject)
            subjects = trial.subjects;
            numSubjects = length(subjects);
            updated = false;
            
            for i=1:numSubjects
                if subjects{i}.subjectNumber == subject.subjectNumber
                    trial.subjects{i} = subject;
                    updated = true;
                    break;
                end
            end
            
            if ~updated % add new subject
                trial.subjects{numSubjects + 1} = subject;
            end            
        end
        
        function subjectIds = getSubjectIds(trial)
            subjects = trial.subjects;
            numSubjects = length(subjects);
            
            subjectIds = cell(numSubjects, 1);
            
            for i=1:numSubjects
                subjectIds{i} = subjects{i}.subjectId;
            end
            
        end
        
    end
    
end

