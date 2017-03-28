%% Initialize
clear, clc
de = cid.Detector;
vr = imv.ImageViewer;

%% Read image and preprocess
index = 1;
de.setImage(bmk(index));
img = de.Session.GrayImage;
vr.addImage(img, 'Gray Image');
img = imgaussfilt(img, 0.7);
vr.addImage(img, 'Blurred Gray Image');

%% Enhance
% reomve background
img = imtophat(img, strel('disk', 4));
vr.addImage(img, 'Backgound Removed')
% blur
s = 1;
for s = []
    img = imgaussfilt(img, s);
    vr.addImage(img, 'Blurred')
end
% remove spots (method II)
tmp = img;
[N, L, T] = deal(6, 9, 2);
for T = 2
    be = cid.mf.BarEmbedder(N, L, T);
    img = be.filter(tmp);  beimg = img;
    strparam = sprintf(' (N=%d, L=%d, T=%d)', N, L, T);
%     vr.addImage(img, ['Spots Killed Image', strparam])
end
%
D = 7;
for D = D
    la = cid.mf.Lasso(D);
    img = la.filter(tmp); laimg = img;
    strparam = sprintf(' (D=%d)', D);
%     vr.addImage(img, ['Spots Killed Image', strparam])
end
%
img = max(laimg, beimg);
vr.addImage(img, 'max');
% blur
s = 1;
for s = s
    img = imgaussfilt(img, s);
    vr.addImage(img, 'Blurred')
end
% imclose
R = 6;
for R = R
    label = sprintf('imclose (R=%d)', R);
    img = imclose(img, strel('disk', R));
    vr.addImage(img, label)
    %
%     label = sprintf('tophat (R=%d)', 4);
%     img = imtophat(img, strel('disk', 4));
%     vr.addImage(img, label)
end
% tophat
R = 4;
for R = R
    label = sprintf('tophat (R=%d)', R);
    img = imtophat(img, strel('disk', R));
    vr.addImage(img, label)
end
% final
% img = 

%% View
vr.view













