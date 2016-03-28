function coordsString = coordsToString(coords)
%Turns the coordinates into a displayable string

coordsString = '[';

numArgs = length(coords);

for i=1:numArgs
    coordsString = [coordsString, num2str(coords(i))];
    
    if i ~= numArgs
        coordsString = [coordsString, ', '];
    end
end

coordsString = [coordsString, ']'];

end




