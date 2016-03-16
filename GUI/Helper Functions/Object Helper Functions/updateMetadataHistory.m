function object = updateMetadataHistory(object, userName)
% updateMetadataHistory
% updates the metadata history field for any object with a
% '.metadataHistory' field

cachedObject = object.wipeoutMetadataFields();

entry = MetadataHistoryEntry(userName, cachedObject);
object.metadataHistory = entry;

end