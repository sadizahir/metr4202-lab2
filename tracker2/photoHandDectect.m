% it's always good to clear the workspace!
clear;

% start the detector
detector = vision.CascadeObjectDetector('C:\Users\Kate\Documents\metr4202-lab2\tracker2\pun_detector.xml', 'MergeThreshold', 20);

filename = strcat('C:\Users\Kate\Documents\metr4202-lab2\depth','.png');
im = imread(filename); % comment out if you don't want mirror image
img = fliplr(imresize(im, 0.7));
imshow(img)

bbox = step(detector, img); % grab the bounding box for a possible region with hand in it   

detectedImg = insertObjectAnnotation(img, 'rectangle', bbox, 'hand');
    
centre_image = [(bbox(1)+(bbox(3)/2)), (bbox(2)+(bbox(4)/2))]

% project the edited image to screen
imshow(detectedImg, 'InitialMagnification', 300);






