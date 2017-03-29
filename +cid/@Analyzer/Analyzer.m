classdef Analyzer < handle
    %ANALYZER ...
    %   ...
    %% Private Properties
    properties (Access = private)
        % Detector
        Detector
        % Parameters
        PixelTol = 8
        MinScore = 11
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
        showDetails(this, dtls)
    end % Public Methods
    %% Private Methods
    methods (Access = private)
        function sess = Session(this)
            sess = this.Detector.Session;
        end % Session
        function val = BlockSize(this)
            val = this.Detector.BlockSize;
        end % BlockSize
    end % Private Methods
    
end

