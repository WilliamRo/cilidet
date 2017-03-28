function enhanceImage(this)
%DETECTOR::ENHANCEIMAGE ...
%   ...

%% Remove background
img = imtophat(this.Session.EnhancedImage, ...
    strel('disk', this.EnhanceParams.DiskSize));
this.Session.setImage('BgRemoved', img)

%% Remove spots
img1 = this.DotKiller.filter(img);
img2 = this.CowBoy.filter(img);
img = max(img1, img2);

%% Set enhanced image to session
this.Session.setImage('EnhancedImage', img)

end

