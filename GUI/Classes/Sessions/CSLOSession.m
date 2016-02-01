classdef CSLOSession < DataCollectionSession
    %CSLOSession
    %holds metadata for images taken in a CSLO
    
    properties
        magnification
        pixelSizeMicrons % size of pixel in microns (used for generating scale bars)
        instrument
        pinholeSizeMicrons %diameter of pinhole in microns
        lightLevelMicroWatts %laser output level in microwatts
        
        % these three describe how the deposit was found
        fluoroSignature % T/F
        crossedSignature % T/F
        visualSignature % T/F
    end
    
    methods
    end
    
end
