function showDetails(this, dtls)
%ANALYZER::SHOWDETAILS ...
%   ...

%% Store current figure, initialize
cache = gcf;
f = figure(cid.config.DetailFigureID);
[f.Name, f.NumberTitle] = deal('Details', 'off');
[f.ToolBar, f.MenuBar] = deal('none');
sess = this.Session;

%% ROI and ...
% gray roi
subplot(3, 9, [1, 2]), hold off
tt = sprintf('Blurred Image (%d, %d)', dtls.x, dtls.y);
imshow(dtls.blurroi, []), title(tt), hold on
plot(dtls.y, dtls.x, 'go', 'MarkerSize', 5)
cid.utils.freezeColors
% tophated
subplot(3, 9, [3, 4])
imshow(dtls.hatroi, []), title('Tophated')
cid.utils.freezeColors
% altitude
subplot(3, 9, [5, 6])
imshow(dtls.altiroi, []), title('Altitude')
cid.utils.freezeColors

%% Decision Map and ...
% decision map
subplot(2, 3, 3), hold off
tt = sprintf('Decision Map');
imshow(dtls.deciroi, []), title(tt), hold on
plot(dtls.y, dtls.x, 'w*')
colormap(jet), cid.utils.freezeColors
%
subplot(2, 3, 6), hold off

%% Terrain
subplot(3, 3, [4, 5, 7, 8]), hold off
tt = sprintf('Terrain, Score = %.1f', dtls.score);
plot(dtls.ideal, 'ro:'), hold on, plot(dtls.terrain, 'bo-');
set(gca, 'XTickLabel', dtls.order), xlabel('kernel index')
title(tt), ylim([0.1, 1])
legend('expected terrain', 'actual terrain', 'Location', 'Best')

%% Restore previous figure
figure(cache)

end

