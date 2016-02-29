function [ converted_value ] = convert_from_circ_stat(metric_label, value, apply_shift)
%take a value and reverse the shifts/scaling done to it to have circular
%stats performed. Also converts back to degrees.
%all values are assumed to have been given from 0..2pi

radToDeg = 180 / pi;

%these stats run from 0 - 180
if strcmp(metric_label, 'Retardance (Circ)') || strcmp(metric_label, 'Linear Retardance (Circ)') || strcmp(metric_label, 'Delta (Circ)')
    converted_value = value .* radToDeg;
    converted_value = converted_value ./ 2; %0 - 360
    
    %these stats run from -180 - 180
elseif strcmp(metric_label, 'Horizontal Retardance (Circ)') || strcmp(metric_label, '45 deg Retardance (Circ)') || strcmp(metric_label, 'Circular Retardance (Circ)') || strcmp(metric_label, 'Optical Rotation (Circ)')
   converted_value = value .* radToDeg;
    
    % for mean or median values
    if apply_shift
        converted_value = converted_value - 180; %0 - 360
    end
        
    %these stats run from 0 - 90
elseif strcmp(metric_label, 'Rho 1 (Circ)')
   converted_value = value .* radToDeg;
    converted_value = converted_value ./ 4; %0 - 360
    
    %these stats run from -90 - 90
elseif strcmp(metric_label, 'Rho 2 (Circ)') || strcmp(metric_label, 'Theta (Circ)')
    converted_value = value .* radToDeg;
    converted_value = converted_value ./ 2;
    
    if apply_shift
        converted_value = converted_value - 90; % 0 - 360    
    end
else
    converted_value = value .* radToDeg;
end

end

