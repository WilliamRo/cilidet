function maps = generateMaps(this, img)
%RODDET::GENERATEMAPS ...
%   ...

%% Generate low-level derivatives
% initialize variables
N = this.KernelCount;
[H, W] = size(img);
hidden = zeros(H, W, N);
bg = mean(mean(img));
% convolve
fprintf(' > Convolving ... 00%%');  tic;
for i = 1 : N
    hidden(:, :, i) = imfilter(img, this.Kernels{i}, 'conv', bg);
    % show progress
    fprintf('\b\b\b%2d%%', floor(100 * i / N));
end % for i
fprintf(' (%.2f sec)\n', toc);
    
%% Generate high-level derivatives
% find peaks
[ResponseMap, PeakIndices] = max(hidden, [], 3);
% generate altitude map
foo = hidden ./ repmat(max(hidden, [], 3), 1, 1, N);
AltitudeMap = 1 - min(foo, [], 3);

%% Wrap maps
cache = struct('Hidden', hidden, 'PeakIndices', PeakIndices);
maps = {ResponseMap, AltitudeMap, cache};

end

