function terr = getTerrain(this, img)
%RODDET::GETALTITUDE ...
%   ...

%% Initialize
if isempty(img), terr = zeros(1, this.RodLength); return; end
if mod(size(img, 2), 2) == 0, img = img(:, 1:end-1); end
rod = getShorterRod();
S = rod.RoiSize;  [H, W] = size(img);

%% Trim image
% trim vertically
ofst = (H - S) / 2;
img = img(1+ofst:end-ofst, :);
% trim horizontally
ofst = (W - S) / 2;
img = img(:, 1+ofst:end-ofst);

%% Calculate
N = this.KernelCount;
terr = zeros(1, N);
for i = 1 : N
    knl = rod.FullKernel(i);
    terr(i) = dot(knl(:), img(:));
end

%% Output
terr = terr / max(terr);
terr = cid.utils.shift2center(1, terr);

%% Worker Method
    function rod = getShorterRod()
        % get image size
        [H, W] = size(img);
        % 
        if H <= W
            if isempty(this.ShorterRod)
                len = 2 * floor((H - 1) / 2 * 0.7) + 1;
                this.ShorterRod = cid.RodDet(...
                    'cnt', this.KernelCount, ...
                    'len', len, ...
                    'sigma', this.Sigma); 
            end
            rod = this.ShorterRod;
        else
            len = 2 * floor((W - 1) / 2 * 0.7) + 1;
            rod  = cid.RodDet(...
                'cnt', this.KernelCount, ...
                'len', len, ...
                'sigma', this.Sigma);
        end % if H <= W
    end % getShorterRod
end


