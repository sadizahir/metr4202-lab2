colorImage = imread('posters.jpg');
I = rgb2gray(colorImage);

% Detect MSER regions.
[mserRegions] = detectMSERFeatures(I, ...
    'RegionAreaRange',[100 8000],'ThresholdDelta',4);

figure
imshow(I)
hold on
plot(mserRegions, 'showPixelList', true,'showEllipses',false)
title('MSER regions')
hold off