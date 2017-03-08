function setParams(this, varargin)
%RODDET::SETPARAMS
%   ...

    % overwrite default params with user-define params
    for i = 1 : 2 : length(varargin)
        switch (lower(varargin{i}))
            case {'kernelcount', 'knlcnt', 'count', 'cnt'}
                this.KernelCount = varargin{i+1};
            case {'rodlength', 'rodlen', 'len'}
                len = varargin{i+1};
                assert(len == fix(len) && len > 0, ...
                    'Rod length must be a positive integer.');
                % keep rod length odd
                if mod(len, 2) == 0, len = len + 1; end
                %
                this.RodLength = len;
            case 'sigma'
                this.Sigma = varargin{i+1};
        end % switch
    end % for i
    
end % function