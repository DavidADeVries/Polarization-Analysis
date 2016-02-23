function m = quarterWavePlateKliger(angle)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

c = cosd(2*angle);
s = sind(2*angle);

m = [1 0 0 0; 0 c^2 s*c -s; 0 s*c s^2 c; 0 s -c 0];


end

