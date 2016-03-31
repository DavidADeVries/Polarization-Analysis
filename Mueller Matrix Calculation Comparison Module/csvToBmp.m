comparedData = getAllFiles('C:\Comparison Program\Compared Files\Camille Spot 4\Retardance');

for i = 1:length(comparedData)
    
    comparedDataValues = csvread(comparedData{i});
    
    [~ ,fileName, ~] = fileparts(comparedData{i});
    
    imwrite(comparedDataValues ,strcat('C:\Comparison Program\Compared Files\Camille Spot 4\Retardance\', fileName, '.bmp'));
    
    
end