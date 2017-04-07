classdef Analyzer < handle
    %ANALYZER ...
    %   ...
    %% Private Properties
    properties (GetAccess = public, SetAccess = private)
        % Debug Option
        DebugMode = false
        % Detector
        Detector
        % Parameters
        PixelTol = 8
        MinScore = 10
        MinRidgeLength = 12
        StepLength = 1
        RidgeArgs = struct(...
            'MaxLen', 100, ...
            'PeakRadius', 3, ...
            'MinHealth', 0.35, ...
            'MinIlluPct', 0.18)  % 0.45 blurred 39?
        % xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        ScoreCoef = 0.0
    end % Private Properties
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = Analyzer(detector)
            narginchk(1, 1)
            assert(~isempty(detector) && ...
                isa(detector, 'cid.Detector'))
            this.Detector = detector;
        end % Constructor
        % main methods
        dtls = analyze(this, xslice, yslice, varargin)
        info = trace(this, center, info)
        [sctn, idcs] = getSection(this, pos)
        showDetails(this, dtls)
    end % Public Methods
    %% Private Methods
    methods (Access = private)
        % property methods
        function sess = Session(this)
            sess = this.Detector.Session;
        end % Session
        function val = BlockSize(this)
            val = this.Detector.BlockSize;
        end % BlockSize
    end % Private Methods
    
end

