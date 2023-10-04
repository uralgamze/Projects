format short g
% clear all;clc;close all;

data= U (:,14);
lam = 3; %0.5                      % lam: regularization parameter
Nit = 50;                          % Nit: number of iterations
[data_f, cost] = tvd_mm(data, lam, Nit); 
% plot(data);
% hold on ;
% plot(data_f);

% Fs is my sampling frequency, x is my EDF data imported into matlab
Fs=128;
t=1/Fs;
S =data_f;
waveletFunction = 'db8';
[C,L] = wavedec(S,8,waveletFunction);
%% Calculating the coefficients vectors
cD1 = detcoef(C,L,1); %NOISY 0-128
cD2 = detcoef(C,L,2); %NOISY 0- 64
cD3 = detcoef(C,L,3); %NOISY 0- 32
cD4 = detcoef(C,L,4); %NOISY 0- 16
cD5 = detcoef(C,L,5); %GAMA  0- 8
cD6 = detcoef(C,L,6); %BETA  0-4 
cD7 = detcoef(C,L,7); %ALPHA 0- 2
cD8 = detcoef(C,L,8); %THETA 0-1
cA8 = appcoef(C,L,waveletFunction,8); %DELTA
%% Calculation the Details Vectors
D1 = wrcoef('d',C,L,waveletFunction,1); %GAMMA 128-256
D2 = wrcoef('d',C,L,waveletFunction,2); %GAMMA 64-128
D3 = wrcoef('d',C,L,waveletFunction,3); %BETA 32-64
D4 = wrcoef('d',C,L,waveletFunction,4); %ALPHA 16-32
D5 = wrcoef('d',C,L,waveletFunction,5); %%THETA 8-16
D6 = wrcoef('d',C,L,waveletFunction,6); %DELTA 4-8 
D7 = wrcoef('d',C,L,waveletFunction,7); %%DELTA 2-4
D8 = wrcoef('d',C,L,waveletFunction,8); %%DELTA 1-2
A8 = wrcoef('a',C,L,waveletFunction,8); %DELTA 0.5- 1
%% create subbands
delta = D8+D7+D6;
theta=D5;
alpha=D4;
beta=D3;
gamma=D1+D2;
%% Parseval's theorem

POWER_DELTA = (sum(delta.^2))/length(delta);
POWER_THETA = (sum(theta.^2))/length(theta);
POWER_ALPHA = (sum(alpha.^2))/length(alpha);
POWER_BETA = (sum(beta.^2))/length(beta);
POWER_GAMMA=(sum(gamma.^2))/length(gamma);

Total=POWER_DELTA+ POWER_THETA+POWER_ALPHA+POWER_BETA+POWER_GAMMA;

RELATIVE_DELTA=POWER_DELTA/Total;
RELATIVE_THETA=POWER_THETA/Total;
RELATIVE_ALPHA=POWER_ALPHA/Total;
RELATIVE_BETA=POWER_BETA/Total;
RELATIVE_GAMMA=POWER_GAMMA/Total;

WE_DELTA = -sum(RELATIVE_DELTA .* log(RELATIVE_DELTA));
WE_THETA = -sum(RELATIVE_THETA .* log(RELATIVE_THETA));
WE_ALPHA = -sum(RELATIVE_ALPHA .* log(RELATIVE_ALPHA));
WE_BETA = -sum(RELATIVE_BETA .* log(RELATIVE_BETA));
WE_GAMMA = -sum(RELATIVE_GAMMA .* log(RELATIVE_GAMMA));


RE = zeros(1,5); 
RE(:,1) = RELATIVE_DELTA;
RE(:,2) = RELATIVE_THETA;
RE(:,3) = RELATIVE_ALPHA;
RE(:,4) = RELATIVE_BETA;
RE(:,5) = RELATIVE_GAMMA;



WE = zeros(1,5); 
WE(:,1) = WE_DELTA;
WE(:,2) =WE_THETA;
WE(:,3) = WE_ALPHA;
WE(:,4) = WE_BETA;
WE(:,5) = WE_GAMMA;

% LastName = {'RE';'WE'};
result = table(RE,WE);
writetable(result,'result.xlsx','Sheet',4,'Range','A31')
