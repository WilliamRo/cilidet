function dtls = analyze(this, xslice, yslice, varargin)
%ANALYZER::ANALYZE ...
%   ...

%% Initialize
this.DebugMode = ~isempty(find(strcmp(varargin, 'debug'), 1));
showdetails = ~isempty(find(strcmp(varargin, 'details'), 1));
sess = this.Session;
[H, W] = size(sess.GrayImage);
dtls = [];

%% Find ROIs
decis = sess.DecisionMap(xslice, yslice);
altit = sess.AltitudeMap(xslice, yslice);
[h, w] = size(decis);

%% Find Center
[x, y] = find(decis == max(decis(:)), 1);
xin = (xslice(1)==1 || x>h/4+1/2) && (xslice(end)==H || x<3*h/4+1/2);
yin = (yslice(1)==1 || y>w/4+1/2) && (yslice(end)==W || y<3*w/4+1/2);
inside = xin && yin;
% ............................................................ score
dtls.score = 100 * altit(x, y);
% ............................................................ bypass
dtls.bypass = ~inside || (dtls.score < this.MinScore);       
if ~showdetails && dtls.bypass, return; end

%% Find ridge
[glox, gloy] = deal(xslice(1) + x - 1, yslice(1) + y - 1);
dtls.ridgeinfo = this.trace([glox, gloy]);

%% Pack masses to show
% ............................................................ mass
if showdetails
    % local position
    [dtls.x, dtls.y] = deal(x, y);
    % rois
    dtls.grayroi = sess.GrayImage(xslice, yslice);
    dtls.blurroi = sess.GrayBlurred(xslice, yslice);
    dtls.hatroi = sess.BgRemoved(xslice, yslice);
    dtls.altiroi = altit;
    dtls.deciroi = decis;
    % terrain
    peakindices = sess.MapCache.PeakIndices(xslice, yslice);
    peakindex = peakindices(x, y);
    hiddenroi = sess.MapCache.Hidden(xslice, yslice, :);
    [terrain, order] = ...
        cid.utils.shift2center(peakindex, hiddenroi(x, y, :));
    terrain = terrain / max(terrain);
    [dtls.terrain, dtls.order] = deal(terrain, order);
    dtls.ideal = this.Detector.RodDetector.Ideal;
end

end

