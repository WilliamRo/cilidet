function img = filter(this, img)
%BAREMBEDDER::FILTER ...
%   ...

% check input
img = im2single(img);

% generate hidden layer
N = length(this.SEs);
hidden = zeros([size(img), N]);
for i = 1 : N
    hidden(:, :, i) = imtophat(img, this.SEs{i});
end

% kill dots
negcilia = min(hidden, [], 3);
img = img - negcilia;

end

