function setImage(this, image)
%DETECOTR::SETIMAGE ...
%   ...

%% Check input
if ischar(image), image = imread(image); end
% initialize session
this.Session = cid.Session;
this.Session.setImage('RawImage', image);

%% Convert raw data to gray scale image over 0~1
if size(image, 3) > 1, image = rgb2gray(image); end
image = im2single(image);
image = image / max(image(:));

%% Preprocess image
% save image to this.Session.GrayImage
this.Session.setImage('GrayImage', image, true);
% blur gray image
image = imgaussfilt(image, 1);
this.Session.setImage('GrayBlurred', image, true);

%% Enhance image
% remove background
img = imtophat(this.Session.EnhancedImage, ...
    strel('disk', this.EnhanceParams.DiskSize));
this.Session.setImage('BgRemoved', img)
% remove spots
img1 = this.DotKiller.filter(img);
img2 = this.CowBoy.filter(img);
img = max(img1, img2);
% set enhanced image to session
this.Session.setImage('EnhancedImage', img)

%% Generate maps
maps = this.RodDetector.generateMaps(this.Session.GrayBlurred);
this.Session.setMaps(maps);
% reveal
img = this.Session.AltitudeMap .* this.Session.GrayBlurred;
img = imtophat(img, strel('disk', 5));
this.Session.setImage('DecisionMap', img);

end

