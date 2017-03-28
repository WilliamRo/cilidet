%% Initialize
clear, clc
de = cid.Detector;
vr = imv.ImageViewer;

%% Read image and preprocess
index = 37;
de.setImage(bmk(index));
gray_image = de.Session.GrayImage;
vr.addImage(gray_image, 'Gray Image');
blurred_image = imgaussfilt(gray_image, 0.7);
% vr.addImage(blurred_image, 'Blurred Gray Image');

%% Enhance
% reomve background
bg_removed_on_blurred = imtophat(blurred_image, strel('disk', 4));
vr.addImage(bg_removed_on_blurred, 'Backgound Removed Blurred Image')
% remove spots (method I)
[N, L, T] = deal(6, 9, 2);
for T = []
    be = cid.mf.BarEmbedder(N, L, T);
    spots_killed = be.filter(bg_removed_on_blurred);
    strparam = sprintf(' (N=%d, L=%d, T=%d)', N, L, T);
    vr.addImage(spots_killed, ['Spots Killed Image', strparam])
end
% remove spots (method II)
D = 9;
for D = 9
    la = cid.mf.Lasso(D);
    spots_killed = la.filter(bg_removed_on_blurred);
    strparam = sprintf(' (D=%d)', D);
    vr.addImage(spots_killed, ['Spots Killed Image', strparam])
end
blurred_spots_killed = imgaussfilt(spots_killed, 1);
img = blurred_spots_killed;
% gamma
% img = imadjust(img, [], [], 0.6);
% vr.addImage(img, 'blurred_spots_killed')

%% Reveal
% get maps
maps = de.RodDetector.generateMaps(img);
[response_map, altitude_map, map_cache] = deal(maps{:});
%
% vr.addImage(response_map, 'Response Map')
res_hat = imtophat(response_map, strel('disk', 5));
% vr.addImage(res_hat)
%
% vr.addImage(altitude_map, 'Altitude Map')
alt_hat = imtophat(altitude_map, strel('disk', 5));
% vr.addImage(alt_hat)
%
img = alt_hat .* blurred_image .* res_hat;
img = imadjust(img, [], [], 0.6);
% vr.addImage(img, 'M1 .* M2')
%
% img = blurred_spots_killed;
img = spots_killed;
% vr.addImage(img)
for R = 3
    label = sprintf('imclose (R=%d)', R);
    img = imclose(img, strel('disk', R));
    vr.addImage(img, label)
end
img = imtophat(img, strel('disk', 5));
vr.addImage(img)


%% View
vr.view













