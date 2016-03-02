function object = updateMetadataHistory(object, userName)
% updateMetadataHistory
% updates the metadata history field for any object with a
% '.metadataHistory' field

entry = MetadataHistoryEntry(userName);
object.metadataHistory = [object.metadataHistory, {entry}];

end