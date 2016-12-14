function M_p = convertphyeigen (G)
     
     H_M = getHmatrix (G);   
     [V,Q] = eig(H_M); 
     Q(Q < 0)= 0;
     H_p = V*Q* inv(V) ; 
     M_p = getMmatrix (H_p);

end

function value = getHmatrix (X)
  %get the covariance matrix defined on pg.171 on "Polarized light and the
  %Mueller matrix approach
  T (1,1) = X(1,1)+X(1,2)+X(2,1)+X(2,2);
  T (1,2) = X(1,3)+1i*X(1,4)+X(2,3)+1i*X(2,4);
  T (1,3) = X(3,1)+X(3,2)-1i*X(4,1)-1i*X(4,2);
  T (1,4) = X(3,3)+1i*X(3,4)-1i*X(4,3)+X(4,4);
  T (2,1) = X(1,3)-1i*X(1,4)+X(2,3)-1i*X(2,4);
  T (2,2) = X(1,1)-X(1,2)+X(2,1)-X(2,2);
  T (2,3) = X(3,3)-1i*X(3,4)-1i*X(4,3)-X(4,4);
  T (2,4) = X(3,1)-X(3,2)-1i*X(4,1)+1i*X(4,2);
  T (3,1) = X(3,1)+X(3,2)+1i*X(4,1)+1i*X(4,2);
  T (3,2) = X(3,3)+1i*X(3,4)+1i*X(4,3)-X(4,4);
  T (3,3) = X(1,1)+X(1,2)-X(2,1)-X(2,2);
  T (3,4) = X(1,3)+1i*X(1,4)-X(2,3)-1i*X(2,4);
  T (4,1) = X(3,3)-1i*X(3,4)+1i*X(4,3)+X(4,4);
  T (4,2) = X(3,1)-X(3,2)+1i*X(4,1)-1i*X(4,2);
  T (4,3) = X(1,3)-1i*X(1,4)-X(2,3)+1i*X(2,4);
  T (4,4) = X(1,1)-X(1,2)-X(2,1)+X(2,2);
  
  value = (1/4)*T;
end

function value = getMmatrix(H)
  %convert the covariance matrix (after eliminating negative eigenvalue)
  %back to the Mueller matrix
  M (1,1) = H(1,1)+H(2,2)+H(3,3)+H(4,4);
  M (1,2) = H(1,1)-H(2,2)+H(3,3)-H(4,4);
  M (1,3) = H(1,2)+H(2,1)+H(3,4)+H(4,3);
  M (1,4) = -1i*H(1,2)-1i*H(3,4)+1i*H(2,1)+1i*H(4,3);
  M (2,1) = H(1,1)+H(2,2)-H(3,3)-H(4,4);
  M (2,2) = H(1,1)-H(2,2)-H(3,3)+H(4,4);
  M (2,3) = H(2,1)+H(1,2)-H(3,4)-H(4,3);
  M (2,4) = 1i*H(2,1)-1i*H(1,2)+1i*H(3,4)-1i*H(4,3);
  M (3,1) = H(1,3)+H(3,1)+H(4,2)+H(2,4);
  M (3,2) = H(3,1)+H(1,3)-H(2,4)-H(4,2);
  M (3,3) = H(1,4)+H(4,1)+H(2,3)+H(3,2);
  M (3,4) = -1i*H(1,4)+1i*H(4,1)+1i*H(2,3)-1i*H(3,2);
  M (4,1) = 1i*H(1,3)-1i*H(3,1)+1i*H(2,4)-1i*H(4,2);
  M (4,2) = 1i*H(1,3)-1i*H(3,1)-1i*H(2,4)+1i*H(4,2);
  M (4,3) = 1i*H(1,4)-1i*H(4,1)+1i*H(2,3)-1i*H(3,2);
  M (4,4) = H(1,4)+H(4,1)-H(2,3)-H(3,2);
  
  value = M;
end