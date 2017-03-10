%% Create empty ImageViewer
viewer = imv.ImageViewer;

%% Create a RodDet and get origin image
rd = cid.RodDet('cnt', 12, 'len', 23, 'sigma', 1.28);
rd.setImage(bmk(1))
img = rd.Image;
% add origin image to viewer
viewer.addImage(img, 'Origin Image')
% add altitude map to viewer
% viewer.addImage(rd.AltitudeMap, 'Altitude Map')

%% ...


%% View
viewer.view