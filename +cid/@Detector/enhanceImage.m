function enhanceImage(this)
%DETECTOR::ENHANCEIMAGE ...
%   ...

%% Remove background
img = imtophat(this.Session.EnhancedImage, ...
    strel('disk', this.EnhanceParams.DiskSize));
this.Session.setImage('BgRemoved', img)
% blur img
if false
    img = imgaussfilt(img, this.EnhanceParams.BlurSigma);
    this.Session.setImage('BgRmdBlurred', img)
end

%% Remove spots
img = this.DotKiller.filter(img);

%% Set enhanced image to session
this.Session.setImage('EnhancedImage', img)

end
