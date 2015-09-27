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
trainCascadeObjectDetector('pun_detector.xml', pun_pdn_positives_4, negativeFolder, 'FalseAlarmRate', 0.5, 'NumCascadeStages', 16);
%trainCascadeObjectDetector('puo_detector.xml', puo_positives, negativeFolder, 'FalseAlarmRate', 0.5, 'NumCascadeStages', 8);

% start the detector
detector = vision.CascadeObjectDetector('pun_detector.xml', 'MergeThreshold', 20);
%palmDetector = vision.CascadeObjectDetector('puo_detector.xml');

%detector = vision.CascadeObjectDetector('tracker2\haar\fist.xml', 'MergeThreshold', 10);
%palmDetector = vision.CascadeObjectDetector('tracker2\haar\palm.xml', 'MergeThreshold', 2);

flag = 0;

%set(0,'DefaultFigureWindowStyle','docked');

rotations = [0:90:360]; % rotate the image like this!

while true
    img = fliplr(snapshot(cam)); % grab the image
    
    for i = 1:4
        angle = rotations(i); % angle with which to rotate the image
        rimg = imrotate(img, angle, 'bilinear'); % rotate the image
        bbox = step(detector, rimg); % grab the bounding box for a possible region with hand in it

        % we now have a bunch of bounding boxes; figure out if any of them
        % should be rejected
        goodrows = 1;
        goodbox = [];

        for i = 1:size(bbox,1)
            % go through each sub-box
            subbox = bbox(i,:);

            % we want to detect a palm in a possible sub-box
            candidate = imcrop(rimg, subbox);

            %cbox = step(palmDetector, candidate);

            % copy to "good boxes" array if the subbox contains a palm
            %if size(cbox,1) > 0
                goodbox(goodrows,:) = bbox(i,:);
                goodrows = goodrows + 1;
            %end

        end

        % reproject bbox
        % goodbox = goodbox*2;

        if size(goodbox,1) > 0
            % insert a bounding box into the image
            detectedImg = insertObjectAnnotation(rimg, 'rectangle', goodbox, 'hand');
            flag = 1;
            
            % because we have a solution, un-rotate the image back to
            % normal for viewing
            detectedImg = imrotate(detectedImg, -angle, 'bilinear', 'crop');
            
            % break the rotation loop; we're done
            break;
        else
            detectedImg = rimg; % just make the detected image sans bounding box
            detectedImg = imrotate(detectedImg, -angle, 'bilinear', 'crop');
        end
    end
    
    % project the edited image to screen
    imshow(img, 'InitialMagnification', 300);
end

% at this point, we have a hand to track!!
tracker = vision.HistogramBasedTracker; % create the tracker

[hueChannel,~,~] = rgb2hsv(img); % convert to HSV

% initialise tracker on hue pixels from palm
initializeObject(tracker, hueChannel, bbox(1,:));

while true
   img = fliplr(snapshot(cam)); % comment out if you don't want mirror image
   [hueChannel,~,~] = rgb2hsv(img); % convert to HSV
   bbox = step(tracker, hueChannel);
   z = insertObjectAnnotation(hueChannel, 'rectangle', bbox, 'hand');
   imshow(z, 'InitialMagnification', 300);
end