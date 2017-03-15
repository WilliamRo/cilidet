function setImage(this, image)
%DETECOTR::SETIMAGE ...
%   ...

%% Check input
if ischar(image), image = imread(image); end
this.RawImage = image;

%% Convert raw data to gray scale image over 0~1
if size(this.RawImage, 3) > 1, image = rgb2gray(image); end
image = im2single(image);
image = image / max(image(:));

%% Preprocess image
% remove ruler
% NOT NECESSARY YET
% save image to this.GrayImage
this.GrayImage = image;

end

