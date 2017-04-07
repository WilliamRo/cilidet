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
        'ridge', [], 'surf', [], 'illu', [], 'alti', [], ...
        'health', [], 'kappa', 0, 'sign', 1); end
% debug option
if ~this.DebugMode && length(info.illu) > this.RidgeArgs.MaxLen, ...
    return; end
% multi-scope variable
rad = this.RidgeArgs.PeakRadius;
mid = (this.Detector.RodDetector.RodLength + 1) / 2;
minpct = this.RidgeArgs.MinIlluPct;

%% Move forward
oldcenter = center;
center = stepForward();
% check inbound
if ~this.Session.inbound(center), return; end
% adjust center
[newcenter, sctn, idcs] = adjustCenter();
% step (2/2)
if any(newcenter ~= center)
    % check inbound
    if ~this.Session.inbound(newcenter), return; end
    if ~overlap(newcenter)
        center = newcenter;
        % update sctn, not adjust position again
        [sctn, idcs] = this.getSection(center);
    end % if not overlap
end % step 2
if overlap, return; end
% update direction
updateSign()

%% Decide whether to continue
% extrct information
health = getHealth();
illu = this.Session.IlluMap(center(1), center(2));
illuR = this.Session.GrayBlurred(center(1), center(2));
% plot in debug mode
if this.DebugMode, plotSection(); end
% decide to return
if health < this.RidgeArgs.MinHealth, return; end
if ~isempty(info.illu) && illu < minpct * max(info.illu), return; end


%% Recurse
% record
if info.kappa == 0
    [info.ridge, info.illu, info.health] = deal(center, illu, health);
    [info.surf, info.illuR] = deal(sctn(:, 2), illuR);
    % continue
    info.kappa = 1;
    info = this.trace(center, info);
    info.kappa = -1;
    info.sign = 1;
    info = this.trace(center, info);
else
    if info.kappa == 1,
        info.ridge = [info.ridge; center];
        info.illu = [info.illu; illu];
        info.illuR = [info.illuR; illuR];
        info.health = [info.health; health];
        info.surf = [info.surf, sctn(:, 2)];
    elseif info.kappa == -1
        info.ridge = [center; info.ridge];
        info.illu = [illu; info.illu];
        info.illuR = [illuR; info.illuR];
        info.health = [health; info.health];
        info.surf = [sctn(:, 2), info.surf];
    end
    % continue
    info = this.trace(center, info);
end

%% Nested functions
% stepForward
    function newpos = stepForward(pos)
        if nargin < 1, pos = center; end
        delta = Direction(pos) * info.kappa * ...
            info.sign * this.StepLength;
        newpos = round(pos + delta);
    end
% adjustCenter
    function [pos, tsctn, tidcs] = adjustCenter(pos)
        if nargin < 1, pos = center; end
        % get section
        [tsctn, tidcs] = this.getSection(pos);
        % find peak
        [~, pkid] = max(tsctn(mid - rad:mid + rad, 1));
        pkid = pkid + mid - rad - 1;
        if tsctn(mid, 1) < tsctn(pkid, 1)
            pos = tidcs(pkid, :);
        end
    end % adjustCenter
% circle
    function val = overlap(pos)
        if nargin < 1, pos = center; end
        if isempty(info.ridge), val = false; 
        else
            val = ~isempty(find(sum(repmat(pos, ...
                size(info.ridge, 1), 1) == info.ridge, 2) == 2, 1));
        end
    end
% Direction
    function val = Direction(pos)
        index = this.Session.MapCache.PeakIndices(pos(1), pos(2));
        val = this.Detector.RodDetector.Directions(index, :);
    end
% updateDirection
    function updateSign()
        olddrct = Direction(oldcenter) * info.sign;
        newdrct = Direction(center);
        info.sign = sign(dot(olddrct, newdrct));
        % flip section
        if info.sign < 0, sctn(:, 2) = sctn(end:-1:1, 2); end
    end
% getHealth
    function val = getHealth()
        mask = abs((1:length(sctn)) - mid) <= rad;
        val = sum(sctn(mask)) / sum(sctn(~mask));
    end
% plot section
    function plotSection()
        oldf = gcf;
        % get roi
        [ofst, R] = deal(50, 25);
        image = padarray(this.Session.IlluMap, [ofst, ofst]);
        cter = center + ofst;
        [xslice, yslice] = deal(cter(1)+(-R:R), cter(2)+(-R:R));
        roi = image(xslice, yslice);
        % get ppdc
        topleft = [xslice(1), yslice(1)];
        ppdc = idcs - repmat(topleft, size(idcs, 1), 1) + 1 + ofst;
        o = (size(roi, 1) + 1) / 2;
        % roi and ppdc
        f = figure(cid.config.SectionFigureID);
        ftt = sprintf('Section, kappa = %d', info.kappa);
        [f.Name, f.NumberTitle] = deal(ftt, 'off');
        [f.ToolBar, f.MenuBar] = deal('none');
        subplot(1, 2, 1), hold off
        imshow(roi, []), hold on
        plot(ppdc(:, 2), ppdc(:, 1), 'g-'), plot(o, o, 'ys')
        % next and next adjust
        if info.kappa
            nextpos = stepForward();
            if this.Session.inbound(nextpos)
                nextadjust = adjustCenter(nextpos);
                nextpos = nextpos - topleft + 1 + ofst;
                nextadjust = nextadjust - topleft + 1 + ofst;
                plot(nextpos(2), nextpos(1), ...
                    's', 'color', [1, 0.5, 0])
                plot(nextadjust(2), nextadjust(1), 'rs')
                octer = oldcenter - topleft + 1 + ofst;
                plot(octer(2), octer(1), 'bs', 'MarkerSize', 3)
            end
        end
        % section
        L = size(sctn, 1);
        [mindex, x] = deal((L + 1) / 2, 1:L);
        subplot(2, 2, 4), hold off
        ax = plotyy(x, sctn(:, 1), x, sctn(:, 2)); hold on
        xlim(ax(1), [1, L]), xlim(ax(2), [1, L])
        ylabel(ax(1), 'Revealed'), ylabel(ax(2), 'Blurred')
        plot(mindex, sctn(mindex, 1), 'gs')
        tt = sprintf('Health = %.2f, Illu = %.2f', health, illu);
        title(tt), xlim([1, length(sctn)])
        % illuminations
        subplot(2, 2, 2), hold off
        L = length(info.illu);
        lgd = {};
        if L > 0
            plot(info.illu), hold on
            minillu = max(info.illu) * minpct;
            plot([1, max(L, 2)], [minillu, minillu], ...
                '-', 'Color', [1, 0.5, 0])
            title(sprintf('Pct = %.3f', illu / max(info.illu)))
            lgd = [lgd, {'Ridge Illu'}, {'Min Illu'}];
        end
        L = max(L, 2);
        plot([1, L], [illu, illu], 'r--'), xlim([1, L])
        lgd = [lgd, {'Current Illu'}];
        legend(lgd, 'Location', 'Best')
        % restore and pause
        pause
    end

end

