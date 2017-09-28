% Name: Cory Nezin
% Date: 09/27/2017
% Goal: Complete Problem 5, HW1

%% Inputs
% Position
d = 1;
mx = [-2 -1 0 1 2]*d;
my = [-2 -1 0 1 2]*d;
mz = [0]*d; %#ok<NBRAK>
[rx,ry,rz] = ndgrid(mx,my,mz);
% Convert to 'lexicographic'
rx = rx(:); ry = ry(:); rz = rz(:);
rr = [rx ry rz];
M = numel(rx);
% Time
L = 1000;
% Signal Parameters
theta = [40 80 60];
phi   = [0 50 120];
lambda = 3;
% k vectors: each column corresponds to one source
k = [sind(theta).*cosd(phi);
     sind(theta).*sind(phi);
     cosd(theta)] * 2*pi/lambda;

N = size(k,2); % Number of signals
% relative powers (linear)
% db2mag is a built in function: y = db2mag(x) -> y = 10^(x/20)
a = [1, db2mag(-5), db2mag(-8)].';
% random Phase
psi = exp( -1j*2*pi*rand(N,L) );
% noise
sigma_n = db2mag(-30);
sigma = sigma_n/sqrt(2); % standard deviation of real and imag
n = sigma*( randn(M,L) +1j*randn(M,L) );
%% Computing A matrix
b = a.*psi; % cplx amplitude
A = exp(-1j*rr*k)*b; % sum (matrix multiply) over signals with no noise
A = A + n;
%% SVD analysis
[U,S,V] = svd(A);
% Singular approximation:
Sd = diag(S).';
ref = 10*log10(Sd(1).^2);
ssv = Sd(1:N).^2;
nsv = Sd(N+1:end).^2;
% SNR:
20*log10(sqrt(ssv(1))/sqrt(sum(nsv)))
stem( [10*log10(ssv)-ref, ...
       10*log10(nsv)-ref-sum(10*log10(ssv(1:N))-ref)]);

hold on
stem(10*log10(abs(a.^2) + sigma_n^2))
% Actual noise levels
hold off
legend('SVD Values','Theoretical Values')
%% Correlation
s = exp(-1j*rr*k)/sqrt(M);
c = s'*U(:,1:N);
abs(c)
min_diag = abs(min(diag(c)))
max_off_diag = abs(max(max(c-diag(diag(c)))))
