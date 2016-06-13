function MM_norm = normalizeMM(MM, normalizationType )
% normalizeMM

colHeight = length(MM);

% allocate memory for normalized MM
MM_norm = zeros(colHeight,4,4);

% normalize the MM
switch normalizationType
    case MuellerMatrixNormalizationTypes.none
        
        MM_norm = MM;
        
    case MuellerMatrixNormalizationTypes.pixelWiseMM00
        
        parfor i=1:colHeight
            pixelMM = squeeze(MM(i,:,:));
            
            pixelMM_norm = pixelMM ./ pixelMM(1,1);
            
            MM_norm(i,:,:) = pixelMM_norm;
        end
        
    case MuellerMatrixNormalizationTypes.pixelWiseMax
        
        parfor i=1:colHeight
            pixelMM = squeeze(MM(i,:,:));
            
            maxValue = max(max(abs(pixelMM)));
            
            pixelMM_norm = pixelMM ./ maxValue;
            
            MM_norm(i,:,:) = pixelMM_norm;
        end
        
    case MuellerMatrixNormalizationTypes.mm00Max
        
        mm00 = MM(:,1,1);
        
        maxValue = max(abs(mm00));
        
        MM_norm = MM ./ maxValue;
        
    case MuellerMatrixNormalizationTypes.allIndexMax
        
        maxValue = max(max(max(abs(MM))));
        
        MM_norm = MM ./ maxValue;
        
    otherwise
        error('Invalid Normalization Type');
end

end

