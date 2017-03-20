function showSEs(this)
%DOTKIL::SHOWSES ...
%   ...

vr = imv.ImageViewer;
for i = 1 : length(this.Masks)
    vr.addImage(this.Masks{i});
end
vr.view

end

