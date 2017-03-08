function varargout = shift2center(cursor, varargin)
%SHIFT2CENTER
%   ...

    % prepare parameters
    M = nargin - 1;
    N = length(varargin{1});
    center = ceil(N / 2);
    buf = zeros(M + 1, N);
    for i = 1 : M
        buf(i, :) = varargin{i};
    end
    buf(M+1, :) = 1 : N;
    % shift
    while true
        if cursor == center, break; end
        buf = [buf(:, N), buf(:, 1:N-1)];
        cursor = cursor + 1;
        if cursor > N, cursor = cursor - N; end
    end  % end of while
    % output
    varargout = cell(nargout, 1);
    for i = 1 : nargout
        varargout{i} = buf(i, :);
    end
    
end % function