classdef Pad < handle
    %PAD ...
    %   ...
    %% Private Properties
    properties (Access = private)
        Background
        Title
        Rectangles = {}
        ProbeMode
        Detector = []
        Args = {}
    end % Private Properties
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = Pad(image, title, detector, varargin)
            % check input
            if nargin < 2 || isempty(title), title = 'Pad'; end
            if nargin < 3, detector = []; end
            this.Title = title;
            this.ProbeMode = isa(detector, 'cid.Detector');
            this.Args = varargin;
            % set detector
            if this.ProbeMode, this.Detector = detector; end
            % set this.Background
            this.Background = image;
            % show background
            this.showBackground();
        end % Constructor
        % property methods
        function fid = FigureID(this)
            if this.ProbeMode, fid = cid.config.ProbeFigureID; 
            else fid = cid.config.PadFigureID; end
        end
        % worker methods
        function showBackground(this)
            % get screen size
            screenSize = get(0, 'ScreenSize');
            screenSize = screenSize(3:4);
            % get image size
            imgSize = size(this.Background);
            imgSize = imgSize(2:-1:1);
            % create figure
            f = figure(this.FigureID);
            f.UserData = {this.Detector, this};
            [f.Name, f.NumberTitle] = deal(this.Title, 'off');
            [f.ToolBar, f.MenuBar] = deal('none');
            [f.Units, f.Resize] = deal('pixels', 'off');
            f.KeyPressFcn = @btnPressed;
            % adjust figure position and size
            ratio = max(imgSize ./ screenSize);
            [scale, pct] = deal(1, [0.4, 0.8]);
            if ratio < pct(1), scale = pct(1) / ratio; end
            if ratio > pct(2), scale = pct(2) / ratio; end
            f.Position = [(screenSize - imgSize * scale) / 2, ...
                imgSize * scale];
            % create axes
            ax = axes('Units', 'normalized', ...
                'Position', [0 0 1 1], 'NextPlot', 'replace');
            % show background
            imshow(this.Background, [])
        end
        function drawRect(this, position, showID)
            cache = gcf;
            figure(this.FigureID)
            % check input 
            narginchk(2, 3)
            if nargin < 3, showID = false; end
            % draw rectangle
            r = rectangle('Position', position, 'EdgeColor', 'green');
            % record
            index = length(this.Rectangles) + 1;
            this.Rectangles{index} = r;
            % show text
            if showID
                x = position(1) + position(3) + 5;
                y = position(2) + 5;
                text(x, y, num2str(index), 'Color', 'yellow');
            end % showID
            % draw now
            drawnow
            % restore
            figure(cache)
        end % drawRect
    end % Public Methods
    
end

%% Callback functions
function btnPressed(f, callbackdata)
    % ...
    switch lower(callbackdata.Key)
        case {'escape', 'q'}
            fprintf('!> [%s] figure has been closed.\n', f.Name)
            close(f)
        case {'return', 'space'}
            [detector, pad] = deal(f.UserData{:});
            if isempty(detector), return; end
            h = imrect; pos = floor(wait(h)); delete(h);
            xslice = pos(2):(pos(2) + pos(4) - 1);
            yslice = pos(1):(pos(1) + pos(3) - 1);
            dtls = detector.Analyzer.analyze(...
                xslice, yslice, 'details', pad.Args{:});
            detector.Analyzer.showDetails(dtls);
        otherwise
            pause('off')
            pause('on')
    end % switch
end

