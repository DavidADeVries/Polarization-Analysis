classdef MuellerMatrixNormalizationTypes
    % MuellerMatrixNormalizationTypes
    
    properties
        displayString
        explanationString
    end
    
    enumeration
        pixelWise   ('Pixel-Wise Normalization', 'For each pixel in the image, the "0,0" index of the Mueller Matrix is taken and each other index is divided by this value. By using this type of normalization, the "0,0" image will be all 1''s.')
        mm00Max     ('Max 0,0 Index Normalization', 'The maximum value of the "0,0" index pixels is found. All pixels are then divided by this value. By using this type of normalization, the "0,0" image will show detail.')
    end
    
    methods
        function enum = MuellerMatrixNormalizationTypes(displayString, explanationString)
            enum.displayString = displayString;
            enum.explanationString = explanationString;
        end
    end
    
end
