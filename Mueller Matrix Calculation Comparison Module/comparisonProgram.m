

directoryList = {'Diattenuation', 'DOP, DI, and Q Metric', 'MM - Max m_00 Norm', 'MM - Pixelwise Norm', 'Polarizance', 'Related Retardance Metrics', 'Retardance'};
excelMaxList = {'B2:B6', 'B7:B9', 'B10:B41', 'B42:B73' 'B74:B78', 'B79:B86', 'B87:B92'};
excelMinList = {'C2:C6', 'C7:C9', 'C10:C41', 'C42:C73' 'C74:C78', 'C79:C86', 'C87:C92'};
for j = 1:length(directoryList)
    oldData = getAllFiles(strcat('C:\Michael Images (David''s Original Program)\Tanner\Processed\Spot 13\Entire Image\', directoryList{j}, '\CSVs'));
    newData = getAllFiles(strcat('C:\Michael Images (New Analysis Program)\Tanner\Processed\Spot 13\Entire Image\', directoryList{j}, '\CSVs'));
    listOfMax = [];
    listOfMin = [];
    mkdir('C:\Comparison Program\Compared Files\Tanner Spot 13\', directoryList{j});
    for i = 1:length(oldData)
        
        oldDataValues = csvread(oldData{i});
        newDataValues = csvread(newData{i});
        
        comparedFile = newDataValues - oldDataValues;
        
        maximumDifference = max(max(comparedFile));
        minimumDifference = min(min(comparedFile));
        
        listOfMax(i) = maximumDifference;
        listOfMin(i) = minimumDifference;
        
        [~ ,fileName, ~] = fileparts(oldData{i});
        
        csvwrite(strcat('C:\Comparison Program\Compared Files\Tanner Spot 13\', directoryList{j}, '\', fileName, '_Comparison', '.csv'), comparedFile);
        imwrite(comparedFile ,strcat('C:\Comparison Program\Compared Files\Tanner Spot 13\', directoryList{j}, '\', fileName, '_Comparison', '.bmp'));
        
    end
    
    xlswrite('C:\Comparison Program\Compared Files\Tanner Spot 13\Max and Min Values.xlsx', flipud(rot90(listOfMax)), excelMaxList{j});
    xlswrite('C:\Comparison Program\Compared Files\Tanner Spot 13\Max and Min Values.xlsx', flipud(rot90(listOfMin)), excelMinList{j});
    Max = listOfMax
    Min = listOfMin
end

