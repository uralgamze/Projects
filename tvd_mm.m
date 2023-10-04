function [x, cost] = tvd_mm(data, lam, Nit)
% [x, cost] = tvd_mm(y, lam, Nit)
% Total variation denoising using majorization-minimization
% and banded linear systems.
%
% INPUT
%   y - noisy signal
%   lam - regularization parameter
%   Nit - number of iterations
%
% OUTPUT
%   x - denoised signal
%   cost - cost function history
%
% Reference
% 'On total-variation denoising: A new majorization-minimization
% algorithm and an experimental comparison with wavalet denoising.'
% M. Figueiredo, J. Bioucas-Dias, J. P. Oliveira, and R. D. Nowak.
% Proc. IEEE Int. Conf. Image Processing, 2006.

% Ivan Selesnick, selesi@nyu.edu, 2011
% Revised 2017

data = data(:);                                              % Make column vector
cost = zeros(1, Nit);                                  % Cost function history
N = length(data);

I = speye(N);
D = I(2:N, :) - I(1:N-1, :);
DDT = D * D';

x = data;                                                 % Initialization
Dx = D*x;
Dy = D*data;

for k = 1:Nit
    F = sparse(1:N-1, 1:N-1, abs(Dx)/lam) + DDT;       % F : Sparse banded matrix
    x = data - D'*(F\Dy);                                 % Solve banded linear system
    Dx = D*x;
    cost(k) = 0.5*sum(abs(x-data).^2) + lam*sum(abs(Dx)); % cost function value
end
