function [ converted_dataset ] = convert_to_circ_stat(metric_label, dataset)
%converts a dataset to get ready for circular statistics (converts to
%radians, gets it to between 0 .. 2pi
%this is done based upon the metric label

degToRad = pi / 180;

%these stats run from 0 - 180
if strcmp(metric_label, 'Retardance (Circ)') || strcmp(metric_label, 'Linear Retardance (Circ)') || strcmp(metric_label, 'Delta (Circ)')
    converted_dataset = dataset .* 2; %0 - 360
    converted_dataset = converted_dataset .* degToRad;
    
    %these stats run from -180 - 180
elseif strcmp(metric_label, 'Horizontal Retardance (Circ)') || strcmp(metric_label, '45 deg Retardance (Circ)') || strcmp(metric_label, 'Circular Retardance (Circ)') || strcmp(metric_label, 'Optical Rotation (Circ)')
    converted_dataset = dataset + 180; %0 - 360
    converted_dataset = converted_dataset .* degToRad;
    
    %these stats run from 0 - 90
elseif strcmp(metric_label, 'Rho 1 (Circ)')
    converted_dataset = dataset .* 4; %0 - 360
    converted_dataset = converted_dataset .* degToRad;
    
    %these stats run from -90 - 90
elseif strcmp(metric_label, 'Rho 2 (Circ)') || strcmp(metric_label, 'Theta (Circ)')
    converted_dataset = (dataset + 90) .* 2; % 0 - 360
    converted_dataset = converted_dataset .* degToRad;
else
    converted_dataset = dataset .* degToRad;
end

end

