classdef BarEmbedder < cid.mf.MorphFilter
    %BAREMBEDDER ...
    %   ...
    %% Constants
    properties (Constant, Access = protected)
        DefaultInitParams = {11, 8, 2}
    end
    %% Read-only Properties
    properties (SetAccess = private,GetAccess = public)
        Thetas
    end
    %% Public Methods
    methods (Access = public)
        img = filter(this, img)
    end
    %% Abstract Private Methods
    methods (Access = protected)
        generateSEs(this, N, L, T)
    end
    
end

