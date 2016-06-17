function [posData, negData] = getPosNegWithMask(data, mask)
% getPosNegWithMas

% first reshape into col vectors

maskDims = size(mask);
maskColLength = maskDims(1) * maskDims(2);

maskCol = reshape(mask, maskColLength, 1);

for i=length(data)
    image = data{i};
    
    dims = size(image);
    
    colLength = dims(1)*dims(2);
    
    if maskColLenght == colLength
        dataCol = reshape(image, colLength, 1);
        
        posData{i} = dataCol(maskCol);
        negData{i} = dataCol(~maskCol);
    else        
        error('Dimensions do not agree!');
    end
    
end


end

