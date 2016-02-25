function strings = generateMetadataHistoryStrings(metadataHistoryEntries)
% generateMetadataHistoryStrings
% generates cell array of strings for the metadata fields

strings = {'Metadata Edit History:'};

if isempty(metadataHistoryEntries)
    strings{2} = 'No Entries';
else
    numEntries = length(metadataHistoryEntries);
    
    for i=1:numEntries
        entry = metadataHistoryEntries{i};
        strings{i+1} = [entry.getDateString(), ': ', entry.userName];
    end
end
    
    


end

