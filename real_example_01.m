%% Example of real allpass chirp
%
% Supplement to the paper
% "Allpass-Based Chirp Design with Perfect Pulse Compression Property"
%
%  Ivan Selesnick
%  October 2024 - June 2026

%% Set parameters

clear
reset(groot)

%% All-pass chirp system

% Design transfer function coefficients

K = 8;
tau = 20;

% [3.3*K - 8.5, 3.3*K - 5.1]  % recommended range for tau
Nf = 512 ;   % FFT grid points

[apc, target_funs] = real_allpass_chirp(K, tau, Nf);

%%

apc

%%

target_funs

%% Plots

plot_real_allpass_chirp(apc);

print -dpdf -fillpage real_example_01_fig.pdf
