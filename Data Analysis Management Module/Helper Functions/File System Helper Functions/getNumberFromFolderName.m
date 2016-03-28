function number = getNumberFromFolderName(folderName)
%getNumberFromFolderName
%goes through a folder name and extracts the first number present in the
%name

numString = '';
numStart = false;

for i=1:length(folderName)
    char = folderName(i);
    
    if isstrprop(char, 'digit')
        numString = strcat(numString, char);
        
        numStart = true;
    else
        if numStart
            break;
        end
    end
end

number = str2double(numString);

end

