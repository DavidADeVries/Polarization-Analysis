classdef ProcessingTypes
    %ProcessingTypes
    
    properties
        displayString
    end
    
    enumeration
        Registration            ('Registration')
        FrameAveraging          ('Frame Averaging')
        AreaCropping            ('Area Cropping')
        PolarizationAnalysis    ('Polarization Analysis')
        Unknown                 ('Unknown')
    end
    
    methods
        function enum = ProcessingTypes(string)
            enum.displayString = string;
        end
    end
    
end

