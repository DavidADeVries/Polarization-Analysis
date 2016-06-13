function [M_D, M_delta, M_R] = performMatrixDecomposition(M)
% performMatrixDecomposition

m = (1 / M(1,1)) * M(2:4, 2:4);

D = (1/M(1,1)) .* (M(1, 2:4))';

P = (1/M(1,1)) .* M(2:4, 1);

D_mag = norm(D);

D_unit = D ./ D_mag;

I = eye(3);

m_D = (sqrt(1 - D_mag^2) .* I) + ((1 - sqrt(1 - D_mag^2)) .* (D_unit*D_unit'));

M_D = M(1,1) .* [1, D'; D, m_D];

M_prime = M / M_D;

m_prime = M_prime(2:4, 2:4);

P_delta = (P - (m * D)) ./ (1 - (D_mag^2));

eigens = eig(m_prime * m_prime');

top = (m_prime * m_prime') + ((sqrt(eigens(1)*eigens(2)) + sqrt(eigens(1)*eigens(3)) + sqrt(eigens(2)*eigens(3))) .* I);
bot = ((sqrt(eigens(1)) + sqrt(eigens(2)) + sqrt(eigens(3))) * (m_prime * m_prime')) + (sqrt(eigens(1)*eigens(2)*eigens(3)) .* I);

m_delta = top \ bot;

if det(m_prime) < 0
    m_delta = -m_delta;
end

M_delta = [1 0 0 0; P_delta m_delta];

M_R = M_delta \ M_prime;


% rounding can lead to imaginary numbers creeping in
% get rid of them!!
% According to: "which should be real, may acquire a tiny imaginary part due to computational rounding errors. This imaginary part should be discarded"
% From: "Mueller matrix roots algorithm and computational considerations", Noble & Chipman

M_D = real(M_D);
M_R = real(M_R);
M_delta = real(M_delta);


end

