function [ output_args ] = compare_QR_cholesky_schur(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Comparing: QR vs. Cholesky vs. Cholesky with Schur complement
N = 20; % nbr of poses, and number of landmarks

% I. Problem construction: factors
J = []; % start with empty Jacobian
k = 0; % index for factors
% 1. motion
for n = 1:N - 1 % index for poses
    k = k+1; % add one factor
    J(k,n) = rand; % we simulate a non?-zero block with just one scalar
    J(k,n+1) = rand;
end
% 2. landmark observations
f = 0; % index for landmarks
for n=1:N % index for poses
    f = f+1; % add one landmark
    jj = [0 randperm(5)]; % random sort a few recent landmarks
    m = randi(4); % nbr. of landmark measurements
    for j = jj(1:m) % measure m of the recent landmarks
        if j < f
            k = k+1; % add one factor
            J(k,n) = rand; % use state n
            J(k,N+f - j) = rand; % use a recent landmark
        end
    end
end
% II. Factorizing and plotting
% 1. QR
p = colamd(J); % column reordering
A = J(:,p); % reordered J
[~,Rj] = qr(J,0);
[~,Ra] = qr(A,0);
figure(1), set(1,'name','QR')
subplot(2,2,1), spy(J), title 'A = \Omegaˆ{T/2} J'
subplot(2,2,2), spy(Rj), title 'R'
subplot(2,2,3), spy(A), title 'A'''
subplot(2,2,4), spy(Ra), title 'R'''
% 2. Cholesky
H = J'*J; % Hessian matrix
p = colamd(H); % column reordering
figure(2), set(2,'name','Cholesky')
subplot(2,2,1), spy(H), title 'H = JˆT \Omega J'
subplot(2,2,2), spy(chol(H)), title 'R'
subplot(2,2,3), spy(H(p,p)), title 'H'''
subplot(2,2,4), spy(chol(H(p,p))), title 'R'''
% 3. Cholesky + Schur
pr = 1:N; % poses
lr = N+1:N+f; % landmarks
Hpp = H(pr,pr); % poses Hessian
Hpl = H(pr,lr); % cross Hessian
Hll = H(lr,lr); % landmarks Hessian
Spp = Hpp - Hpl / Hll * Hpl'; % Schur complement of Hpp
p = colamd(Spp); % column reordering
figure(3), set(3,'name','Schur + Cholesky')
subplot(2,3,1), spy(Spp), title 'S_{PP}'
subplot(2,3,2), spy(chol(Spp)), title 'R_{PP}'
subplot(2,3,4), spy(Spp(p,p)), title 'S_{PP}'''
subplot(2,3,5), spy(chol(Spp(p,p))), title 'R_{PP}'''
subplot(2,3,3), spy(Hll), title 'H_{LL}'
subplot(2,3,6), spy(inv(Hll)), title 'H_{LL}ˆ{-1}'
end

