function [ metric_labels ] = standard_metric_labels()
%standard_metric_labels
%   gives the list of all the metrics determined by the analysis program
%   For the exhaustive list including circular stats labels, see
%   'exhaustive_metric_labels'

metric_labels = [
    cellstr('Diattenuation');
    cellstr('Linear Diattenuation'); 
    cellstr('Horizontal Diattenuation'); 
    cellstr('45 deg Diattenuation'); 
    cellstr('Circular Diattenuation');
    cellstr('Polarizance');
    cellstr('Linear Polarizance'); 
    cellstr('Horizontal Polarizance'); 
    cellstr('45 deg Polarizance'); 
    cellstr('Circular Polarizance');
    cellstr('Retardance');
    cellstr('Linear Retardance'); 
    cellstr('Horizontal Retardance'); 
    cellstr('45 deg Retardance'); 
    cellstr('Circular Retardance');
    cellstr('Optical Rotation');  
    cellstr('Depolarization Index');
    cellstr('Degree of Polarization');
    cellstr('Q Metric');    
    cellstr('Rho 1');   
    cellstr('Rho 2');
    cellstr('Theta');
    cellstr('Delta');
    cellstr('Rho 1 Approx');
    cellstr('Rho 2 Approx');    
    cellstr('Theta Approx');
    cellstr('Delta Approx');];

end

