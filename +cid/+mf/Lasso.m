classdef Lasso < cid.mf.MorphFilter
    %LASSO ...
    %   ...
   %% Constants
    properties (Constant, Access = protected)
        DefaultInitParams = {10}
    end
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = Lasso(varargin)
            this@cid.mf.MorphFilter(varargin{:});
        end
        % concrete filter function
        function img = filter(this, img)
            innerDilated = imdilate(img, this.SEs{2});
            outterDilated = imdilate(img, this.SEs{1});
            spot = max(0, innerDilated - outterDilated);
            img = max(0, img - spot);
        end
    end
    %% Abstract Private Methods
    methods (Access = protected)
        function generateSEs(this, diameter)
            % index pixel grid
            [X, Y] = cid.utils.indexpixel(zeros(diameter + 2));
            D = round(diameter / 2 - sqrt(X.^2 + Y.^2));
            % outter
            this.Masks{1} = D == 0;
            this.SEs{1} = strel(this.Masks{1});
            % inner
            this.Masks{2} = D > 0;
            this.SEs{2} = strel(this.Masks{2});
        end
    end
    
end

