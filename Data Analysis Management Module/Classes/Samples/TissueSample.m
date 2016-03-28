classdef TissueSample < Sample
    %TissueSample
    
    properties
        source = []; %TissueSampleSourceTypes
        timeOfRemoval = []; %enucleation for eyes
        timeOfProcessing = []; %may be empty
        dateReceived = []; %date Campbell's Lab received it
        storageLocation = '';
    end
    
    methods
        function [sourceString, timeOfRemovalString, timeOfProcessingString, dateReceivedString, storageLocationString] = getTissueSampleMetadataString(sample)
            sourceString = ['Sample Source: ', displayType(sample.source)];
            timeOfRemovalString = ['Time of Removal: ', displayDateAndTime(sample.timeOfRemoval)];
            timeOfProcessingString = ['Time of Processing: ', displayDateAndTime(sample.timeOfProcessing)];
            dateReceivedString = ['Date Received: ', displayDate(sample.dateReceived)];
            storageLocationString = ['Storage Location: ', sample.storageLocation];
        end
    end
    
end

