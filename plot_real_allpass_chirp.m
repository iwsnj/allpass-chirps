function plot_real_allpass_chirp(apc, fig_orientation)

% plot_real_allpass_chirp(apc, fig_orientation)
%
% fig_orientation can be 'Landscape' or 'Portrait'

arguments
    apc
    fig_orientation = 'Landscape';
end

% fprintf('fig_orientation = %s\n', fig_orientation)

% plot_real_allpass_chirp(apc, target_funs)

% Set plot parameters
fig1 = gcf;
set(fig1, 'DefaultAxesTitleFontWeight', 'normal')
set(fig1, 'DefaultAxesFontSize', 7);   % effects title and axis numbers
set(fig1, 'DefaultTextFontSize', 8);


ZERO_MARKER_SIZE = 4;
POLE_MARKER_SIZE = 5;

% shg
% TL = tiledlayout('flow', 'padding', 'tight', 'TileSpacing', 'compact');
if strcmpi(fig_orientation, 'landscape')  % case-insensitive string comparison
    TL = tiledlayout(3, 3, 'padding', 'compact', 'TileSpacing', 'compact');
    tile_num = [1 4 2 5 3 6 8];
    chirp_fig_span = [1 3];
    orient landscape
else
    % 'Portrait'
    TL = tiledlayout(4, 2, 'padding', 'compact', 'TileSpacing', 'compact');
    tile_num = 1:8;
    chirp_fig_span = [1 2];
    orient portrait
end

% ----------------------
% POLES AND ZEROS OF Q

rts_q = roots(apc.q(:).');   % enure row vector for roots function

nexttile(tile_num(1))
[z_params, p_params] = zplane(rts_q, []);  
title('Zeros of Q(z)')
z_params.MarkerSize = ZERO_MARKER_SIZE;
p_params.MarkerSize = POLE_MARKER_SIZE;

% Title of tiled layout
TL_title = title(TL, apc.param_string);
TL_title.FontSize = gca().FontSize + 2;

% ----------------------
% POLES AND ZEROS OF H

nexttile(tile_num(2))
[z_params, p_params] = zplane([rts_q; -1./rts_q], [-rts_q; 1./rts_q]);
title('Poles & Zeros of H(z)')
z_params.MarkerSize = ZERO_MARKER_SIZE;
p_params.MarkerSize = POLE_MARKER_SIZE;
% axis([-1 1 -1 1]*2)

% ----------------------
% PHASE FUNCTION OF H

nexttile(tile_num(3))
plot(apc.f, unwrap(angle(apc.H)))
xlim([0 0.5])
title('Phase response of H')
xlabel('Frequency (normalized)')

% ----------------------
% PHASE ERROR OF H

nexttile(tile_num(4))
plot(apc.f, apc.H_phase_err)
title('Phase response error')
xlabel('Frequency (normalized)')
xlim([0 0.5])

% ----------------------
% GROUP DELAY FUNCTION OF H

nexttile(tile_num(5))
plot(apc.f, apc.H_group_delay)
title('Group delay of H')
xlabel('Frequency (normalized)')
xlim([0 0.5])

% ----------------------
% GROUP DELAY ERROR FUNCTION OF H

% nexttile
nexttile(tile_num(6))
plot(apc.f, apc.H_group_delay_err)
xlim([0 0.5])
title('Group delay error')
xlabel('Frequency (normalized)')

% ----------------------
% IMPULSE RESPONSE OF H (CHIRP WAVEFORM)

nexttile(chirp_fig_span)
plot(apc.n, apc.h)
grid
xlim( 2 * apc.tau * [-1 1] )
title('Allpass chirp waveform')
xlabel('Time (index)')

shg

