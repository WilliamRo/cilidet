function reveal(this)
%DETECTOR::REVEAL ...
%   ...

img = this.Session.AltitudeMap .* this.Session.GrayBlurred;
img = imtophat(img, strel('disk', 5));
this.Session.setImage('DecisionMap', img);
% this.Session.setImage('Revealed', ...
%     this.Session.AltitudeMap .* this.Session.EnhancedImage);

end

