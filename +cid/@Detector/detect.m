function cilia = detect(this, image, varargin)
%DETECTOR::DETECT ...
%   ...

%% Check input
narginchk(2, 99)
verbose = ~isempty(find(strcmp(varargin, 'verbose'), 1));
showdetails = ~isempty(find(strcmp(varargin, 'details'), 1));
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
while ~scanner.Finish
    % analyze
    [xslice, yslice] = scanner.next();
    dtls = this.Analyzer.analyze(xslice, yslice, varargin{:});
    % bypass
    if dtls.bypass, continue; end
    % add cilia
    [cilia{index}, index] = deal([], index + 1);
    % verbose option
    if verbose
        sz = this.ScanParams.WindowSize * ones(1, 2);
        position = [yslice(1), xslice(1), sz];
        pad.drawRect(position, true)
        % show detail
        if showdetails && index > 0
            this.Analyzer.showDetails(dtls)
            pause
        end % if show detail
    end % if verbose
end % while

end

