function handle = popupMessage(text, title)
% popupMessage
% have window pop open that will be deleted by Matlab whenever the process
% it is working on is complete

handle = dialog('Name',title);

position = get(handle, 'Position');

location = position(1:2);

size = [300, 100];

grey = 0.9 * [1 1 1];

set(handle, 'Position', [location, size], 'Color', grey);

uicontrol('Parent', handle, 'Position', [20, 30, 260, 40], 'BackgroundColor', grey, 'Style', 'text', 'String', text, 'FontSize', 11);

drawnow; %make sure it shows up.

end

