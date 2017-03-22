function getMaps(this)
%DETECTOR::GETMAPS ...
%   ...

maps = this.RodDetector.generateMaps(this.Session.EnhancedImage);
this.Session.setMaps(maps);

end

