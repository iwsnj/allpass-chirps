function h = plot_note(txt, location)

arguments
    txt
    location = 'TopLeft';
end

FS = get(gca, 'FontSize');

switch location
    case 'TopLeft'
        h = text(0.02, 0.98, txt, 'units', 'normalized', ...
            'horizontalalignment', 'left', ...
            'verticalalignment', 'top');

    case 'TopCenter'
        h = text(0.5, 0.98, txt, 'units', 'normalized', ...
            'horizontalalignment', 'center', ...
            'verticalalignment', 'top');

    case 'TopRight'
        h = text(0.98, 0.98, txt, 'units', 'normalized', ...
            'horizontalalignment', 'right', ...
            'verticalalignment', 'top' );

    case 'BottomLeft'
        h = text(0.02, 0.02, txt, 'units', 'normalized', ...
            'horizontalalignment', 'left', ...
            'verticalalignment', 'bottom');

    case 'BottomRight'
        h = text(0.98, 0.02, txt, 'units', 'normalized', ...
            'horizontalalignment', 'right', ...
            'verticalalignment', 'bottom');

end
h.FontSize = FS;

% 'interpreter', 'none', ...

% set(h, 'background', 'white')

% Ivan Selesnick
