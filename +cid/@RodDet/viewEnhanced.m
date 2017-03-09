function viewEnhanced(this)
%RODDET::VIEWENHANCED ...
%   ...

%% Gather enhanced results
stack = this.Image;
stack(:, :, 2) = this.AltitudeMap;
% stack(:, :, 3) = edge(this.Image);
% generate labels
labels = 1 : size(stack, 3);

%% View
viewer = imv.ImageViewer(stack, labels, @interpreter);
viewer.view

end

%% interpreter
function str = interpreter(index)

titles = {'Origin Image', 'Altitude Map', ...
          'Placeholder'};
str = titles{index};

end

