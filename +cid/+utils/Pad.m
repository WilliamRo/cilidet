classdef Pad < handle
    %PAD ...
    %   ...
    %% Private Properties
    properties (Access = private)
        Background
        Title
        Rectangles = {}
    end % Private Properties
    %% Public Methods
    methods (Access = public)
        % Constructor
        function this = Pad(image, title)
            % check input
            narginchk(1, 2)
            if nargin < 2, title = 'Pad'; end
            this.Title = title;
            % set this.Background
            this.Background = image;
            % show background
            this.showBackground;
        end % Constructor
        % property methods
        function fid = FigureID(this)
            fid = cid.config.PadFigureID;
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
            [f.Name, f.NumberTitle] = deal(this.Title, 'off');
            [f.ToolBar, f.MenuBar] = deal('none');
            [f.Units, f.Resize] = deal('pixels', 'off');
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

