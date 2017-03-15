function viewEnhanced(this)
%RODDET::VIEWENHANCED ...
%   ...

%% Initialize an instance of ImageViewer
viewer = imv.ImageViewer;

%% Gather enhanced results
viewer.addImage(this.Image, 'Original Image')
viewer.addImage(this.ResponseMap, 'Response Map')
viewer.addImage(this.AltitudeMap, 'Altitude Map')
%
disk = strel('disk', 3);
tophat = imtophat(this.ResponseMap, disk);
viewer.addImage(tophat, 'Tophat over Resmap')
enhanced = tophat .* this.AltitudeMap .* this.Image;
viewer.addImage(enhanced, 'Enhanced')

%% View
viewer.view

end
