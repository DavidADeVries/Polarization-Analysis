%script for checking MM values for David's code

%depolarization
D_vector = (1/MM(1,1))*[MM(1,2); MM(1,3); MM(1, 4)]
D_lin = sqrt(D_vector(1,1)^2+D_vector(2,1)^2)
D = sqrt(D_vector(1,1)^2+D_vector(2,1)^2+D_vector(3,1)^2)

%polarization
P_vector = (1/MM(1,1))*[MM(2,1); MM(3,1); MM(4,1)]
P_lin = sqrt(P_vector(1,1)^2+P_vector(2,1)^2)
P = (1/MM(1,1))*sqrt(MM(2,1)^2 + MM(3,1)^2 + MM(4,1)^2)

%retardance
D_hat = (1/D)*(D_vector);
lilMD = sqrt(1 - D^2)*eye(3) + (1 - sqrt(1 - D^2))*D_hat*transpose(D_hat)
MD = MM(1,1)*[1, transpose(D_vector); D_vector, lilMD]
M_prime = MM/MD;
lilM_prime = M_prime(2:4, 2:4);
lambda = eig(lilM_prime*transpose(lilM_prime));
lambda_one = lambda(1,1);
lambda_two = lambda(2,1);
lambda_three = lambda(3,1);
if det(lilM_prime) < 0;
    a = -1;
else 
    a = 1;
end
b = lilM_prime*transpose(lilM_prime) + (sqrt(lambda_one*lambda_two)+...
    sqrt(lambda_two*lambda_three)+ sqrt(lambda_three*lambda_one))*eye(3);
c = (sqrt(lambda_one) + sqrt(lambda_two) + sqrt(lambda_three))*lilM_prime*transpose(lilM_prime) + ...
    sqrt(lambda_one*lambda_two*lambda_three)*eye(3);
lilM_delta = a*b\c;
lilM = MM(2:4, 2:4)/MM(1,1);
P_delta = (P_vector - lilM*D_vector)/(1-D^2);
M_delta = zeros(4);
M_delta(1,1) = 1;
M_delta(2:4, 1) = P_delta;
M_delta(2:4, 2:4) = lilM_delta;
MR = M_delta\M_prime;
lilMR = MR(2:4, 2:4);
R = acosd(trace(MR)/2 - 1);
a1 = 1/(2*sind(R))*(lilMR(2,3)-lilMR(3,2));
a2 = 1/(2*sind(R))*(lilMR(3,1)-lilMR(1,3));
a3 = 1/(2*sind(R))*(lilMR(1,2)-lilMR(2,1));
R_vector = [R*a1; R*a2; R*a3]
R_lin = sqrt(R_vector(1,1)^2+R_vector(2,1)^2)
R_magnitude = sqrt(R_vector(1,1)^2+R_vector(2,1)^2+R_vector(3,1)^2)

%angles
theta = (1/2)*atand(a3/a2)
delta = 2*acosd(sqrt(a3^2*(1-(cosd(R/2))^2)+(cosd(R/2)^2)))
psi = acosd(cosd(R/2)/cosd(delta/2))

%Q and depolarization index
sumpartMM = sum(sum(MM(2:4, 1:4).^2));
Q = (sumpartMM)/(MM(1,1).^2+MM(1,3).^2+MM(1,2).^2+MM(1,4).^2)

sumMM = sum(sum(MM.^2));
Fd= (1/3)*(4*MM(1,1)^2 - sumMM);
Depolarization_index = sqrt(1 - Fd/MM(1,1)^2)
