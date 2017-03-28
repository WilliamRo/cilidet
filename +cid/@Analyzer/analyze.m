function dtls = analyze(this, xslice, yslice, nobypass)
%ANALYZER::ANALYZE ...
%   ...

%% Initialize
if nargin < 4, nobypass = false; end
dtls = [];

%% Find ROIs
sess = this.Session;
decis = sess.DecisionMap(xslice, yslice);
altit = sess.AltitudeMap(xslice, yslice);

%% Find Center
[x, y] = find(decis == max(decis(:)), 1);
% get margin
[h, w] = size(decis);  
margin = min([x, y, h-x+1, w-y+1]);
% ............................................................ score
dtls.score = 100 * decis(x, y);
% ............................................................ bypass
dtls.bypass = (margin < this.BlockSize / 2 - this.PixelTol) || ...
    (dtls.score < this.MinScore);       
if ~nobypass, return; end

%% ...


end

