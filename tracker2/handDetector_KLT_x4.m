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
            bbox1points1 = bbox12points1(bbox1(1, :));

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
            bbox1points1 = transformpoints1Forward(xform1, bbox1points1);

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bbox1Polygon = reshape(bbox1points1', 1, []);

            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bbox1Polygon, 'LineWidth', 3);

            % Display tracked points1.
            videoFrame = insertMarker(videoFrame, visiblepoints1, '+', 'Color', 'white');

            % Reset the points1.
            oldpoints1 = visiblepoints1;
            setpoints1(pointTracker1, oldpoints1);
        end

    end