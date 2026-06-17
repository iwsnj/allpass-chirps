Supplement to the paper
"Allpass-Based Chirp Design with Perfect Pulse Compression Property"
IEEE Open Journal of Signal Processing

Matlab Software

real_allpass_chirp.m
	Returns coefficients q(n), n = 0,...,K of transfer function Q(z)
	such that H(z) = ... is an all-pass filter approximating the
	ideal all-pass chirp

set_target_funs_real.m
	Returns target frequency response for the approximation problem

cascaded_allpass_chirp.m
	Creates a cascaded allpass chirp from a given one.

interpolated_allpass_chirp.m
	Creates an interpolated chirp from a given allpass chirp.

plot_real_allpass_chirp.m
	Plotting function

Examples:
real_example_01.m
real_interpolated_example_01.m
real_cascade_example_01.m

---
Ivan Selesnick
June 2026
selesi@nyu.edu
