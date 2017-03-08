function showKernels(this)
%RODDET::SHOWKERNELS
%   ...
    
    % initialize variables
    N = this.KernelCount;
    H = floor(sqrt(N));  
    W = ceil(N / H);
    % show kernels in each subplot
    cid.utils.newfig('Kernels');
    for i = 1 : N
        subplot(H, W, i);
        imshow(this.Kernels{i});
        title(['Kernel ', num2str(i)]);
    end % end for i 
    
end % end function