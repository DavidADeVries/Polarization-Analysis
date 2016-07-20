function string = convertBoolToExcelBool(bool)
%convertBoolToExcelBool

    if bool
        string = 1;
    else
        string = 0;
    end
end

