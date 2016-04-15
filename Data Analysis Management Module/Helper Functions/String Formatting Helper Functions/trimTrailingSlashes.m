function trimmedString = trimTrailingSlashes(string)
% trimTrailingSlashes

endIndex = length(string) + 1;

for i=endIndex-1:-1:1
    if string(i) == Constants.SLASH
        endIndex = i;
    else
        break;
    end
end

trimmedString = string(1:endIndex-1);

end

