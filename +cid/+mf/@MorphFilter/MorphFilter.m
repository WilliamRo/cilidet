classdef MorphFilter < handle
    %MORPHFILTER ...
    %   ...
    %% Abstract Constants
    properties (Abstract, Constant, Access = protected)
        DefaultInitParams
    end
    %% Read-only Properties
    properties (SetAccess = protected, GetAccess = public)
        SEs
        Masks
    end % Read-only Properties
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = MorphFilter(varargin)
            if isempty(varargin)
                varargin = this.DefaultInitParams; 
            end
            this.generateSEs(varargin{:})
        end
        % [show]
        showSEs(this)
    end
    %% Abstract Public Methods
    methods (Abstract, Access = public)
        img = filter(this, img)
    end
    %% Public Static Methods
    methods (Static, Access = public)
        img = quickFilter(img)
    end
    %% Abstract Private Methods
    methods (Abstract, Access = protected)
        generateSEs(this, varargin)
    end
    
end

