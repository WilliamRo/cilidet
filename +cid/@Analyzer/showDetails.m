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
imshow(dtls.grayroi, []), title('Gray'), hold on
if dtls.hasridge
    plot(dtls.y, dtls.x, 'yo', 'MarkerSize', 4)
    plot(dtls.locridge(:, 2), dtls.locridge(:, 1), 'g')
    plot(dtls.locridge(end, 2), ...
        dtls.locridge(end, 1), 'ro', 'MarkerSize', 4)
end
cid.utils.freezeColors
% tophated
subplot(3, 9, [3, 4]), hold off
imshow(dtls.hatroi, []), title('Tophated'), hold on
if dtls.hasridge
    plot(dtls.y, dtls.x, 'yo', 'MarkerSize', 4)
    plot(dtls.locridge(:, 2), dtls.locridge(:, 1), 'g:')
end
cid.utils.freezeColors
% altitude
subplot(3, 9, [5, 6]), hold off
imshow(dtls.altiroi, []), title('Altitude'), hold on
if dtls.hasridge
    plot(dtls.y, dtls.x, 'yo', 'MarkerSize', 4)
    plot(dtls.locridge(:, 2), dtls.locridge(:, 1), 'g:')
end
cid.utils.freezeColors

%% Decision Map and Terrain
% decision map
subplot(2, 3, 3), hold off
tt = sprintf('Decision Map');
imshow(dtls.deciroi, []), title(tt), hold on
plot(dtls.y1, dtls.x1, 'w*')
colormap(jet), cid.utils.freezeColors
% Terrain
subplot(2, 3, 6), hold off
tt = sprintf('Terrain, Score = %.1f', dtls.score);
plot(dtls.ideal, 'ro:'), hold on, plot(dtls.terrain, 'bo-');
set(gca, 'XTickLabel', dtls.order), xlabel('kernel index')
title(tt), ylim([0.1, 1])
legend('expected terrain', 'actual terrain', 'Location', 'Best')

%% Illumination and health
% illu
subplot(3, 3, [4, 5]), hold off
L = length(dtls.ridgeinfo.illu);
x = 1:L;
hAx = plotyy(x, dtls.ridgeinfo.illu, x, dtls.ridgeinfo.health);
ylabel(hAx(1),'Illumination'), ylabel(hAx(2),'Health')
xlim(hAx(1), [1, L]), xlim(hAx(2), [1, L])
tt = sprintf('Illumination and Health, Length = %d', ...
    length(dtls.ridgeinfo.illu));
title(tt)
% surface
subplot(3, 3, [7, 8])
imshow(dtls.ridgeinfo.surf, []), title('Surface')

%% Restore previous figure
figure(cache)

end

