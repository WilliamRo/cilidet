function img = killDotsQuickly(img, N, L, T)
%DOTKIL::KILLDOTSQUICKLY ...
%   ...

% check input
narginchk(1, 4)
if nargin < 4, T = 2; end
if nargin < 3, L = 8; end
if nargin < 2, N = 6; end

% kill dots
dk = cid.DotKil(N, L, T);
img = dk.killDots(img);

end

