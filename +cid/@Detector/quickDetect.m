function cilia = quickDetect(image, varargin)
%DETECTOR::QUICKDETECT ...
%   ...

det = cid.Detector;
cilia = det.detect(image, varargin{:});

end

