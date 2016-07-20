function equation = setIndicesOrEquation(colHeader, locationRowIndices)
% setIndicesOrEquation

    equation = '=INT(OR(';
    
    prevIndex = [];
    
    beginIndex = [];
    
    lastIndex = [];
    
    numIndices = length(locationRowIndices);
    
    for i=1:numIndices
        index = locationRowIndices(i);
        
        if isempty(prevIndex)
            
            beginIndex = index;
            
            if numIndices == 1 % only one index
                equation = [equation, colHeader, num2str(index)];
            end
        elseif prevIndex ~= index - 1 || i == numIndices %no longer consectutive or end
            if i == numIndices
                endIndex = prevIndex;
                lastIndex = index;
                
                if endIndex == lastIndex - 1
                    endIndex = lastIndex;
                end
                
                comma = ''; % don't want comma
            else
                endIndex = prevIndex;
                
                comma = ','; %want the comma!
            end
            
            if beginIndex == endIndex
                equation = [equation, colHeader, num2str(beginIndex), comma];
            else
                equation = [equation, colHeader, num2str(beginIndex), ':', colHeader, num2str(endIndex), comma];
            end
            
            if i == numIndices && lastIndex ~= endIndex % need to account for possible single last index
                equation = [equation, ',', colHeader, num2str(lastIndex)];
            end
            
            % now reset beginIndex
            beginIndex = index;
        end
        
        prevIndex = index;
    end
    
    equation = [equation, '))'];
    
end

