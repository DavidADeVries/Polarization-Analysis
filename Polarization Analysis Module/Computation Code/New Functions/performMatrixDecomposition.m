function [M_D, M_delta, M_R] = performMatrixDecomposition(MM)
% performMatrixDecomposition

mm = MM(2:4, 2:4);

D = (1/MM(1,1)) .* (MM(1, 2:4))';

P = (1/MM(1,1)) .* MM(2:4, 1);

D_mag_sqr = (1/(MM(1,1)^2)) .* (((MM(1,2))^2) + ((MM(1,3))^2) + ((MM(1,4))^2));

I = eye(3);

m_D = (sqrt(1 - D_mag_sqr) * I) + ((1 - sqrt(1 - D_mag_sqr)) * ((1/D_mag_sqr)*(D*D')));

M_D(1,1) = 1;
M_D(1, 2:4) = D';
M_D(2:4, 1) = D;
M_D(2:4, 2:4) = m_D;
M_D = (1/MM(1,1)) .* M_D; %normalize


M_prime = MM / M_D;

m_prime = M_prime(2:4, 2:4);

P_delta = (P - (mm * D)) / (1- D_mag_sqr);

eigens = eig(m_prime * m_prime');

top = (m_prime * m_prime') + ((sqrt(eigens(1)*eigens(2)) + sqrt(eigens(1)*eigens(3)) + sqrt(eigens(2)*eigens(3))) .* I);
bot = ((sqrt(eigens(1)) + sqrt(eigens(2)) + sqrt(eigens(3))) * (m_prime * m_prime')) + (sqrt(eigens(1)*eigens(2)*eigens(3)) .* I);

m_delta = top \ bot;

if det(m_prime) < 0
    m_delta = -m_delta;
end

M_delta(1,:) = [1 0 0 0];
M_delta(2:4, 1) = P_delta;
M_delta(2:4, 2:4) = m_delta;

M_R = M_delta \ M_prime;


% rounding can lead to imaginary numbers creeping in
% get rid of them!!
% According to: "which should be real, may acquire a tiny imaginary part due to computational rounding errors. This imaginary part should be discarded"
% From: "Mueller matrix roots algorithm and computational considerations", Noble & Chipman

M_D = real(M_D);
M_R = real(M_R);
M_delta = real(M_delta);


end

