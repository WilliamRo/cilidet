function probe(this, image, varargin)
%DETECTOR::PROBE ...
%   ...

%% Check input
silent = ~isempty(find(strcmp(varargin, 'silent'), 1));

%% Set image and preprocess
this.setImage(image)

%% Create Pad
if silent, return; end
pad = cid.utils.Pad(this.Session.GrayImage, ...
    'Probe', this, varargin{:});

end

