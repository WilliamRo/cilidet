function knl = FullKernel(this, index)
%RODDET::FULLKERNEL ...
%   ...

knl = this.Kernels{index};
sz = size(knl);
pad = (this.RoiSize - sz) / 2;
knl = padarray(knl, pad);

end

