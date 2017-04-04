function info = trace(this, center, info)
%ANALYZER::TRACE finds ridges of cilia
%  Syntax: ridgeinfo = analyzer.trace(center)
%  Parameters:
%    center - 1x2 array, center position
%    index  - direction index
%    info   - ridge info, set during recursion

%% Check input and initialize
narginchk(2, 3)
if nargin < 3, info = []; end
if isempty(info), info = struct(...
        'ridge', [], 'width', [], 'illu', [], 'alti', [], ...
        'health', [], 'kappa', 0, 'sign', 1); end
% debug option
if length(info.illu) > 500, this.DebugMode = true; end

%% Move forward
oldcenter = center;
delta = Direction(center) * info.kappa * info.sign * this.StepLength;
% step (1/2)
center = round(center + delta);
% check inbound
if ~this.Session.inbound(center), return; end
% get section
[sctn, idcs] = this.getSection(center);
% find peak and update center
rad = this.RidgeArgs.PeakRadius;
mid = (this.Detector.RodDetector.RodLength + 1) / 2;
[~, pkid] = max(sctn(mid - rad:mid + rad));
pkid = pkid + mid - rad - 1;
% step (2/2)
if pkid ~= mid
    newcenter = idcs(pkid, :);
    % check inbound
    if ~this.Session.inbound(newcenter), return; end
    if info.kappa && ...
       ~isempty(find(sum(repmat(newcenter, size(info.ridge, 1), 1) ...
       == info.ridge, 2) == 2, 1)), return; end
    center = newcenter;
    % update sctn, not adjust position again
    [sctn, idcs] = this.getSection(center);
end % step 2
% update direction
updateDirection()

%% Decide whether to continue
if info.kappa == 1 && length(info.ridge) > 7, return; end
if info.kappa == -1 && length(info.ridge) > 13, return; end
if this.DebugMode, plotSection(); end

%% Recurse
% record
if info.kappa == 0
    info.ridge = center;
    % continue
    info.kappa = 1;
    info = this.trace(center, info);
    info.kappa = -1;
    info = this.trace(center, info);
else
    if info.kappa == 1,
        info.ridge = [info.ridge; center];
    elseif info.kappa == -1
        info.ridge = [center; info.ridge];
    end
    % continue
    info = this.trace(center, info);
end

%% Nested functions
% Direction
    function val = Direction(pos)
        index = this.Session.MapCache.PeakIndices(pos(1), pos(2));
        val = this.Detector.RodDetector.Directions(index, :);
    end
% updateDirection
    function updateDirection()
        olddrct = Direction(oldcenter) * info.sign;
        newdrct = Direction(center) * info.sign;
        info.sign = sign(dot(olddrct, newdrct));
    end
% plot section
    function plotSection()
        % get roi
        [ofst, R] = deal(50, 25);
        image = padarray(this.Session.Revealed, [ofst, ofst]);
        cter = center + ofst;
        [xslice, yslice] = deal(cter(1)+(-R:R), cter(2)+(-R:R));
        roi = image(xslice, yslice);
        % get ppdc
        ppdc = idcs - repmat([xslice(1), yslice(1)], ...
            size(idcs, 1), 1) + 1 + ofst;
        o = (size(roi, 1) + 1) / 2;
        % roi and ppdc
        figure(cid.config.SectionFigureID)
        subplot(1, 2, 1), hold off
        imshow(roi), hold on
        plot(ppdc(:, 2), ppdc(:, 1), 'g-'), plot(o, o, 'gs')
        % section
        subplot(1, 2, 2)
        plot(sctn)
        % pause
        pause
    end

end

