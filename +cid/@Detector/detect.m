function cilia = detect(this, image, varargin)
%DETECTOR::DETECT ...
%   ...

%% Check input
narginchk(2, 99)
verbose = ~isempty(find(strcmp(varargin, 'verbose'), 1));
showdetails = ~isempty(find(strcmp(varargin, 'details'), 1));
showindow = ~isempty(find(strcmp(varargin, 'window'), 1));
verbose = verbose || showdetails;

%% Set image and preprocess
this.setImage(image)

%% Detect
[cilia, index] = deal({}, 1);
% scan
if verbose, 
    pad = cid.utils.Pad(this.Session.GrayImage, 'Cilia Detector'); 
end
repeat = this.ScanParams.Repeat;
scanner = cid.utils.Scanner(size(this.Session.GrayImage), ...
    this.BlockSize, repeat);
r = [];
while ~scanner.Finish
    % analyze
    [xslice, yslice] = scanner.next();
    dtls = this.Analyzer.analyze(xslice, yslice, varargin{:});
    if showindow
        pos = [yslice(1), xslice(1), ...
            yslice(end) - yslice(1) + 1, xslice(end) - xslice(1) + 1];
        r = rectangle('Position', pos, ...
            'EdgeColor', 'yellow', 'LineStyle', ':');
        pause(0.5), delete(r)
    end
    % bypass
    if dtls.bypass, continue; end
    % add cilia
    [cilia{index}, index] = deal(dtls.ridgeinfo.ridge, index + 1);
    % verbose option
    if verbose
        pad.drawRect(dtls.rectpos, true)
        % show detail
        if showdetails && index > 0
            figure(cid.config.DetailFigureID)
            this.Analyzer.showDetails(dtls)
            pause
        end % if show detail
    end % if verbose
end % while

%% Post-process
% restore pad figure focus
if verbose, figure(cid.config.PadFigureID); end

end

