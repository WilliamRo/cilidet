function viewEnhanced(this)
%RODDET::VIEWENHANCED ...
%   ...

%% Gather enhanced results
N = 2;
labels = 1 : N;
stack = repmat(this.Image, 1, 1, N);
stack(:, :, 2) = this.AltitudeMap;

%% View
viewer = imv.ImageViewer(stack, labels, @interpreter);
viewer.view

end

%% interpreter
function str = interpreter(index)

titles = {'Origin Image', 'Altitude Map'};
str = titles{index};

end

