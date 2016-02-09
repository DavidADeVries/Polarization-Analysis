classdef Subject
    %subject
    
    properties
        dirName
        
        subjectId % person ID, dog name
        
        subjectNumber
        
        metadataHistory
                
        notes
    end
    
    methods
        function subject = createDirectories(subject, toTrialPath, handles)
            subjectDirectory = createDirName(SubjectNamingConventions.DIR_PREFIX, num2str(subject.subjectNumber), subject.subjectId);
            
            createObjectDirectories(handles.localPath, toTrialPath, subjectDirectory);
                        
            subject.dirName = subjectDirectory;
        end
        
        function [] = saveMetadata(subject, toSubjectPath, handles, saveToBackup)
            saveObjectMetadata(subject, handles.localPath, toSubjectPath, SubjectNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
    end
    
end

