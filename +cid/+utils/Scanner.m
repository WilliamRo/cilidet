classdef Scanner < handle
    %SCANNER ...
    %   ...
    %% Private Properties
    properties (Access = private)
        Cursor
        TopLefts
        BottomRights
    end % Public Properties
    %% Public Methods
    methods (Access = public)
        function this = Scanner(imsize, blocksize, rpt)
            % check input
            narginchk(2, 3)
            if nargin < 3, rpt = 1; end
            [H, W] = deal(imsize(1), imsize(2));
            if length(blocksize) == 1, [h, w] = deal(blocksize);
            else [h, w] = deal(blocksize(1), blocksize(2)); end
            % generate Toplefts and BottomRights
            [cntX, cntY] = deal(ceil(H / h) - 1, ceil(W / w) - 1);
            [this.TopLefts, this.BottomRights] = ...
                deal(zeros(cntX * cntY, 2));
            for x = 1 : cntX
                for y = 1 : cntY
                   index = (x - 1) * cntY + y;
                   this.TopLefts(index, :) = [1+(x-1)*h, 1+(y-1)*w];
                   this.BottomRights(index, :) = ...
                       this.TopLefts(index, :) + [2*h, 2*w] - 1;
                   this.BottomRights(index, :) = ...
                       min(this.BottomRights(index, :), [H, W]);
                end
            end
            % repeat
            this.TopLefts = repmat(this.TopLefts, rpt, 1);
            this.BottomRights = repmat(this.BottomRights, rpt, 1);
            % set cursor
            this.Cursor = 1;
        end % constructor
        %
        function varargout = next(this)
            % next
            tl = this.TopLefts(this.Cursor, :);
            br = this.BottomRights(this.Cursor, :);
            if nargout == 1, varargout{1} = [tl, br];
            else varargout = {tl(1):br(1), tl(2):br(2)}; end
            % increase curse by 1
            this.Cursor = this.Cursor + 1;
        end
        % 
        function flag = Finish(this)
            flag = this.Cursor > size(this.TopLefts, 1);
        end
    end % Public Methods
    
end

