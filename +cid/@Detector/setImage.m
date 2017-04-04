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
img = adapthisteq(img);
% img = this.DotKiller.filter(img);
img = imgaussfilt(img, 1);
this.Session.setImage('GrayBlurred', img);

%% Enhance image
% remove background (img is GrayBlurred)
img = imtophat(img, strel('disk', this.EnhanceParams.DiskSize));
this.Session.setImage('BgRemoved', img)
img1 = this.DotKiller.filter(img);
img2 = this.CowBoy.filter(img);
img = max(img1, img2);
% dots = this.Session.BgRemoved - img;
% this.Session.setImage('Tmp', dots)
this.Session.setImage('EnhancedImage', img)
%
img = imclose(img, strel('disk', 4));
this.Session.setImage('Revealed', img)

%% Generate maps
maps = this.RodDetector.generateMaps(this.Session.GrayBlurred);
this.Session.setMaps(maps);
% reveal
img = this.Session.AltitudeMap .* this.Session.GrayBlurred;
% % img = imtophat(img, strel('disk', 4));
this.Session.setImage('DecisionMap', img);

%% Enhance image
% img = 

end

