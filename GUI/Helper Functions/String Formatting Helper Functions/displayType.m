function string = displayType(type)
%displayType

if isempty(type)
    string = 'None Selected';
else
    string = type.displayString;
end

end

