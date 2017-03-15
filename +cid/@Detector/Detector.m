classdef Detector < handle
    %DETECTOR ...
    %   ...
    %% Public Properties
    properties (Access = public)
    end % Public Properties
    %% Read-only Properties
    properties (SetAccess = private, GetAccess = public)
        RawImage
        RawImageMap = []
        GrayImage
    end % Read-only Properties
    %% Private Properties
    properties (Access = private)
        RodDetector
    end % Private Properties
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = Detector(image, varargin)
            % preprocess image
            this.setImage(image)
            % initialize rod-detector
            this.RodDetector = cid.RodDet(varargin{:});
            % set image to RodDetector
            this.RodDetector.setImage(this.RawImage)
        end
        %
        % [SHOW]
        showImages(this)
    end % Public Methods
    %% Private Methods
    methods (Access = private)
        setImage(this, image)
    end
    
end

