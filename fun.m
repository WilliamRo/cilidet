clear
%% Create empty ImageViewer
viewer = imv.ImageViewer;

%% Create a RodDet and get origin image
rd = cid.RodDet('cnt', 12, 'len', 23, 'sigma', 1.28);
rd.setImage(bmk(28))
img = rd.Image;
% add origin image to viewer
viewer.addImage(img, 'Origin Image')
% add altitude map to viewer
% viewer.addImage(rd.AltitudeMap, 'Altitude Map')

%% ...
if false
% blur
if false    
ori_img = img;
gauss = fspecial('gaussian', 4);
img = imfilter(img, gauss, 'same');
viewer.addImage(img, 'Blured')
end
% tophat
for r = 2:5
    disk = strel('disk', r);
    rstr = sprintf(' (R = %d)', r);
    opened = imopen(img, disk);
    closed = imclose(img, disk);
    tophat = img - opened;
    bottomhat = closed - img;
    % viewer.addImage(opened, 'Opened')
    % viewer.addImage(closed, 'Closed')
    viewer.addImage(tophat, ['Top-hat', rstr])
    % viewer.addImage(closed - img, 'Bottom-hat')
    % viewer.addImage(2 * img - closed, 'XXX')

end
end

%% Dilate test
if true
% tophat
diskSize = 4;
tophat = imtophat(img, strel('disk', diskSize));
viewer.addImage(tophat, sprintf('Tophat (disksize=%d)', diskSize))
% blur
bluredtophat = imgaussfilt(tophat, 0.8);
% kill spot
tmp2 = cid.utils.killspot(bluredtophat, 6);
viewer.addImage(tmp2, 'Spot killed');
% rd
rd.setImage(tmp2);
% tmp4 = rd.AltitudeMap .* rd.ResponseMap .* tmp3;
% viewer.addImage(tmp4, 'tmp4');
end

%% View
viewer.view