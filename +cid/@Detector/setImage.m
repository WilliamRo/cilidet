function setImage(this, img)
%DETECOTR::SETIMAGE ...
%   ...

%% Check input
if ischar(img), img = imread(img); end
% initialize session
this.Session = cid.Session;
this.Session.setImage('RawImage', img);

%% Convert raw data to gray scale image over 0~1
if size(img, 3) > 1, img = rgb2gray(img); end
img = im2single(img);
img = img / max(img(:));
% save image to this.Session.GrayImage
this.Session.setImage('GrayImage', img);
% blur gray image
img_heq = deal(adapthisteq(img));
img_heq_blu = imgaussfilt(img_heq, 1);
this.Session.setImage('GrayBlurred', img_heq_blu);

%% Enhance image
% remove background (img is GrayBlurred)
img_heq_blu_tph = imtophat(img_heq_blu, ...
    strel('disk', this.EnhanceParams.DiskSize));
this.Session.setImage('BgRemoved', img_heq_blu_tph)
% remove dots (necessary)
img1 = this.DotKiller.filter(img_heq_blu_tph);
img2 = this.CowBoy.filter(img_heq_blu_tph);
img_heq_blu_tph_dk = max(img1, img2);
% enhanced image
this.Session.setImage('EnhancedImage', img_heq_blu_tph_dk)

%% Generate maps
maps = this.RodDetector.generateMaps(img_heq_blu);
this.Session.setMaps(maps);
% reveal
decision_map = this.Session.AltitudeMap .* this.Session.GrayBlurred;
this.Session.setImage('DecisionMap', decision_map);
illu_map = imgaussfilt(img_heq_blu_tph_dk, 1);
this.Session.setImage('IlluMap', illu_map);

%% Enhance image
% img = 

end

