function circDataInColumn = convertCircData(dataInColumn, dataRange)
% convertCircData

neededRange = [0,360]; %want circular stats to match up with this range

neededInterval = neededRange(2) - neededRange(1);
interval = dataRange(2) - dataRange(1);

shift = neededRange(1) - dataRange(1);
scale = neededInterval / interval;

circDataInColumn = scale .* (dataInColumn + shift);

end

