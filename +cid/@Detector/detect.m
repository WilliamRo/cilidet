function cilia = detect(this, image, varargin)
%DETECTOR::DETECT ...
%   ...

%% Check input
narginchk(2, 99)
debug = ~isempty(find(strcmp(varargin, 'debug'), 1));
verbose = ~isempty(find(strcmp(varargin, 'verbose'), 1));
showdetails = ~isempty(find(strcmp(varargin, 'details'), 1));
showindow = ~isempty(find(strcmp(varargin, 'window'), 1));
% level 1
showdetails = showdetails || debug;
showindow = showindow || showdetails;
% level 2
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
    if showindow
        pos = [yslice(1), xslice(1), ...
            yslice(end) - yslice(1) + 1, xslice(end) - xslice(1) + 1];
        r = rectangle('Position', pos, ...
            'EdgeColor', 'yellow', 'LineStyle', ':');
    end
    dtls = this.Analyzer.analyze(xslice, yslice, varargin{:});
    % bypass
    if dtls.bypass, delete(r), continue; end
    % add cilia
    [cilia{index}, index] = deal(dtls.ridgeinfo.ridge, index + 1);
    % verbose option
    if verbose
        pad.drawRect(dtls.rectpos, true)
        % show detail
        if showdetails && index > 0
            figure(cid.config.DetailFigureID)
            this.Analyzer.showDetails(dtls)
            pause, figure(cid.config.PadFigureID), delete(r)
        end % if show detail
    end % if verbose
end % while

%% Post-process
% restore pad figure focus
if verbose, figure(cid.config.PadFigureID); end

end

