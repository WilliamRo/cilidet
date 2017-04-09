function dtls = analyze(this, xslice, yslice, varargin)
%ANALYZER::ANALYZE ...
%   ...

%% Initialize
this.DebugMode = ~isempty(find(strcmp(varargin, 'debug'), 1));
showdetails = ~isempty(find(strcmp(varargin, 'details'), 1));
verbose = ~isempty(find(strcmp(varargin, 'verbose'), 1));
verbose = verbose || showdetails;
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
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> bypass : MinScore
dtls.bypass = ~inside || (dtls.score < this.MinScore);       
if ~showdetails && dtls.bypass, return; end

%% Find ridge
[glox, gloy] = deal(xslice(1) + x - 1, yslice(1) + y - 1);
currentFid = gcf;
% ........................................................ ridgeinfo
dtls.ridgeinfo = this.trace([glox, gloy]);
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> bypass : MinRidgeLength
dtls.bypass = dtls.bypass || ...
    size(dtls.ridgeinfo.ridge, 1) < this.MinRidgeLength;
if this.DebugMode, figure(currentFid); end

%% Get terrain on ridgeinfo.surf, calculate score
% ............................................. surfterr & surfscore
[dtls.surfterr, dtls.surfscore] = ...
    this.Detector.RodDetector.getTerrain(dtls.ridgeinfo.surf);
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> bypass : SurfMinScore
if dtls.surfscore < this.SurfMinScore, dtls.bypass = true; end

%% Pack masses to show
% ............................................................ mass
if verbose
    edge = 7;
    ridge = dtls.ridgeinfo.ridge;
    if ~isempty(ridge)
        xrg = max(1,min(ridge(:,1))-edge):min(H,max(ridge(:,1))+edge);
        yrg = max(1,min(ridge(:,2))-edge):min(H,max(ridge(:,2))+edge);
        dtls.rectpos = [yrg(1), xrg(1), ...
            yrg(end) - yrg(1) + 1, xrg(end) - xrg(1) + 1];
        dtls.hasridge = true;
    else dtls.hasridge = false;
    end
end % if verbose
if showdetails
    dtls.altiroi = altit;
    dtls.deciroi = decis;
    [dtls.x1, dtls.y1] = deal(x, y);
    if ~isempty(ridge)
        % local position
        [dtls.x, dtls.y] = deal(x + xslice(1) - xrg(1), ...
                                y + yslice(1) - yrg(1));
        % rois
        dtls.grayroi = sess.GrayImage(xrg, yrg);
        dtls.blurroi = sess.GrayBlurred(xrg, yrg);
        dtls.hatroi = sess.IlluMap(xrg, yrg);
        dtls.altiroi = sess.AltitudeMap(xrg, yrg);
        % local ridge
        topleft = [xrg(1), yrg(1)];
        dtls.locridge = ridge - repmat(topleft, size(ridge,1),1) + 1;
    else
        [dtls.grayroi, dtls.blurroi, dtls.hatroi] = deal(0.5);
    end
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

