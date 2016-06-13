classdef MuellerMatrixNormalizationTypes
    % MuellerMatrixNormalizationTypes
    
    properties
        displayString
        explanationString
    end
    
    enumeration
        none            ('No Additional Normalization', 'No additional normalization is applied.')
        pixelWiseMM00   ('Pixel-Wise MM(0,0) Normalization', 'For each pixel in the image, the (0,0) index of the Mueller Matrix is taken and each other index is divided by this value. By using this type of normalization, the (0,0) image will be all 1''s.')
        pixelWiseMax    ('Pixel-Wise Max Normalization', 'For each pixel in the image, the max index of the Mueller Matrix for the pixel is found, and each other index is divided by this value. This type of normalization guarantees all pixels will have a Mueller Matrix with valid values.')
        mm00Max         ('Max 0,0 Index Normalization', 'The maximum value of the "0,0" index pixels is found. All pixels are then divided by this value. By using this type of normalization, the "0,0" image will show detail.')
        allIndexMax     ('All Index Max Normalization', 'The maximum value of all Mueller Matrix indices across all pixels is found, and all Mueller Matrix values for all pixels are all divided by this value. This type of normalization guarantees all pixels will have a Muellere Matrix with valid values.')
    end
    
    methods
        function enum = MuellerMatrixNormalizationTypes(displayString, explanationString)
            enum.displayString = displayString;
            enum.explanationString = explanationString;
        end
    end
    
end

