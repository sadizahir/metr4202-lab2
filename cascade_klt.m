% Initialisation
clear; % it's always good to clear the workspace!
load('local.mat');

load('calib_img/palm_up_north/pun_pdn_positives_4.mat'); % positives for palm-up and palm-down north
load('calib_img/palm_up_north/puo_positives.mat'); % positives for only the palm area (palm-up)
negativeFolder = fullfile('calib_img', 'palm_up_north', 'negative'); % negative images

% Train the hand detector and palm detector
trainCascadeObjectDetector('pun_detector.xml', pun_pdn_positives_4, negativeFolder, 'FalseAlarmRate', 0.5, 'NumCascadeStages', 17);

% Start up the detectors
detector = vision.CascadeObjectDetector('pun_detector.xml', 'MergeThreshold', 20);
%penDetector = vision.CascadeObjectDetector('tracker2\haar\pen.xml', 'MergeThreshold', 4);
penDetector = vision.CascadeObjectDetector('pen_blargghhh.xml', 'MergeThreshold', 4);

% Create and setup the camera
%cam = webcam(2);
%cam.resolution = '320x240';

% Setup the Kinect
vid1 = imaq.VideoDevice('kinectv2imaq', 1);
vid2 = imaq.VideoDevice('kinectv2imaq', 2);

% Settings
rotations = [0]; % vector of which rotations to make on the input image when searching for a hand

% For testing
testPath = 'calib_img\palm_up_north\histogram_test\Image';
startImg = 12;
stopImg = 100;
debug = 0;

% Containers
active = {}; % cell array to describe the active KLT trackers currently in use
activePoints = {}; % vector containing the number of points for each associated tracker in active
atrack = []; % matrix containing the current bboxes-points for each active tracker
aflags = []; % matrix containing the bboxes for each active tracker
% N.B.: the above three things should have the same amount of elements
% because they are associative with each other!

flag = 1;

while true % infinite loop to capture images, find hands, and track them
%for qwe = startImg:stopImg
   %img = fliplr(snapshot(cam)); % capture the image
   img = fliplr(imresize(step(vid1), [240 450]));
   depth_img = fliplr(imresize(step(vid2), [240 450])*4.5);
   
