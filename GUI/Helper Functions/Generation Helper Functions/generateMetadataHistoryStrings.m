function strings = generateMetadataHistoryStrings(metadataHistory)
% generateMetadataHistoryStrings
% generates cell array of strings for the metadata fields

strings = 'Metadata Edit History:';

metadataStrings = generateMetadataStringsRecursive(metadataHistory, {});

if isempty(metadataStrings)
    strings{2} = 'No Entries';
else
    strings = [strings, metadataStrings];
end
    
end

function strings = generateMetadataStringsRecursive(metadataHistory, strings)
    newString = [displayDate(metadataHistory.timestamp), ': ', metadataHistory.userName];
    
    strings = [strings, newString];

    cachedObject = metadataHistory.cachedObject;

    if ~isempty(cachedObject)
        strings = generateMetadataStringsRecursive(cachedObject.metadataHistory, strings);
    end
end