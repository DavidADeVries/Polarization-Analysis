function label = createNavigationListboxLabel(prefix, number, subtitle)
% createNavigationListboxLabel
% parses together these three pieces to give a label for use in the
% navigation listboxes


label = [prefix, ' ', num2str(number)];

if ~isempty(subtitle)
    label = [label, ' (', subtitle, ')'];
end


end