function colormap = getCircularColormap(dataRange)

startMap = hsv; % get standard hsv colormap

mapLength = 64;

front = startMap(1:43,:);
back = startMap(44:mapLength,:);

colormap = [back; front];

colormap = flipud(colormap);

% at this point, the colormap is at 0 for bottom and top, going through
% light blue, greeen, yellow, red, pinks, going from bottom to top

bot = dataRange(1);
top = dataRange(2);

if bot ~= 0 && top ~= 0  && bot < 0 && top > 0 % put blue at 0 in this range
    zeroPoint = abs(bot);
    range = top - bot;
    
    ratio = zeroPoint ./ range;
    
    cutPoint = round(ratio * mapLength);
    
    front = colormap(1:cutPoint,:);
    back = colormap(cutPoint+1:mapLength,:);
    
    colormap = [back; front];
end

end
