classdef DotKil < handle
    %DOTKIL ...
    %   ...
    %% Read-only Properties
    properties (SetAccess = private, GetAccess = public)
        % Structuring Elements
        SEs = {}
        %
        Thetas
        Masks
    end
    %% Public Methods
    methods (Access = public)
        function this = DotKil(N, L, T)
            % generate structuring elements
            this.generateSEs(N, L, T)
        end
        % 
        img = killDots(this, img)
        % [SHOW]
        showSEs(this)
    end
    %% Public Static Methods
    methods (Static, Access = public)
        img = killDotsQuickly(img, N, L, T)
    end
    %% Private Methods
    methods (Access = private)
        generateSEs(this, N, L, T)
    end
end