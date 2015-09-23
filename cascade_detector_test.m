% it's always good to clear the workspace!
clear;

% load the appropriate trained image label set (hands)
load('calib_img/palm_up_north/pun_pdn_positives_4.mat');
load('calib_img/palm_up_north/puo_positives.mat'); % palms

% select and start the webcam
cam = webcam(2);

cam.resolution = '320x240';

% Specify the folder for negative images.
negativeFolder = fullfile('calib_img', 'palm_up_north', 'negative');

% train the detector
trainCascadeObjectDetector('pun_detector.xml', pun_pdn_positives_4, negativeFolder, 'FalseAlarmRate', 0.5, 'NumCascadeStages', 17);
trainCascadeObjectDetector('puo_detector.xml', puo_positives, negativeFolder, 'FalseAlarmRate', 0.5, 'NumCascadeStages', 17);

% start the detector
detector = vision.CascadeObjectDetector('pun_detector.xml', 'MergeThreshold', 20);
palmDetector = vision.CascadeObjectDetector('puo_detector.xml');
flag = 0;


while flag == 0
    img = fliplr(snapshot(cam)); % comment out if you don't want mirror image
    bbox = step(detector, img); % grab the bounding box for a possible region with hand in it
    
    % we now have a bunch of bounding boxes; figure out if any of them
    % should be rejected
    goodrows = 1;
    goodbox = [];
    
    for i = 1:size(bbox,1)
        % go through each sub-box
        subbox = bbox(i,:);
        
        % we want to detect a palm in a possible sub-box
        candidate = imcrop(img, subbox);
        
        cbox = step(palmDetector, candidate);
        
        % copy to "good boxes" array if the subbox contains a palm
        if size(cbox,1) > 0
            goodbox(goodrows,:) = bbox(i,:);
            goodrows = goodrows + 1;
        end
 
    end
    
    % reproject bbox
    % goodbox = goodbox*2;
    
    if size(goodbox,1) > 0
        % insert a bounding box into the image
        detectedImg = insertObjectAnnotation(img, 'rectangle', goodbox, 'hand');
        flag = 1;
    else
        detectedImg = img;
    end
    
    % project the edited image to screen
    imshow(detectedImg, 'InitialMagnification', 300);
end

% at this point, we have a hand to track!!
tracker = vision.HistogramBasedTracker; % create the tracker

[~,hueChannel,~] = rgb2hsv(img); % convert to HSV

% initialise tracker on hue pixels from palm
initializeObject(tracker, hueChannel, bbox(1,:));

while true
   img = fliplr(snapshot(cam)); % comment out if you don't want mirror image
   [~,hueChannel,~] = rgb2hsv(img); % convert to HSV
   bbox = step(tracker, hueChannel);
   z = insertObjectAnnotation(hueChannel, 'rectangle', bbox, 'hand');
   imshow(z, 'InitialMagnification', 300);
end