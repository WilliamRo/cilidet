function filename = bmk(index)
%BMK ...
%   ...

if nargin < 1, index = 1; end
if ischar(index)
    filename = ['data/', index];
elseif index > 0, filename = sprintf('data/benchmark/%d.tif', index);
else 
    switch index
        case 0
            filename = 'data/dnc.tif';
        case -1
            filename = 'data/dnc.tif';
        otherwise
            error('!! No file found.')
    end
end

end

