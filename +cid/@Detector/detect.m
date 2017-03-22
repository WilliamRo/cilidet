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

%% Detect
cilia = {};
% generate maps
this.getMaps()
this.reveal();

end
