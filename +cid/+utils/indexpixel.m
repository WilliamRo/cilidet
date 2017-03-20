function varargout = indexpixel(matrix)
%INDEXPIXEL ...
%   ...

%% Check input
narginchk(1, 1)
nargoutchk(0, 2)

%% Index pixels
[H, W] = size(matrix);
[X, Y] = meshgrid(1:W, 1:H);
Y = flipud(Y);
[X, Y] = deal(X - (W + 1) / 2, Y - (H + 1) / 2);

%% Output
if nargout > 0
    [varargout{1}, varargout{2}] = deal(X, Y);
else
    for i = 1 : H
        for j = 1 : W
            fprintf('(%+3.1f, %+3.1f) ', X(i, j), Y(i, j))
        end
        fprintf('\n')
    end
end

end

