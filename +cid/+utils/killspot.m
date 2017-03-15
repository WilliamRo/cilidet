function img = killspot(img, spotSize)
%KILLSPOT ...
%   ...

% check input 
if nargin < 2, spotSize = 6; end

% generate inner and outter SE
[outter, inner] = deal(ones(spotSize + 2));
outter(2:end-1, 2:end-1) = 0;
inner = inner - outter;
outterSE = strel('arbitrary', outter);
innerSE = strel('arbitrary', inner);

% kill spot
innerDilate = imdilate(img, innerSE);
outterDilate = imdilate(img, outterSE);
spot = max(0, innerDilate - outterDilate);
img = max(0, img - spot);

end

