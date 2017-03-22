%% Initialize
clear, clc
de = cid.Detector;
vr = imv.ImageViewer;

%% Read image and preprocess
index = 6;
de.setImage(bmk(index));
gray_image = de.Session.GrayImage;
vr.addImage(gray_image, 'Gray Image');
blurred_image = imgaussfilt(gray_image, 0.7);
vr.addImage(blurred_image, 'Blurred Gray Image');

%% Enhance
% reomve background
bg_removed_on_blurred = imtophat(blurred_image, strel('disk', 4));
vr.addImage(bg_removed_on_blurred, 'Backgound Removed Blurred Image')
% remove spots (method I)
[N, L, T] = deal(6, 9, 2);
for T = 2
    be = cid.mf.BarEmbedder(N, L, T);
    spots_killed = be.filter(bg_removed_on_blurred);
    strparam = sprintf(' (N=%d, L=%d, T=%d)', N, L, T);
    vr.addImage(spots_killed, ['Spots Killed Image', strparam])
end

%% 

%% View
vr.view