function numbers = getNumbersFromFolderNames(folderNames)
%getNumbersFromFolderNames
%goes through a folder name cell array and extracts the first number present in the
%name
%returns cell array list of same size. If no number was found, the cell
%array entry will be empty

numbers = cell(size(folderNames));

for i=1:length(folderNames)
    folderName = folderNames{i};
    
    numString = '';
    numStart = false;
    
    for j=1:length(folderName)
        char = folderName(j);
        
        if isstrprop(char, 'digit')
            numString = strcat(numString, char);
            
            numStart = true;
        else
            if numStart
                break;
            end
        end
    end
    
    if ~isempty(numString)
        numbers{i} = str2double(numString);
    end
    
end

end

