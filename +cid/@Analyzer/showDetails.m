function showDetails(this, dtls)
%ANALYZER::SHOWDETAILS ...
%   ...

%% Store current figure, initialize
cache = gcf;
f = figure(cid.config.DetailFigureID);
[f.Name, f.NumberTitle] = deal('Details', 'off');
[f.ToolBar, f.MenuBar] = deal('none');

%% ROI and ...
% gray roi
orange = {'Color', [1, 0.5, 0]};
subplot(3, 9, [1, 2]), hold off
imshow(dtls.grayroi, []), title('Raw Image'), hold on
if dtls.hasridge
    plot(dtls.locridge(:, 2), dtls.locridge(:, 1), 'g')
    plot(dtls.locridge(end, 2), ...
        dtls.locridge(end, 1), 'ro', 'MarkerSize', 4)
    plot(dtls.y, dtls.x, 'o', 'MarkerSize', 4, orange{:})
end
cid.utils.freezeColors
% tophated
subplot(3, 9, [3, 4]), hold off
imshow(dtls.hatroi, []), title('Ridge Map'), hold on
if dtls.hasridge
    plot(dtls.y, dtls.x, 'o', 'MarkerSize', 4, orange{:})
    plot(dtls.locridge(:, 2), dtls.locridge(:, 1), 'g:')
end
cid.utils.freezeColors
% altitude
subplot(3, 9, [5, 6]), hold off
imshow(dtls.altiroi, []), title('Altitude Map'), hold on
if dtls.hasridge
    plot(dtls.y, dtls.x, 'o', 'MarkerSize', 4, orange{:})
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
tt = sprintf('Terrain, InitScore = %.1f, SurfScore = %.1f(%.1f)', ...
    dtls.score, dtls.surfscore, dtls.surfscore / dtls.score);
plot(dtls.terrain, 'o-'), hold on, plot(dtls.ideal, 'ro:')
plot(dtls.surfterr, 'o-'), xlim([1, length(dtls.order)])
set(gca, 'XTickLabel', dtls.order), xlabel('kernel index')
title(tt), ylim([0.1, 1])
legend('actual terrain', 'expected terrain', 'surface terrain', ...
    'Location', 'Best')
% get materials for presentation
if false 
    figure(2), hold off
    plot(dtls.terrain, 'o-'), hold on, plot(dtls.ideal, 'ro:')
    xlim([1, length(dtls.order)])
    set(gca, 'XTickLabel', dtls.order)
    ylim([0.1, 1])
    legend('Actual Terrain', 'Expected Terrain', 'Location', 'Best')
    figure(3), hold off
    imshow(dtls.grayroi, []), hold on
    plot(dtls.y1, dtls.x1, 'rs')
    return
end

%% Illumination and health
subplot(3, 3, [4, 5]), hold off
L = length(dtls.ridgeinfo.illu);
if L > 0
x = 1:L;
hAx = plotyy(x, dtls.ridgeinfo.deltas, x, dtls.ridgeinfo.illu);
ylabel(hAx(1),'Deltas'), ylabel(hAx(2),'Illumination')
xlim(hAx(1), [1, L]), xlim(hAx(2), [1, L])
mask = dtls.ridgeinfo.negdeltas > 0;
hold on, plot(x(mask), dtls.ridgeinfo.deltas(mask), 'rs')
tt = sprintf(['Illumination and Deltas, mean(deltas) = %.1f, ', ...
    'sum(negdelta) = %.1f'], mean(dtls.ridgeinfo.deltas), ...
    sum(dtls.ridgeinfo.negdeltas));
title(tt)
% surface
subplot(3, 3, [7, 8])
imshow(dtls.ridgeinfo.surf, [])
title(sprintf('Surface, Length = %d', length(dtls.ridgeinfo.illu)))
end

%% Restore previous figure
figure(cache)

end

