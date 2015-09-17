
clear;
load('colourPositives.mat');
cam = webcam(2);
% %Add the images location to the MATLAB path.
% imDir = fullfile(matlabroot,'toolbox','vision','visiondata','handImages');
% addpath(imDir);

%Specify the folder for negative images.
negativeFolder = fullfile('calib_example', 'negativeHandColours');

%trainCascadeObjectDetector('stopSignDetector.xml',data,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);
trainCascadeObjectDetector('handDetector.xml',positiveInstancesC,negativeFolder,'FalseAlarmRate',0.004,'NumCascadeStages',5);


detector = vision.CascadeObjectDetector('handDetector.xml');

while true
    img = fliplr(snapshot(cam));
    bbox = step(detector,img);
    detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'hand');
    imshow(detectedImg);
end