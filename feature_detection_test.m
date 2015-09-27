penImage = imresize(rgb2gray(imread('calib_img\pens\pen4.jpg')), 1);
sceneImage = imresize(rgb2gray(imread('calib_img\pens\penscene3.jpg')), 1);

penPoints = detectSURFFeatures(penImage);
scenePoints = detectSURFFeatures(sceneImage);

[penFeatures, penPoints] = extractFeatures(penImage, penPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

penPairs = matchFeatures(penFeatures, sceneFeatures);

matchedPenPoints = penPoints(penPairs(:, 1), :);
matchedScenePoints = scenePoints(penPairs(:, 2), :);

[tform, inlierPenPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedPenPoints, matchedScenePoints, 'affine');

penPolygon = [1, 1;...                           % top-left
        size(penImage, 2), 1;...                 % top-right
        size(penImage, 2), size(penImage, 1);... % bottom-right
        1, size(penImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon

newPenPolygon = transformPointsForward(tform, penPolygon);

figure;
imshow(sceneImage);
hold on;
line(newPenPolygon(:, 1), newPenPolygon(:, 2), 'Color', 'y');
title('Detected Box');
