function cilia = detect(this, image, varargin)
%DETECTOR::DETECT ...
%   ...

%% Check input
narginchk(2, 99)
verbose = ~isempty(find(strcmp(varargin, 'verbose'), 1));

%% Set image and preprocess
this.setImage(image)
% remove background, and maybe dots
this.enhanceImage()
% generate maps
this.getMaps()
% generate decision map
this.reveal()

%% Detect
cilia = {};
% scan
repeat = this.ScanParams.Repeat;
scanner = cid.utils.Scanner(size(image), this.BlockSize, repeat);
while ~scanner.Finish
    [xslice, yslice] = scanner.next();
    dtls = this.Analyzer.analyze(xslice, yslice);
end

end

