function h = ea_plot_colorbar(cmap, dim, orientation, titletxt, tick, ticklabel)
% Plot a standalone colorbar
%
% Parameters:
%     cmap: a handle to a function to generate the colormap or the colarmap
%           itself.
%     dim: in vertical mode, dim(1) would be the height of the colorbar and
%          dim(2) would be the width of the colorbar
%     orientation: 'v' for vertical or 'h' for horizontal
%     title: tile of the colorbar
%     tick: tick locations
%     label: tick labels
%
% Output:
%     handle to the colorbar image
%
% Examples:
%     h = plot_colorbar([100, 5], 'h', 'Cool', colormap)
%     plot_colorbar([150, 10], 'v', '', @hsv)

if isa(cmap,'function_handle')
    map = colormap(gcf, cmap(dim(1)));
else
    map = colormap(gcf, cmap(round(linspace(1,size(cmap,1),dim(1))),:));
end

if length(dim) < 2
	width = 5;
else
	width = dim(2);
end

if ~exist('orientation', 'var') || isempty(orientation)
    orientation = 'v';
end

if ~exist('titletxt', 'var')
    titletxt = '';
end

switch lower(orientation)
    case {'v', 'vert', 'vertical'}
        h = image(repmat(cat(3, map(:,1), map(:,2), map(:,3)), 1, width));

        % Remove ticks we dont want.
        set(gca, 'xtick', []);
        set(gca,'YAxisLocation','right')
        set(gca, 'ytick', tick);
        set(gca, 'yticklabel', ticklabel);

    case {'h', 'horz', 'horizontal'}
        h = image(repmat(cat(3, map(:,1)', map(:,2)', map(:,3)'), width, 1));

        % Remove ticks we dont want.
        set(gca, 'ytick', 0);

        set(gca, 'xtick', tick);
        set(gca, 'xticklabel', ticklabel);

    otherwise
        error('Unknown colorbar orientation!');
end

% Set up the axis
title(titletxt)
axis equal
axis tight
axis xy
