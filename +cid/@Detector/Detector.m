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
        CowBoy
        Analyzer
    end % Read-only Properties
    %% Private Properties
    properties (Access = private)
        EnhanceParams = struct('DiskSize', 4, 'BlurSigma', 0.7)
        DotKilParams = struct('N', 11, 'Length', 8, 'Thickness', 2)
        ScanParams = struct('WindowSize', 100, 'Repeat', 1)
    end % Private Properties
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = Detector(varargin)
            % initialize Dotkiller
            this.DotKiller = cid.mf.BarEmbedder(...
                this.DotKilParams.N, ...
                this.DotKilParams.Length, ...
                this.DotKilParams.Thickness);
            % initialize CowBoy
            this.CowBoy = cid.mf.Lasso();
            % initialize RodDetector
            this.RodDetector = cid.RodDet(varargin{:});
            % initialize Analizer
            this.Analyzer = cid.Analyzer(this);
        end
        % main methods
        probe(this, image, varargin)
        cilia = detect(this, image, varargin)
        % worker methods
        setImage(this, image)
        % [SHOW]
        function viewSession(this)
            assert(~isempty(this.Session), '!! Session is empty')
            this.Session.browse
        end
    end % Public Methods
    %% Public Static Methods
    methods (Static, Access = public)
        quickDetect(image, varargin)
    end
    %% Private Methods
    methods (Access = {?cid.Analyzer})
        % property methods
        function val = BlockSize(this)
            S = this.ScanParams.WindowSize;
            val = (S - mod(S, 4)) / 2;
        end % BlockSize
    end % % Private Methods
    
end

