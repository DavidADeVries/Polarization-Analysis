function string = convertBoolToExcelBool(bool)
%convertBoolToExcelBool

    if bool
        string = 'TRUE';
    else
        string = 'FALSE';
    end
end

