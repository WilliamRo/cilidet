function [sctn, idcs] = getSection(this, pos)
%ANALYZER::GETSECTION ...
%   ...

%% Check input and initialize
roddet = this.Detector.RodDetector;
[S, M] = deal(roddet.RoiSize, roddet.RodLength);
index = this.Session.MapCache.PeakIndices(pos(1), pos(2));
sctn = zeros(1, M);

%% Get section
mid = (S + 1) / 2;
idcs = repmat(pos, M, 1) + roddet.Perpendiculars(:, :, index) - mid;
% sampling
for i = 1 : M
    if this.Session.inbound(idcs(i, :))
        sctn(i) = this.Session.Revealed(idcs(i, 1), idcs(i, 2));
    end
end

end

