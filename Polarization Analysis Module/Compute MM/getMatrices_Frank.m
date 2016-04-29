function [ M_G, M_A ] = getMatrices_Frank()
% getMatrices_Frank

% Mueller Matrix of a Horizontal Linear Polarization

MM_HLP = 0.5* [1 1 0 0; 1 1 0 0; 0 0 0 0; 0 0 0 0];

% angles that we use when acquiring the data
angle_neg_45 = -45;
angle_00 = 0;
angle_30 = 30;
angle_60 = 60;

% the above angles are determined looking down the beam, so we need to flip
% them to represent looking into the beam, which will then match the
% conventions used in Collett

angle_neg_45 = -angle_neg_45;
angle_00 = -angle_00;
angle_30 = -angle_30;
angle_60 = -angle_60;

% get MM for the quarter wave plate for each angle
MM_QWP_neg_45 = MM_QWP(angle_neg_45);
MM_QWP_00 = MM_QWP(angle_00);
MM_QWP_30 = MM_QWP(angle_30);
MM_QWP_60 = MM_QWP(angle_60);


% calculate MM for PSG (M_G) and PSA (M_A)

% ** PSG **
% Calculation of M_G, as outlined in Bueno/Campbell Paper
% each column is the Stokes vector of light exiting from the 4 generator
% states. The input light into the generator is unpolarized light.

S = [1;0;0;0]; % unpolarized input light

S_out_neg_45 = MM_QWP_neg_45 * MM_HLP * S;
S_out_00 = MM_QWP_00 * MM_HLP * S;
S_out_30 = MM_QWP_30 * MM_HLP * S;
S_out_60 = MM_QWP_60 * MM_HLP * S;

M_G = [S_out_neg_45 S_out_00 S_out_30 S_out_60];


% ** PSA **
% Calculation of M_A, as outlined in Bueno/Campbell Paper, the Mueller
% Matrix of each PSA position (HLP*QWP) is found
% The first row of each MM is then extracted, and then each first row is
% used to form the four rows of M_A

MM_A_neg_45 = MM_HLP * MM_QWP_neg_45;
MM_A_00 = MM_HLP * MM_QWP_00;
MM_A_30 = MM_HLP * MM_QWP_30;
MM_A_60 = MM_HLP * MM_QWP_60;

top_row_neg_45 = MM_A_neg_45(1,:);
top_row_00 = MM_A_00(1,:);
top_row_30 = MM_A_30(1,:);
top_row_60 = MM_A_60(1,:);

M_A = [top_row_neg_45; top_row_00; top_row_30; top_row_60];


end

% generates the Mueller Matrix for a quarter wave plate at an angle in
% degrees
function mm = MM_QWP(angle)
    s = sind(2*angle);
    c = cosd(2*angle);
    
    % MM according to Kligers's definition (fast axis at angle from horizontal)
    % this describes our system because the white the line, is the fast axis
    mm = [1 0 0 0; 0 c^2 s*c -s; 0 s*c s^2 c; 0 s -c 0];     
    
end