classdef RodDet < handle
    %CONVAGENT ...
    %   ...
    %% Read-only Properties
    properties (SetAccess = private, GetAccess = public)
        KernelCount = 11  % N
        RodLength = 23    % L
        Sigma = 1.28
        %
        Kernels           % (N, 1) cell
        Directions        % (N, 2) array
        Skeletons         % (L, 2, N) array
        Perpendiculars    % (L, 2, N) array
        Ideal             % (1, N) array
    end % Read-only Properties
    %% Public Properties
    properties (Access = public)
        
    end
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = RodDet(varargin)
            this.setParams(varargin{:})
            this.generateKernels()
        end % Constructor
        % [DISP]
        showKernels(this)
    end % Public Methods
    %% Property Methods
    methods (Access = private)
        val = RoiSize(this)
%         val = BlurSize(this)
%         val = BlockSize(this)
%         knl = FullKernel(this, index)
    end
    %% Private Methods
    methods (Access = private)
        setParams(this, varargin)
        generateKernels(this)
    end
    
end

