clear
%% Create empty ImageViewer
viewer = imv.ImageViewer;

%% Create a RodDet and get origin image
rd = cid.RodDet('cnt', 12, 'len', 23, 'sigma', 1.28);
rd.setImage(bmk(5))
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
blurredtophat = imgaussfilt(tophat, 0.8);
viewer.addImage(blurredtophat, 'Blurred Tophat')
% kill spot 1
% viewer.addImage(blurredtophat, 'Blurred Tophat')
sk1 = cid.utils.killspot(blurredtophat, 6);
viewer.addImage(sk1, 'Spot killed 1');
% hatick
ks = hatrick(blurredtophat);
viewer.addImage(ks, sprintf('After Hatrick'))
% % blur
% blurredsk1 = imgaussfilt(sk1, 0.8);
% viewer.addImage(blurredsk1, 'Blurred sk1')
% % kill spot 1
% sk2 = cid.utils.killspot(blurredsk1, 8);
% viewer.addImage(sk2, 'Spot killed 2');
% % blur sk2
% blurredsk2 = imgaussfilt(sk2, 0.8);
% viewer.addImage(blurredsk2, 'Blurred sk2')
% % tophat again
% tophat2 = imtophat(blurredsk2, strel('disk', diskSize));
% viewer.addImage(tophat2, 'Tophat2')
end

%% View
viewer.view