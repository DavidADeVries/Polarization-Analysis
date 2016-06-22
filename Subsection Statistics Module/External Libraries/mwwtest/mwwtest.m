function STATS=mwwtest(x1,x2)
%Mann-Whitney-Wilcoxon non parametric test for two unpaired groups.
%This file execute the non parametric Mann-Whitney-Wilcoxon test to evaluate the
%difference between unpaired samples. If the number of combinations is less than
%20000, the algorithm calculates the exact ranks distribution; else it 
%uses a normal distribution approximation. The result is not different from
%RANKSUM MatLab function, but there are more output informations.
%There is an alternative formulation of this test that yields a statistic
%commonly denoted by U. Also the U statistic is computed.
%
% Syntax: 	STATS=MWWTEST(X1,X2)
%      
%     Inputs:
%           X1 and X2 - data vectors. 
%     Outputs:
%           - T and U values and p-value when exact ranks distribution is used.
%           - T and U values, mean, standard deviation, Z value, and p-value when
%           normal distribution is used.
%        If STATS nargout was specified the results will be stored in the STATS
%        struct.
%
%      Example: 
%
%         X1=[181 183 170 173 174 179 172 175 178 176 158 179 180 172 177];
% 
%         X2=[168 165 163 175 176 166 163 174 175 173 179 180 176 167 176];
%
%           Calling on Matlab the function: mwwtest(X1,X2)
%
%           Answer is:
%
% MANN-WHITNEY-WILCOXON TEST
% ---------------------------------------------------------------------------
%                                   Group 1         Group 2
% numerosity                		15              15
% Sum of Ranks (W)                  270.0           195.0
% Mean rank                         18.0            13.0
% Test variable (U)                 75.0            150.0
% ---------------------------------------------------------------------------
% Sample size is large enough to use the normal distribution approximation
% Mean                                      112.5
% Standard deviation corrected for ties     24.0474
% Z corrected for continuity        1.5386          1.5386
% p-value (1-tailed)                        0.06195
% p-value (2-tailed)                        0.12389
% ---------------------------------------------------------------------------
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2009). MWWTEST: Mann-Whitney-Wilcoxon non parametric test for two unpaired samples.
% http://www.mathworks.com/matlabcentral/fileexchange/25830

%Input Error handling
if ~isvector(x1) || ~isvector(x2)
   error('MWWTEST requires vector rather than matrix data.');
end 
if ~all(isfinite(x1)) || ~all(isnumeric(x1)) || ~all(isfinite(x2)) || ~all(isnumeric(x2))
    error('Warning: all X1 and X2 values must be numeric and finite')
end

%set the basic parameter
n1=length(x1); n2=length(x2); NP=n1*n2; N=n1+n2; N1=N+1; k=min([n1 n2]);

[A,B]=tiedrank([x1(:); x2(:)]); %compute the ranks and the ties
R1=A(1:n1); R2=A(n1+1:end); 
T1=sum(R1); T2=sum(R2);
U1=NP+(n1*(n1+1))/2-T1; U2=NP-U1;
tr=repmat('-',1,75); %set the divisor
disp('MANN-WHITNEY-WILCOXON TEST')
disp(tr)
fprintf('\t\t\t\tGroup 1\t\tGroup 2\n')
fprintf('numerosity\t\t\t%i\t\t%i\n',n1,n2)
fprintf('Sum of Ranks (W)\t\t%0.1f\t\t%0.1f\n',T1,T2)
fprintf('Mean rank\t\t\t%0.1f\t\t%0.1f\n',T1/n1,T2/n2)
fprintf('Test variable (U)\t\t%0.1f\t\t%0.1f\n',U1,U2)
disp(tr)
if nargout
    STATS.n=[n1 n2];
    STATS.W=[T1 T2];
    STATS.mr=[T1/n1 T2/n2];
    STATS.U=[U1 U2];
end    
if round(exp(gammaln(N1)-gammaln(k+1)-gammaln(N1-k))) > 20000
    mU=NP/2;
    if B==0
        sU=realsqrt(NP*N1/12);
    else
        sU=realsqrt((NP/(N^2-N))*((N^3-N-2*B)/12));
    end
    Z1=(abs(U1-mU)-0.5)/sU; Z2=(abs(U2-mU)-0.5)/sU; 
    p=1-normcdf(Z1); %p-value
    disp('Sample size is large enough to use the normal distribution approximation')
    fprintf('Mean\t\t\t\t\t%0.1f\n',mU)
    if B==0
        fprintf('Standard deviation\t\t\t%0.4f\n',sU)
    else
        fprintf('Standard deviation corrected for ties\t%0.4f\n',sU)
    end
    fprintf('Z corrected for continuity\t%0.4f\t\t%0.4f\n',Z1,Z2)
    fprintf('p-value (1-tailed)\t\t\t%0.5f\n',p)
    fprintf('p-value (2-tailed)\t\t\t%0.5f\n',2*p)
    if nargout
        STATS.method='Normal approximation';
        STATS.mU=mU;
        STATS.sU=sU;
        STATS.Z=Z1;
        STATS.p=[p 2*p];
    end
else
    disp('Sample size is small enough to use the exact Mann-Whitney-Wilcoxon distribution')
    if n1<=n2
        w=T1;
    else
        w=T2;
    end
    pdf=sum(nchoosek(A,k),2);
    P = [sum(pdf<=w) sum(pdf>=w)]./length(pdf);
    p = min(P);
    fprintf('Test variable (W)\t\t\t%0.1f\n',w)
    fprintf('p-value (1-tailed)\t\t\t%0.5f\n',p)
    fprintf('p-value (2-tailed)\t\t\t%0.5f\n',2*p)
    if nargout
        STATS.method='Exact distribution';
        STATS.T=w;
        STATS.p=[p 2*p];
    end
end
disp(tr)
disp(' ')
