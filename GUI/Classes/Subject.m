classdef Subject
    %subject
    
    properties
        % set at initialization
        dirName        
        metadataHistory
        
        % set by metadata entry        
        subjectId % person ID, dog name        
        subjectNumber                
        notes
    end
    
    methods
        function subject = createDirectories(subject, toTrialPath, projectPath)
            subjectDirectory = createDirName(SubjectNamingConventions.DIR_PREFIX, num2str(subject.subjectNumber), subject.subjectId);
            
            createObjectDirectories(projectPath, toTrialPath, subjectDirectory);
                        
            subject.dirName = subjectDirectory;
        end
        
        function [] = saveMetadata(subject, toSubjectPath, projectPath, saveToBackup)
            saveObjectMetadata(subject, projectPath, toSubjectPath, SubjectNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function [subjectIdString, subjectNumberString, subjectNotesString] = getSubjectMetadataString(subject)
            
            subjectIdString = ['Subject ID: ', subject.subjectId];
            subjectNumberString = ['Subject Number: ', num2str(subject.subjectNumber)];
            subjectNotesString = ['Notes: ', subject.notes];

        end
    end
    
end

