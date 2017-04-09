function data = rescale(data)
%RESCALE ...
%   ...

data = data - min(data(:));
data = data / max(data(:));

end

