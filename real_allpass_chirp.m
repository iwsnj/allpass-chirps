function [apc, target_funs] = real_allpass_chirp(K, tau, Nf)

% [apc, target_funs] = real_allpass_chirp(K, tau, Nf)
%
% Allpass chirp system with real coefficients - the all-pass chirp is the
% impulse response of a non-causal allpass system
% implemented via forward-backward filtering.
% The tranfser function is
%   H(z) = [ Q(z) Q(-1/z) ] / [ Q(-z) Q(1/z) ]
%
% INPUTS:
%    K : order of Q
%    tau : group delay
%    Nf : Number of FFT grid points
%
% OUTPUT:
%    apc : struct with fields q, G_target, G_target_phase, N, f
%    b, a : numerator and denominator coefficients of transfer function H
%
% % Example
%   K = 12;
%   tau = 33;
%   Nf = 512;
%   [apc, target_funs] = real_allpass_chirp(K, tau, Nf);
%   plot_real_allpass_chirp(apc);

% The positional arguments can have default values
arguments
    K = 10;
    tau = 3.3 * K - 6.813;
    Nf = 512;   % FFT grid points
end

% Check that K and tau are set appropriately in relation to each other
% [3.3*K - 8.5, 3.3*K - 5.1] range for tau

tau_min = 3.3*K - 8.5;
tau_max = 3.3*K - 5.1;
if (tau < tau_min) || (tau > tau_max)
    fprintf('For K = %d, it is recommended that tau be between %.2f and %.2f\n', K, tau_min, tau_max);
    apc = [];
    target_funs = [];
    return
end


apc = struct();
apc.K = K;
apc.tau = tau;
apc.Nf = Nf;

target_funs = set_target_funs_real(tau, Nf);

f = target_funs.f;
f = f(:);               % column vector
apc.f = f;
om = 2 * pi * f;

apc.duration = 2 * apc.tau;  % nominal duration

%% Create matrices

F = exp(-1j * om * (0:K));
P = diag(target_funs.G_target) * F * diag((-1).^(0:K)) - F;

% To ensure q is real, separate real and imaginary parts
Pr = real(P);
Pi = imag(P);

% Ptot = [Pr; Pi];

% Weighting
wghts = 1./sqrt(abs(target_funs.G_target));
% P = diag(wghts) * P;

Ptot = [diag(wghts) * Pr; diag(wghts) * Pi];

% Using SVD : Approximate null-space vector using SVD

% [U, S, V] = svd(Ptot, 'econ');     % P = S * U * V';
[~, ~, V] = svd(Ptot, 'econ');     % P = S * U * V';

% % Verify that P = S * U * V'
% err = P - U * S * V';
% max(abs(err(:)))
q = V(:, end);  % vector most aligned with the null-space of P

q = q(:);   % column vector

apc.q = q;

% Compute extra functions for convenience:

apc.Q = fft(q, Nf);

%% G

G = fft(q, Nf) ./ fft(altsign(q), Nf);

apc.G = G(:);  % column vector

% error (with respect to ideal)

apc.G_phase_err = target_funs.G_phase_ideal - unwrap(angle(apc.G));

% impulse response of a

L = ceil(20 * apc.tau);
imp = [zeros(1, L) 1 zeros(1, L)];
n = -L:L;

g = filter(q, altsign(q), imp);

apc.g = g;
apc.n = n;  % indices 'n' of impulse response 'a(n)'

% chirp waveform (impulse response of all-pass system)
flip = @(x) x(end:-1:1);

% Calculate impulse response
h = imp;
h = flip(filter(flip(q), q, flip(h)));        % backwards filtering
h = filter(flip(altsign(q)), altsign(q), h);  % forward filtering
apc.h = h;

% b, a : numerator and denominator coefficients of the transfer function H

b = conv(q, flip(altsign(q)));
a = conv(altsign(q), flip(q));
apc.b = b(:)';
apc.a = a(:)';

apc.H = freqz(apc.b, apc.a, om);
apc.H_group_delay = grpdelay(apc.b, apc.a, om);

apc.H_phase_err = unwrap(angle(apc.H)) - target_funs.H_phase_ideal;

apc.H_group_delay_err = apc.H_group_delay  - target_funs.H_group_delay_ideal;

%%

apc.param_string = sprintf('K = %d, tau = %.2f, Nf = %d', apc.K, apc.tau, apc.Nf);

apc.Ktau_string = sprintf('K = %d, tau = %.1f', apc.K, apc.tau);

% figure(10)
% clf
% plot_real_allpass_chirp(apc, target_funs)
