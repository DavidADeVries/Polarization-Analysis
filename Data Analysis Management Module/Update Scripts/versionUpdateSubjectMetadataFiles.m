function [] = versionUpdateSubjectMetadataFiles(projectPath, toPath)
%updateSubject

% ** READ IN METADATA FILE **

vars = load(makePath(projectPath, toPath, 'subject_metadata.mat'), Constants.METADATA_VAR);
metadata = vars.metadata;

if isa(metadata, 'NaturalSubject')
    
    % ** UPDATE REQUIRED INFORMATION **
    
    metadata.timeOfDeath = [];
    metadata.diagnoses = {};
    
    
    % ** SAVE IT **
    
    metadataFilename = SubjectNamingConventions.METADATA_FILENAME;
    saveToBackup = true;
    
    saveObjectMetadata(metadata, projectPath, toPath, metadataFilename, saveToBackup);
    
    
    % ** RECURSE ON NEXT LEVEL **
    
    folders = getAllFolders(makePath(projectPath, toPath));
    
    for i=1:length(folders)
        versionUpdateSampleMetadataFiles(projectPath, makePath(toPath, folders{i}));
    end
else
    error(['Unknown class at: ', toPath]);
end

end

