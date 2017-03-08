function generateKernels(this)
%RODDET::GENERATEKERNELS
%   ...

    % initialize variables
    N = this.KernelCount;
    R = (this.RodLength - 1) / 2;
    S = this.RoiSize;
    [x0, y0] = deal((S + 1) / 2);
    sigm = this.Sigma;
    delta = pi / N;
    theta = 0 : delta : pi - delta;
    %
    this.Kernels = cell(N, 1);
    [Y, X] = meshgrid(1 : S);
    
    % generate kernels, ideal, skeleton and perpendicular
    ideal = zeros(1, N);         mid = R + 1;
    sklt = zeros(R*2+1, 2, N);   ppdc = zeros(R*2+1, 2, N);  
    this.Directions = zeros(N, 2);
    for i = 1 : N
        knl = PSF(X, Y, x0, y0, sigm);
        sklt(mid, 1, i) = x0;  sklt(mid, 2, i) = y0;
        ppdc(mid, 1, i) = x0;  ppdc(mid, 2, i) = y0;
        
        dx = sin(theta(i));           dy = cos(theta(i));
        this.Directions(i, :) = [-dx, dy];
        dxp = sin(theta(i) + pi/2);   dyp = cos(theta(i) + pi/2);
        for j = 1 : R
            % skeleton direction
            x = x0 - j * dx;          y = y0 + j * dy;
            sklt(mid+j, 1, i) = round(x);    
            sklt(mid+j, 2, i) = round(y);
            knl = knl + PSF(X, Y, x, y, sigm);
            %
            x = x0 + j * dx;          y = y0 - j * dy;
            sklt(mid-j, 1, i) = round(x);    
            sklt(mid-j, 2, i) = round(y);
            knl = knl + PSF(X, Y, x, y, sigm);
            
            % perpendicular direction
            x = x0 - j * dxp;         y = y0 + j * dyp;
            ppdc(mid+j, 1, i) = round(x);    
            ppdc(mid+j, 2, i) = round(y);
            %
            x = x0 + j * dxp;         y = y0 - j * dyp;
            ppdc(mid-j, 1, i) = round(x);    
            ppdc(mid-j, 2, i) = round(y);
        end % for j
        
        % normalize kernel and bomb
        knl = knl / max(max(knl));
        % calculate ideal(i)
        if i == 1, img = knl; end
        ideal(i) = sum(sum(img .* knl));
        % cut
        panda = knl < 0.001;
        xmar = min(sum(panda(1:R, :), 1));
        ymar = min(sum(panda(:, 1:R), 2));
        this.Kernels{i} = knl((1 + xmar):(end - xmar), ...
                              (1 + ymar):(end - ymar));
    end % for i = 1 : N
    
    this.Skeletons = sklt;  this.Perpendiculars = ppdc;
    
    % postproceed ideal
    ideal = ideal / max(ideal);
    this.Ideal = cid.utils.shift2center(1, ideal);
    
end % function

% gaussian point spread function
function Z = PSF(X, Y, x0, y0, sigm)
    Z = exp(-((X - x0).^2 + (Y - y0).^2) ./ (2 * sigm.^2));
end  