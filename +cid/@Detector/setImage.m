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
% remove ruler
% NOT NECESSARY YET
% save image to this.Session.GrayImage
this.Session.setImage('GrayImage', image, true);
% blur gray image
image = imgaussfilt(image, 1);
this.Session.setImage('GrayBlurred', image, true);

end

