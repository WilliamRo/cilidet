function img = hatrick(img)

% set parameters
stickLength = 8;        % pixels
stickThickness = 2;     % pixels
N = 6;

% generate structuring elements
ses = {};
S = stickLength;
bar = zeros(S);
[X, Y] = cid.utils.indexpixel(zeros(S));
thetas = linspace(0, pi, N + 1);
vr = imv.ImageViewer;%%%%%%%%%%%%%%%%%%%%
for i = 1 : N
    theta = thetas(i);
    distances = abs(sin(theta) * X - cos(theta) * Y);
    se = distances <= stickThickness / 2;
    ses{i} = strel(se);
%     vr.addImage(ses{i});%%%%%%%%%%%%%%%%
end
% vr.view %%%%%%%%%%%%%%%%%%%

% generate hidden layer
hidden = zeros([size(img), N]);
for i = 1 : N
    hidden(:, :, i) = imtophat(img, ses{i});
%     vr.addImage(hidden(:, :, i));%%%%%%%%%%%%%%%%%%
end
negcilia = min(hidden, [], 3);
img = img - negcilia;
% vr.view %%%%%%%%%%%%%%%%%%%

end