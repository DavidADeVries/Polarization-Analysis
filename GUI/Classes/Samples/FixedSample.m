classdef FixedSample < TissueSample
    %FixedSample
    
    properties
        initialFixative = []; %FixativeTypes
        initialFixativePercent = []; % numeric
        initialFixingTime = [];
        
        secondaryFixative = []; %FixativeTypes
        secondaryFixativePercent = []; %numeric
        secondaryFixingTime = [];
    end
    
    methods
        
        function [initFixativeString, initFixPercentString, initFixTimeString, secondFixativeString, secondFixPercentString, secondFixTimeString] = getFixedSampleMetadataString(sample)
            initFixativeString = ['Initial Fixative: ', displayType(sample.initialFixative)];
            initFixPercentString = ['Initial Fixative %: ', num2str(sample.initialFixativePercent)];
            initFixTimeString = ['Initial Fixing Time: ', displayDateAndTime(sample.initialFixingTime)];
            
            secondFixativeString = ['Secondary Fixative: ', displayType(sample.secondaryFixative)];
            secondFixPercentString = ['Secondary Fixative %: ', num2str(sample.secondaryFixativePercent)];
            secondFixTimeString = ['Secondary Fixing Time: ', displayDateAndTime(sample.secondaryFixingTime)];            
        end
        
    end
    
end

