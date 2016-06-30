function excelColNames = getExcelColHeaders()
% getExcelColHeaders

aToZ = char(65:90);

excelColNames = {};
index = 1;

for i=1:length(aToZ)
    excelColNames{index} = aToZ(i);
    
    index = index + 1;
end

for i=1:length(aToZ)
    for j=1:length(aToZ)
        excelColNames{index} = [aToZ(i), aToZ(j)];
        
        index = index + 1;
    end
end


end

