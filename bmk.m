function filename = bmk(index)
%BMK ...
%   ...

if nargin < 1, index = 1; end
filename = sprintf('data/benchmark/%d.tif', index);

end

