function getMaps(this)
%DETECTOR::GETMAPS ...
%   ...

maps = this.RodDetector.generateMaps(this.Session.GrayBlurred);
this.Session.setMaps(maps);

end

