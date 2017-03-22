function showKernels(this)
%RODDET::SHOWKERNELS
%   ...

vr = imv.ImageViewer;
for i = 1 : this.KernelCount
    vr.addImage(this.FullKernel(i));
end
vr.view

end % end function