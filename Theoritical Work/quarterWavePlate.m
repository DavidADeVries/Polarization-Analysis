function m = quarterWavePlate(angle)
% generates quarter wave plate matrix according to collett's definition

s = sind(2*angle);
c = cosd(2*angle);

m = [1 0 0 0; 0 c^2 s*c s; 0 s*c s^2 -c; 0 -s c 0];