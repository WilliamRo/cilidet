%% Initialize
clear, clc, vr = imv.ImageViewer;
index = 1;

%% Read image and convert to gray
img = imread(bmk(index));
if size(img, 3) > 1, img = rgb2gray(img); end
img = im2single(img);
% ...................................................... gray_img
gray_img = img / max(img(:));
gray_img = adapthisteq(gray_img);
% ...................................................... blurred_gray
blurred_gray = imgaussfilt(gray_img, 1);
vr.addImage(blurred_gray, 'Blurred Gray')

%% Kill spots
dk = cid.mf.BarEmbedder(11, 8, 2);
img_dk = dk.filter(blurred_gray);
img_dk = imtophat(img_dk, strel('disk', 4));
vr.addImage(img_dk, 'Image DK')

%% Decision map
% rd = cid.RodDet;
% maps = rd.generateMaps(img);
% [resp_map, alti_map, map_cache] = deal(maps{:});
% vr.addImage(alti_map, 'Altitude Map')
% % .................................................... deci_map
% deci_map = alti_map .* img_dk;
% vr.addImage(deci_map, 'Decision Map')

%% View
vr.view