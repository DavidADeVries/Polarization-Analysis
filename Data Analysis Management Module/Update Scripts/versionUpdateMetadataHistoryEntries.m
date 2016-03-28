function newMetadataHistory = versionUpdateMetadataHistoryEntries(metadataHistory, emptyObject)
%versionUpdateMetadataHistoryEntries

numEntries = length(metadataHistory);

newMetadataHistory = cell(numEntries, 1);

for i=1:numEntries
    newEntry = MetadataHistoryEntry;
    oldEntry = metadataHistory{i};
    
    newEntry.userName = oldEntry.userName;
    newEntry.timestamp = oldEntry.timestamp;
    newEntry.cachedObject = emptyObject;
    
    newMetadataHistory{i} = newEntry;
end

end

