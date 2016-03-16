classdef TissueSample < Sample
    %TissueSample
    
    properties
        source = []; %TissueSampleSourceTypes
        timeOfRemoval = 0; %enucleation for eyes
        timeOfProcessing = 0; %may be empty
        dateReceived = 0; %date Campbell's Lab received it
        storageLocation = '';
    end
    
    methods
        function [sourceString, timeOfRemovalString, timeOfProcessingString, dateReceivedString, storageLocationString] = getTissueSampleMetadataString(sample)
            sourceString = ['Sample Source: ', sample.source.displayString];
            timeOfRemovalString = ['Time of Removal: ', displayDateAndTime(sample.timeOfRemoval)];
            timeOfProcessingString = ['Time of Processing: ', displayDateAndTime(sample.timeOfProcessing)];
            dateReceivedString = ['Date Received: ', displayDate(sample.dateReceived)];
            storageLocationString = ['Storage Location: ', sample.storageLocation];
        end
    end
    
end

