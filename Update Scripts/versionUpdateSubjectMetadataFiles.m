function [] = versionUpdateSubjectMetadataFiles(subject, projectPath, toPath)
%updateSubject

% ** UPDATE REQUIRED INFORMATION **

subject.uuid = generateUUID();

if isa(subject, 'NaturalSubject')
    subject.metadataHistory = versionUpdateMetadataHistoryEntries(subject.metadataHistory, NaturalSubject.empty);
else
    error('Unknown Class!');
end

% ** SAVE IT **

metadataFilename = SubjectNamingConventions.METADATA_FILENAME;
saveToBackup = true;

toPath = makePath(toPath, subject.dirName);

saveObjectMetadata(subject, projectPath, toPath, metadataFilename, saveToBackup);


% ** RECURSE ON NEXT LEVEL **

if isa(subject, 'NaturalSubject')
    for i=1:length(subject.eyes)
        versionUpdateEyeMetadataFiles(subject.eyes{i}, projectPath, toPath);
    end
end

end

