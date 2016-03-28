function [] = disableMetadataFields(handles, lastDisabledMetadataField)
% disableMetadataFields
% disable all metadata fields below a certain cutoff, given by
% the lastDisabledMetadata handle (e.g. handles.locationMetadata)

listboxes = {   handles.sessionMetadata,...
                handles.locationMetadata,...
                handles.sampleMetadata,...
                handles.subjectMetadata,...
                handles.trialMetadata}; %ordered in a hierarchy low to bottom

for i=1:length(listboxes)
    handle = listboxes{i};
    
    set(handle, 'String', {'None Available'});
    
    if handle == lastDisabledMetadataField
        break;
    end
end


end

