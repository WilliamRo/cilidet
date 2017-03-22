classdef RodDet < handle
    %CONVAGENT ...
    %   ...
    %% Read-only Inherent Properties
    properties (SetAccess = private, GetAccess = public)
        % parameters
        KernelCount = 11    % N
        RodLength = 23      % L
        Sigma = 1.28
        % inherent properties
        Kernels             % (N, 1) cell
        Directions          % (N, 2) array
        Skeletons           % (L, 2, N) array
        Perpendiculars      % (L, 2, N) array
        Ideal               % (1, N) array
    end % Read-only Properties
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = RodDet(varargin)
            this.setParams(varargin{:})
            this.generateKernels()
        end % Constructor
        %
        maps = generateMaps(this, img)
        % [SHOW]
        showKernels(this)
    end % Public Methods
    %% Property Methods
    methods (Access = private)
        val = RoiSize(this)
        knl = FullKernel(this, index)
    end
    %% Private Methods
    methods (Access = private)
        setParams(this, varargin)
        generateKernels(this)
    end
    
end

