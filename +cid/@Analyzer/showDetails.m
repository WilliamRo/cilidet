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
tt = sprintf('Raw Image (%d, %d)', dtls.x, dtls.y);
imshow(dtls.grayroi, []), title(tt), hold on
plot(dtls.y, dtls.x, 'go', 'MarkerSize', 5)
cid.utils.freezeColors
% 
subplot(3, 9, [3, 4])
imshow(dtls.deciroi, []), title('Decision Map')
cid.utils.freezeColors
%
subplot(3, 9, [5, 6])
cid.utils.freezeColors

%% Restore previous figure
figure(cache)

end

