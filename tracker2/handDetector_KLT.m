clear all;
close all;

% Create the face detector object.
%handDetector = vision.CascadeObjectDetector();
handDetector = vision.CascadeObjectDetector('D:\tracker2\hand_detector.xml','MergeThreshold',20);
handDetector1 = vision.CascadeObjectDetector('D:\tracker2\hand_detector.xml','MergeThreshold',20);

% Create the point tracker object.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
pointTracker1 = vision.PointTracker('MaxBidirectionalError', 2);

% Create the webcam object.
cam = webcam();

% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

runLoop = true;
numPts = 0;
numPts1 = 0;
frameCount = 0;

while runLoop && frameCount < 4000

    % Get the next frame.
    videoFrame = snapshot(cam);
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;

    if numPts < 10
        % Detection mode.
        bbox = handDetector.step(videoFrameGray);
        
        if ~isempty(bbox)
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));

            % Re-initialize the point tracker.
            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);

            % Save a copy of the points.
            oldPoints = xyPoints;

            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bboxPoints = bbox2points(bbox(1, :));

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);

            % Display a bounding box around the detected face.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display detected corners.
            videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
        end

    else
        % Tracking mode.
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);

        numPts = size(visiblePoints, 1);

        if numPts >= 10
            % Estimate the geometric transformation between the old points
            % and the new points.
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

            % Apply the transformation to the bounding box.
            bboxPoints = transformPointsForward(xform, bboxPoints);

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);

            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display tracked points.
            videoFrame = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'white');

            % Reset the points.
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
        end

    end

        if numPts1 < 10
        % Detection mode.
        bbox1 = handDetector.step(videoFrameGray);
        
        if ~isempty(bbox1)
            % Find corner points1 inside the detected region.
            points1 = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox1(1, :));

            % Re-initialize the point tracker.
            xypoints1 = points1.Location;
            numPts1 = size(xypoints1,1);
            release(pointTracker1);
            initialize(pointTracker1, xypoints1, videoFrameGray);

            % Save a copy of the points1.
            oldpoints1 = xypoints1;

            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bbox1points1 = bbox2points(bbox1(1, :));

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bbox1Polygon = reshape(bbox1points1', 1, []);

            % Display a bounding box around the detected face.
            videoFrame = insertShape(videoFrame, 'Polygon', bbox1Polygon, 'LineWidth', 3);

            % Display detected corners.
            videoFrame = insertMarker(videoFrame, xypoints1, '+', 'Color', 'white');
        end

    else
        % Tracking mode.
        [xypoints1, isFound] = step(pointTracker1, videoFrameGray);
        visiblepoints1 = xypoints1(isFound, :);
        oldInliers1 = oldpoints1(isFound, :);

        numPts1 = size(visiblepoints1, 1);

        if numPts1 >= 10
            % Estimate the geometric transformation between the old points1
            % and the new points1.
            [xform1, oldInliers1, visiblepoints1] = estimateGeometricTransform(...
                oldInliers1, visiblepoints1, 'similarity', 'MaxDistance', 4);

            % Apply the transformation to the bounding box.
            bbox1points1 = transformPointsForward(xform1, bbox1points1);

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bbox1Polygon = reshape(bbox1points1', 1, []);

            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bbox1Polygon, 'LineWidth', 3);

            % Display tracked points1.
            videoFrame = insertMarker(videoFrame, visiblepoints1, '+', 'Color', 'white');

            % Reset the points1.
            oldpoints1 = visiblepoints1;
            setPoints(pointTracker1, oldpoints1);
        end

    end
    
    
    % Display the annotated video frame using the video player object.
    step(videoPlayer, videoFrame);

    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
end

% Clean up.
clear cam;
release(videoPlayer);
release(pointTracker);
release(handDetector);

