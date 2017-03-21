classdef Detector < handle
    %DETECTOR ...
    %   ...
    %% Public Properties
    properties (Access = public)
        Session = {}
    end % Public Properties
    %% Read-only Properties
    properties (SetAccess = private, GetAccess = public)
        DotKiller
        RodDetector
    end % Read-only Properties
    %% Private Properties
    properties (Access = private)
        EnhanceParams = struct('DiskSize', 4, 'BlurSigma', 0.7)
        DotKilParams = struct('N', 11, 'Length', 8, 'Thickness', 2)
    end % Private Properties
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = Detector(varargin)
            % initialize Dotkiller
            this.DotKiller = cid.DotKil(...
                this.DotKilParams.N, ...
                this.DotKilParams.Length, ...
                this.DotKilParams.Thickness);
            % initialize RodDetector
            this.RodDetector = cid.RodDet(varargin{:});
        end
        %
        setImage(this, image)
        enhanceImage(this)
        % [SHOW]
        function viewSession(this)
            assert(~isempty(this.Session), '!! Session is empty')
            this.Session.browse
        end
    end % Public Methods
    %% Private Methods
    methods (Access = private)

    end
    
end

