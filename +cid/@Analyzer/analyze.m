function dtls = analyze(this, xslice, yslice, varargin)
%ANALYZER::ANALYZE ...
%   ...

%% Initialize
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

%% Pack masses to show
% ............................................................ mass
if showdetails
    dtls.grayroi = sess.GrayImage(xslice, yslice);
    dtls.deciroi = decis;
    [dtls.x, dtls.y] = deal(x, y);
end

end

