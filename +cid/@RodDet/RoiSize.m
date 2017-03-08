function val = RoiSize(this)
    R = (this.RodLength - 1) / 2;
    val = ceil(R / 0.7) * 2 + 1;
end