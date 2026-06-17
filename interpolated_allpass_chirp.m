function [ic, lpf] = interpolated_allpass_chirp(apc, M)

% ic = interpolated_allpass_chirp(apc, M)
%
% Interpolated allpass chirp
% INPUT
%    apc - allpass chirp (created using allpass chirp design function)
%    M - interpolation factor (integer M > 1)
%
% OUTPUT
%    ic - interpolated chirp (structure with multiple fields)
%    lpf - lowpass interpolation filter (structure with multiple fields)

% ------- lowpass interpolation filter ------- 

lpf = struct;                   % lowpass interpolation filter

lpf.M = M;                      % interpolation factor

lpf.N = 8 * lpf.M + 1;          % length of LPF impulse response

window = blackmanharris(lpf.N);
lpf.window_name = 'Blackman-Harris';

lpf.h = fir1( lpf.N-1 , 1/lpf.M, window );  % impulse response of LPF
lpf.n = (1 - lpf.N )/2 : (lpf.N - 1)/2;

lpf.Nf = 1024;                          % FFT length for computing frequency response of LPF

lpf.H = fft( lpf.h , lpf.Nf );          % frequency response of LPF

lpf.f = (0:lpf.Nf-1)/lpf.Nf;

% ------------ Interpolated allpass chirp waveform ------------

ic = struct;   % interpolated allpass chirp

ic.M = M;
ic.h = lpf.M * upfirdn( apc.h , lpf.h , lpf.M , 1);  % waveform
ic.N = length(ic.h);
ic.n = (1-ic.N)/2 : (ic.N-1)/2;   % time grid for interpolated chirp

% normalize to unit energy
ic.scale_factor = 1 / norm(ic.h);
ic.h = ic.h * ic.scale_factor;

ic.duration = M * apc.duration;

% Autocorrelation of interpolated allpass chirp
ic.xcorr = xcorr( ic.h );
if 0
    % check
    chck = conv(ic.h, conj(flip(ic.h)));
    err = ic.xcorr - chck;
    max(abs(err))  % zero is expected
end

% The autocorrelation (ACF) of the interpolated allpass chirp 
% is real because it is equal to the ACF of the LPF impulse
% response which is real.
% Verify
if max(abs(imag(ic.xcorr))) < 1e-6
    ic.xcorr = real( ic.xcorr );
else
    disp('Error')
end

ic.xcorr_xlim = [-1 1] * apc.duration * lpf.M; 
% xlimits for plot of autocorrelation function

% Fourier transform of interpolated allpass chirp
ic.Nf = 2^nextpow2(length(ic.h));
ic.H = fft( ic.h , ic.Nf ) ; % / sum(ic.h);
ic.f = (0:ic.Nf - 1) / ic.Nf;

ic.param_string = ...
    sprintf('K = %d, T = %.2f, M = %d', apc.K, apc.duration, M);
