function generateSEs(this, N, L, T)
%DOTKIL::GENERATESES ...
%   ...

% check inputs
narginchk(4, 4)

% index pixel grid
[X, Y] = cid.utils.indexpixel(zeros(L));

% divide pi
thetas = linspace(0, pi, N + 1);
this.Thetas = thetas(1:end-1);

% generate SEs
for i = 1 : N
    theta = thetas(i);
    distances = abs(sin(theta) * X - cos(theta) * Y);
    this.Masks{i} = distances <= T / 2;
    this.SEs{i} = strel(this.Masks{i});
end

end

