classdef Session < handle
    %DEPOT ...
    %   ...
    %% Read-only Properties
    properties (SetAccess = private, GetAccess = public)
        % stage I
        RawImage            % (H, W, C) whatever
        GrayImage           % (H, W) normalized single
        GrayBlurred
        BgRemoved = {}
        BgRmdBlurred = {}
        EnhancedImage
        % stage II
        ResponseMap         % (H, W) array
        AltitudeMap         % (H, W) array
        MapCache            % struct { Hidden, PeakIndices }
        DecisionMap
        Revealed
    end
    %% Private Constants
    properties (Constant, Access = private)
        BrowseList = {...
            'GrayImage', ...
            'GrayBlurred', ...
            'BgRemoved', ...
            'BgRmdBlurred', ...
            'EnhancedImage', ...
            'DecisionMap', ...
            'Revealed'};
    end
    %% Public Methods
    methods (Access = public)
        % [Constructor Placeholder]
        % Display properties in BrowseList in ImageViewer
        function browse(this)
            vr = imv.ImageViewer;
            for i = 1 : length(this.BrowseList)
                str = this.BrowseList{i};
                if isempty(this.(str)), continue; end
                vr.addImage(this.(str), str)
            end
            vr.view
        end % browse
        function setImage(this, prop, img, updateEnhanced)
            % check input
            narginchk(3, 4)
            if nargin < 4, updateEnhanced = false; end
            % set image 
            this.(prop) = img;
            if updateEnhanced, this.EnhancedImage = img; end
        end % set image
        function setMaps(this, maps)
            [this.ResponseMap, this.AltitudeMap, this.MapCache] = ...
                deal(maps{:});
        end
    end
    
end

