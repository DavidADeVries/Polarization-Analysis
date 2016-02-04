classdef Trial
    %Trial
    %holds metadata and more important directory location for a trial
    
    properties
        dirName
        
        title
        description
        
        trialNumber
        
        subjects
        subjectIndex = 0
        
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
            
            trial.subjects = createEmptyCellArray(trial.subjectType.subjectClass, numSubjects);
            
            for i=1:numSubjects
                trial.subjects{i} = trial.subjects{i}.loadSubject(trialPath, subjectDirs{i});
            end
            
            if ~isempty(trial.subjects)
                trial.subjectIndex = 1;
            end
        end
        
        function subject = createNewSubject(trial)
            subject = trial.subjectType.subjectClass;
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
                
                if trial.subjectIndex == 0
                    trial.subjectIndex = 1;
                end
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
        
        function subject = getSelectedSubject(trial)
            subject = [];
            
            if trial.subjectIndex ~= 0
                subject = trial.subjects{trial.subjectIndex};
            end
        end
        
        function handles = updateNavigationListboxes(trial, handles)
            numSubjects = length(trial.subjects);
            
            subjectOptions = cell(numSubjects, 1);
            
            if numSubjects == 0
                disableNavigationListboxes(handles, handles.subjectSelect);
            else
                for i=1:numSubjects
                    subjectOptions{i} = trial.subjects{i}.dirName;
                end
                
                set(handles.subjectSelect, 'String', subjectOptions, 'Value', trial.subjectIndex, 'Enable', 'on');
                
                handles = trial.getSelectedSubject().updateNavigationListboxes(handles);
            end
        end
        
        function handles = updateMetadataFields(trial, handles)
            subject = trial.getSelectedSubject();
                        
            if isempty(subject)
                disableMetadataFields(handles, handles.subjectMetadata);
            else
                metadataString = subject.getMetadataString();
                
                set(handles.subjectMetadata, 'String', metadataString);
                
                handles = subject.updateMetadataFields(handles);
            end
        end
        
        function metadataString = getMetadataString(trial)
            metadataString = {'Trial Metadata'};
        end
        
        function trial = updateSubjectIndex(trial, index)            
            trial.subjectIndex(index) = index;
        end
        
        function trial = updateEyeIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateEyeIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateQuarterSampleIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateQuarterSampleIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateLocationIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateLocationIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateSessionIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateSessionIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateSubfolderIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateSubfolderIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function trial = updateFileIndex(trial, index)
            subject = trial.getSelectedSubject();
            
            subject = subject.updateFileIndex(index);
            
            trial = trial.updateSubject(subject);
        end
        
        function fileSelection = getSelectedFile(trial)
            subject = trial.getSelectedSubject();
            
            if ~isempty(subject)
                fileSelection = subject.getSelectedFile();
            else
                fileSelection = [];
            end
        end
    end
    
end