%    if debug
%     img = imread(strcat(testPath, int2str(qwe), '.png'));
%    end
%    
%    if debug
%        imshow(img);
%    end
   
   % TODO: based on the actively-tracked regions in atrack, we want to
   % block out these regions (make them black) before sending them to the
   % step-detector. That way, we won't detect areas that are currently
   % being tracked by KLT.

   
   % btrack is an N-by-4 matrix where each row is the 4 corners of a
   % slightly scaled-up bounding box generated by step() below, unrotated
   % and corrected to the orientation of img. The idea of btrack is that
   % MATLAB will not add a bounding box to btrack if there's already an
   % overlapping bounding-box.
   btrack = zeros(0, 4);
   
   % For the detection, mask out parts of the image that are currently
   % being tracked in atrack
   mimg = img;
   for i = 1:size(atrack, 2)
       if aflags(i)
           bboxP = reshape(atrack{i}', 1, []);
           mimg = insertShape(mimg, 'FilledPolygon', bboxP, 'Color', 'Black', 'Opacity', 1.0);
       end
   end
  
   
   % Now we have a picture! Step 1: Detect some hands using CascadeObjectDetector
   for i = 1:size(rotations, 2) % iterate through each element of the rotations vector
       angle = rotations(i); % how much to rotate the image
       rimg = imrotate(img, angle); % rotate the image
       bbox = step(detector, mimg); % generate bounding boxes with hands in them (hopefully)
       % TODO: Unrotate the bounding boxes somehow, so they are correct to img and not rimg
       % TODO: Check if bounding box is already in the btrack
       for j = 1:size(bbox, 1)
           sbox = bbox(j,:);
           rbbox = sbox;
           %rbbox = bbox_flip(sbox, angle, size(mimg, 1)); % unrotate bbox
           btrack(size(btrack,1)+1,:) =  rbbox;
       end
   end

   
%    for i = 1:size(btrack, 1)
%         img = insertShape(img, 'Rectangle', btrack(i,:), 'LineWidth', 2);
%    end
      
   % Now we have a group of bounding boxes in btrack that describe detected
   % and not currently-tracked-by-KLT. We need to track them now, so we
   % need to make some trackers based on that information.
   for i = 1:size(btrack, 1) % for each new detected bounding box, make a new tracker
       sbox = btrack(i, :);
       points = detectMinEigenFeatures(rgb2gray(img), 'ROI', sbox); % detect eigen features in ROI defined by the bbox we're on
       pointTracker = vision.PointTracker('MaxBidirectionalError', 2); % create a point tracker
       points = points.Location; % grab the location of the points (self-explanatory...)
       initialize(pointTracker, points, img); % initialise the tracker!
       active{size(active,2)+1} = pointTracker; % add it to the active tracker array
       activePoints{size(activePoints,2)+1} = points; % add the points to the associated array; these are the most recent "old" points found by tracker
       atrack{size(atrack,2)+1} = bbox2points(sbox); % bbox for that particular box which generated the tracker
       aflags(size(aflags,2)+1) = 1; % flag to denote that this tracker is active
   end
   
   % Now that we've initialised new trackers, let's update all the trackers
   % we have and push them to the image
   for i = 1:size(active,2) % iterate through each tracker individually
       if aflags(i) == 0
           continue
       end
       oldPoints = activePoints{i};
       pointTracker = active{i};
       bboxPoints = atrack{i};
       [points, isFound] = step(pointTracker, img);
       visiblePoints = points(isFound, :);
       oldInliers = oldPoints(isFound, :);
       
        if size(visiblePoints, 1) >= 30 % need at least 2 points

            % Estimate the geometric transformation between the old points
            % and the new points and eliminate outliers
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

            % Apply the transformation to the bounding box points
            bboxPoints = transformPointsForward(xform, bboxPoints);

            % Insert a bounding box around the object being tracked
            bboxPolygon = reshape(bboxPoints', 1, []);
            img = insertShape(img, 'Polygon', bboxPolygon, ...
                'LineWidth', 2);
            
            % Figure out the center of the box
            xmin = min(bboxPoints(:, 1));
            xmax = max(bboxPoints(:, 1));
            ymin = min(bboxPoints(:, 2));
            ymax = max(bboxPoints(:, 2));
            width = xmax - xmin;
            height = ymax - ymin;
            xcent = xmin + width/2;
            ycent = ymin + height/2;
            
            
            iP = [xcent, ycent];
            worldPoints = pointsToWorld(cameraParams, R, t, iP);
            
            wP = [worldPoints 0];
            relToCam = wP;
            %wP*R+t; %3x1 matrix  - 3 is wrong
            
            
            depth_point = depth_img(ceil(ycent), ceil(xcent));
            depthlabel = strcat('[', num2str(relToCam(1)/10), ', ', num2str(relToCam(2)/10), ', ', round(num2str(depth_point*100-camWldC(3)/10)), ']');
%             depthlabel = strcat(round(num2str(depth_point*100)), ' cm');
%               , ', Depth:', round(num2str(depth_point*100)), ' cm'
            
            img = insertText(img, [xcent ycent], depthlabel, 'AnchorPoint', 'Center');

            % Display tracked points
            %img = insertMarker(img, visiblePoints, '+', 'Color', 'white');

            % Reset the points
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
            
            % Change the matrix up
            activePoints{i} = oldPoints;
            active{i} = pointTracker;
            atrack{i} = bboxPoints;
        else
            aflags(i) = 0;
        end
   end
   
   
   
   img = insertMarker(img, corner);
   pbbox = step(penDetector, img);
   img = insertObjectAnnotation(img, 'rectangle', pbbox, 'Pen', 'Color', 'cyan');
   imshow(img, 'InitialMagnification', 300);
   
end

