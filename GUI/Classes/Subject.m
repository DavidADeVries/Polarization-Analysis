classdef Subject
    %subject
    
    properties
        dirName
        
        subjectId % person ID, dog name
        
        subjectNumber
                
        notes
    end
    
    methods
        function subject = createDirectories(subject, toTrialPath, handles)
            subjectDirectory = createDirName(SubjectNamingConventions.DIR_PREFIX, num2str(subject.subjectNumber), subject.subjectId);
            
            createObjectDirectories(handles.projectDirectory, handles.localDirectory, toTrialPath, subjectDirectory);
                        
            subject.dirName = subjectDirectory;
        end
        
        function [] = saveMetadata(subject, toSubjectPath, handles, saveToBackup)
            saveObjectMetadata(subject, handles.projectDirectory, handles.localDirectory, toSubjectPath, SubjectNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
    end
    
end

