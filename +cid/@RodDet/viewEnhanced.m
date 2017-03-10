function viewEnhanced(this)
%RODDET::VIEWENHANCED ...
%   ...

%% Gather enhanced results
stack = this.Image;
stack(:, :, 2) = this.AltitudeMap;
% imopen
stack(:, :, 3) = imopen(this.Image, strel('disk', 4));
stack(:, :, 4) = this.Image - stack(:, :, 3);
% generate labels
labels = 1 : size(stack, 3);

%% View
viewer = imv.ImageViewer(stack, labels, @interpreter);
viewer.view

end

%% interpreter
function str = interpreter(index)
    
titles = {'Origin Image', 'Altitude Map', ...
          'Placeholder', 'Placeholder', ...
          'Placeholder', 'Placeholder'};
str = titles{index};

end

