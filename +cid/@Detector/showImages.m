function showImages(this)
%DETECTOR::SHOWIMAGES ...
%   ...

% initialize an instance of ImageViewer
viewer = imv.ImageViewer;

% add images to viewer
viewer.addImage(this.RawImage, 'Raw Image')
viewer.addImage(this.GrayImage, 'Grayscale Image')

% show in figure
viewer.view

end

