function setImage(this, img)
%ROIDET::SETIMAGE
%   ...
    
    %% Check input
    narginchk(2, 2);
    if ischar(img), img = imread(img); end
    
    %% Preprocess
    if size(img, 3) > 1, img = rgb2gray(img); end
    img = im2single(img);
    % set image
    img = img / max(max(img));    
    this.Image = img;
    
    %% Generate low-level derivatives
    % initialize variables
    N = this.KernelCount;
    [H, W] = size(img);
    this.HiddenLayer = zeros(H, W, N);
    bg = mean(mean(img));
    this.Background = bg;
    % convolve
    fprintf('>> Convolving ... 00%%');  tic;
    for i = 1 : N
        this.HiddenLayer(:, :, i) = ...
            imfilter(img, this.Kernels{i}, 'conv', bg);
        % show progress
        fprintf('\b\b\b%2d%%', floor(100 * i / N));
    end % for i
    fprintf(' (%.2f sec)\n', toc);
    
    %% Generate high-level derivatives
    % find peaks
    [this.ResponseMap, this.PeakIndices] = ...
        max(this.HiddenLayer, [], 3);
    % generate altitude map
    foo = this.HiddenLayer ./ ...
        repmat(max(this.HiddenLayer, [], 3), 1, 1, N);
    this.AltitudeMap = 1 - min(foo, [], 3);
    gsfter = fspecial('gaussian', [5, 5], 2);
    this.Blur = imfilter(this.Image, gsfter, 'symmetric');
    
end % fucntion













