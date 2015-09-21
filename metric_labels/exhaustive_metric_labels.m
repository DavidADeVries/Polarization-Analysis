function [ metric_labels ] = exhaustive_metric_labels()
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
    cellstr('Retardance (Circ)');
    cellstr('Linear Retardance (Circ)'); 
    cellstr('Horizontal Retardance (Circ)'); 
    cellstr('45 deg Retardance (Circ)'); 
    cellstr('Circular Retardance (Circ)');
    cellstr('Optical Rotation (Circ)');
%     cellstr('Retardance (Abs)');
%     cellstr('Linear Retardance (Abs)'); 
%     cellstr('Horizontal Retardance (Abs)'); 
%     cellstr('45 deg Retardance (Abs)'); 
%     cellstr('Circular Retardance (Abs)');
%     cellstr('Optical Rotation (Abs)'); 
    cellstr('Retardance (Non-Circ)');
    cellstr('Linear Retardance (Non-Circ)'); 
    cellstr('Horizontal Retardance (Non-Circ)'); 
    cellstr('45 deg Retardance (Non-Circ)'); 
    cellstr('Circular Retardance (Non-Circ)');
    cellstr('Optical Rotation (Non-Circ)'); 
    cellstr('Depolarization Index');
    cellstr('Degree of Polarization');
    cellstr('Q Metric');    
    cellstr('Rho 1 (Circ)');    
    cellstr('Rho 2 (Circ)');  
    cellstr('Theta (Circ)');    
    cellstr('Delta (Circ)');   
%     cellstr('Rho 1 (Abs)');    
%     cellstr('Rho 1 Approx (Abs)');
%     cellstr('Rho 2 (Abs)');
%     cellstr('Rho 2 Approx (Abs)');  
%     cellstr('Theta (Abs)');    
%     cellstr('Theta Approx (Abs)');
%     cellstr('Delta (Abs)');   
%     cellstr('Delta Approx (Abs)');
    cellstr('Rho 1 (Non-Circ)'); 
    cellstr('Rho 2 (Non-Circ)');
    cellstr('Theta (Non-Circ)'); 
    cellstr('Delta (Non-Circ)'); 
    
    cellstr('Rho 1 Approx');
    cellstr('Rho 2 Approx');   
    cellstr('Theta Approx');     
    cellstr('Delta Approx');];

end

