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
    %% Read-only Derivative Properties
    properties (SetAccess = private, GetAccess = public)
        % images and low-level derivatives
        Image               % (H, W) normalized single
        Blur                % (H, W) normalized single
        Background          % scalar
        HiddenLayer         % (H, W, N) array
        % high-level derivatives
        ResponseMap         % (H, W) array
        PeakIndices         % (H, W) array
        AltitudeMap         % (H, W) array
    end
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
        %
        setImage(this, img)
        % [DISP]
        showKernels(this)
        viewEnhanced(this)
    end % Public Methods
    %% Property Methods
    methods (Access = private)
        val = RoiSize(this)
    end
    %% Private Methods
    methods (Access = private)
        setParams(this, varargin)
        generateKernels(this)
    end
    
end

