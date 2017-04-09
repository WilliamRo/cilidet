function [sctn, idcs] = getSection(this, pos)
%ANALYZER::GETSECTION ...
%   ...

%% Check input and initialize
roddet = this.Detector.RodDetector;
[S, M] = deal(roddet.RoiSize, roddet.RodLength);
index = this.Session.MapCache.PeakIndices(pos(1), pos(2));
sctn = zeros(M, 3);

%% Get section
mid = (S + 1) / 2;
idcs = repmat(pos, M, 1) + roddet.Perpendiculars(:, :, index) - mid;
% sampling
for i = 1 : M
    if this.Session.inbound(idcs(i, :))
        sctn(i, 1) = this.Session.IlluMap(idcs(i, 1), idcs(i, 2));
        sctn(i, 2) = this.Session.GrayBlurred(idcs(i, 1), idcs(i, 2));
        sctn(i, 3) = this.Session.AltitudeMap(idcs(i, 1), idcs(i, 2));
    end
end

end

