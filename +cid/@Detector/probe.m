function probe(this, image, varargin)
%DETECTOR::PROBE ...
%   ...

%% Check input

%% Set image and preprocess
this.setImage(image)

%% Create Pad
pad = cid.utils.Pad(this.Session.GrayImage, 'Probe', this);

end

