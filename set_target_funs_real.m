function target_funs = set_target_funs_real(tau, Nf)
%
% target_funs = set_target_funs(tau, Nf)
%
% Create complex frequency response G.
%
% INPUT
%   tau
%   Nf : Number of frequency grid points 
%
% OUTPUT: struct with fields:
%   f : frequency grid
%   G_phase_ideal
%   G_phase_target
%
% Example
%   tau = 2 * K;
%   Nf = 2^10;
%   target_funs = set_target_fun(tau, Nf)


% Use a large value of Nf for accuracy of Hilbert transform
f = (0:Nf-1)'/Nf;   % column vector
om = 2 * pi * f;

% Phase function for allpass chirp
k1 = 1:Nf/2;
G_phase_ideal = nan(size(om));
G_phase_ideal(k1) = tau/2 .* om(k1) .* (om(k1)/pi - 1);
G_phase_ideal(Nf/2+1) = G_phase_ideal(1);  % om = pi
G_phase_ideal(Nf:-1:Nf/2+2) = -G_phase_ideal(2:Nf/2);

% ideal group delay of G
G_group_delay_ideal = tau * max( 1/2 - om/pi, om/pi - 3/2 );

G_phase_target = G_phase_ideal;

% Ensure values at dc and Nyquist are zero
G_phase_target(Nf/2+1) = 0;
G_phase_target(1) = 0;


% FFT for Hilbert transform
F = fft(G_phase_target);
% For real allpass, G_phase_target must be anti-symmetric,
% so its fft should be purly imaginary. So, discard neglible
% imaginary part (ideally, should not make a difference).
F = 1j*imag(F);
F(1) = 0;
F(Nf/2+1) = 0;
F(Nf/2+2:Nf) = -F(Nf/2+2:Nf);
Ph_H = imag( ifft( F ) );

% Complex frequency response
G_target = exp(1j * G_phase_target + Ph_H);

% Make put variables in a structure
target_funs = struct();
target_funs.f = f;
target_funs.tau = tau;
target_funs.N = Nf;
target_funs.G_phase_ideal = G_phase_ideal;
target_funs.G_phase_target = G_phase_target;
target_funs.G_target = G_target;
target_funs.G_group_delay_ideal = G_group_delay_ideal;

target_funs.H_phase_ideal = 2 * G_phase_ideal;
target_funs.H_group_delay_ideal = 2 * G_group_delay_ideal;

