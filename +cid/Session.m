classdef Session < handle
    %DEPOT ...
    %   ...
    %% Public Properties
    properties (Access = public)        
    end
    %% Read-only Properties
    properties (SetAccess = private, GetAccess = public)
        RawImage
        GrayImage
        BgRemoved = {}
        BgRmdBlurred = {}
        EnhancedImage
    end
    %% Private Constants
    properties (Constant, Access = private)
        BrowseList = {'GrayImage', 'BgRemoved', 'BgRmdBlurred', ...
            'EnhancedImage'};
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
        end
    end
    
end

