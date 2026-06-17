function cc = cascaded_allpass_chirp(apc, L)

% cc = cascaded_allpass_chirp(apc, L)
%
% Cascaded allpss allpass chirp
%
% INPUT
%   apc - allpass chirp (structure, produced by design program)
%   L - total number of times the chirp is convolved with itself
%


cc = struct;   % cascaded allpass chirp

cc.duration = L * apc.duration;
cc.h = apc.h;
for i = 2:L
    cc.h = conv(cc.h, apc.h);
end
cc.n = (L * apc.n(1) ) : ( L * apc.n(end) );
cc.N = length(cc.h);

% Autocorrelation of cascaded allpass chirp
cc.xcorr = xcorr( cc.h );
if 1
    % check
    chck = conv(cc.h, conj(flip(cc.h)));
    err = cc.xcorr - chck;
    max(abs(err))  % is zero as expected.
end

%%
% The autocorrelation (ACF) of the cascaded allpass chirp 
% is real because it is equal to the ACF of the LPF impulse
% response which is real.
% Verify
if max(abs(imag(cc.xcorr))) < 1e-6
    cc.xcorr = real( cc.xcorr );
else
    disp('Error')
end

cc.xcorr_n = cc.xcorr / max( abs( cc.xcorr ));  % normalized for unity peak value

cc.xcorr_xlim = [-1 1] * apc.duration; 
% xlimits for plot of autocorrelation function

% Fourier transform of cascaded allpass chirp
cc.Nf = 2^nextpow2(length(cc.h));
cc.H = fft( cc.h , cc.Nf ) / sum(cc.h);
cc.f = (0:cc.Nf - 1) / cc.Nf;

