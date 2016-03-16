classdef FixedSample < TissueSample
    %FixedSample
    
    properties
        initialFixative = []; %FixativeTypes
        initialFixativePercent = 0; % numeric
        initialFixingTime = 0;
        
        secondaryFixative = []; %FixativeTypes
        secondaryFixativePercent = 0; %numeric
        secondaryFixingTime = 0;
    end
    
    methods
        
        function [initFixativeString, initFixPercentString, initFixTimeString, secondFixativeString, secondFixPercentString, secondFixTimeString] = getFixedSampleMetadataString(sample)
            initFixativeString = ['Initial Fixative: ', sample.initialFixative.displayString];
            initFixPercentString = ['Initial Fixative %: ', num2str(sample.initialFixativePercent)];
            initFixTimeString = ['Initial Fixing Time: ', displayDateAndTime(sample.initialFixingTime)];
            
            secondFixativeString = ['Secondary Fixative: ', sample.secondaryFixative.displayString];
            secondFixPercentString = ['Secondary Fixative %: ', num2str(sample.secondaryFixativePercent)];
            secondFixTimeString = ['Secondary Fixing Time: ', displayDateAndTime(sample.secondaryFixingTime)];            
        end
        
    end
    
end

